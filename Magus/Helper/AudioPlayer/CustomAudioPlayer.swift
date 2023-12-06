//
//  AudioPlayer.swift
//  Magus
//
//  Created by Jomz on 8/15/23.
//

import Foundation
import AVFoundation
import RxSwift
import RxRelay
import SwiftAudioEx

protocol AudioPlayerDelegate: AnyObject {
    func audioPlayerDidStartPlaying()
    func audioPlayerDidPause()
    func audioPlayerDidUpdateDuration(duration: TimeInterval)
    func audioPlayerDidUpdateCurrentTime(currentTime: TimeInterval)
}

class CustomAudioPlayer {
    private var avUrlAsset: AVURLAsset?
    private var avPlayer: AVPlayer?
    private var audioPlayer: AudioPlayer?
    private var timeObserver: Any?
    private var fadeTimer: Timer?
    
    weak var delegate: AudioPlayerDelegate?
    
    private let timeRelay = BehaviorRelay<TimeInterval>(value: 0)
    var timeObservable: Observable<TimeInterval> { timeRelay.asObservable() }
    private let progressRelay = BehaviorRelay<Float>(value: 0)
    var progressObservable: Observable<Float> { progressRelay.asObservable() }
    private let playerStatus = BehaviorRelay<PlayerStatus>(value: .loading)
    var playerStatusObservable: Observable<PlayerStatus> { playerStatus.asObservable() }
    private let didEndRelay = PublishRelay<Void>()
    var didEndObservable: Observable<Void> { didEndRelay.asObservable() }
    
    private var observer: NSKeyValueObservation? {
        willSet {
            guard let observer = observer else { return }
            observer.invalidate()
        }
    }
    
    var isPlaying: Bool {
        return avPlayer?.rate != 0.0
    }
    
    private var duration: TimeInterval = 0
    
    var currentTime: TimeInterval {
        guard let player = avPlayer else {
            return 0
        }
        return CMTimeGetSeconds(player.currentTime())
    }
    
    init(url: URL, isPlaying: Bool = false) {
        let asset = AVAsset(url: url)
        let playerItem: AVPlayerItem = AVPlayerItem(asset: asset)
        avPlayer = AVPlayer(playerItem: playerItem)
        avPlayer?.automaticallyWaitsToMinimizeStalling = false
        repeatAllAudioPlayers()
        addTimeObserver() 
        // Register as an observer of the player item's status property
        observer = playerItem.observe(\.status, options:  [.new, .old], changeHandler: { [weak self](playerItem, change) in
            guard let self else { return }
            switch playerItem.status {
            case .failed:
                self.playerStatus.accept(.failed)
            case .readyToPlay:
                Logger.info("HEYY", topic: .other)
                self.playerStatus.accept(.isReadyToPlay)
                if isPlaying {
                    self.play()
                }
            case .unknown:
                self.playerStatus.accept(.unknown)
            @unknown default:
                self.playerStatus.accept(.unknown)
            }
        })
        
    }
    
    func getExactDuration() {
        avUrlAsset?.loadValuesAsynchronously(forKeys: ["duration"], completionHandler: {
            debugPrint(self.avUrlAsset!.duration)
            
        })

    }
    
    func setDuration(duration: Int) {
        self.duration = TimeInterval(duration / 1000)
    }
    
    func setVolume(volume: Float) {
        // Ensure the volume is within the valid range
        let clampedValue = min(max(volume, 0.0), 1.0)
        Logger.info("Volume \(volume) -- \(clampedValue)", topic: .other)
        fadeTimer = avPlayer?.fadeVolume(from: avPlayer?.volume ?? 0, to: clampedValue, duration: 1)
    }
    
    func getDuration() -> TimeInterval {
        return duration
    }

    // Don't forget to remove the observer when it's no longer needed (e.g., in deinit)
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVAssetDurationDidChange, object: nil)
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = nil
        timeObserver = avPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            if (self?.playerStatus.value == .isReadyToPlay || self?.playerStatus.value == .isPlaying) == true {
                let currentTime = CMTimeGetSeconds(time)
                let duration = self?.duration ?? 0
                let progress = Float(currentTime / duration)
                self?.updateTimeAndProgress(time: currentTime, progress: progress)
            }
        }
    }
    
    private func updateTimeAndProgress(time: TimeInterval, progress: Float) {
        timeRelay.accept(currentTime)
        progressRelay.accept(Float(progress))
    }
    
    private func repeatAllAudioPlayers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePlayerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
    }
    
    @objc private func handlePlayerItemDidReachEnd(notification: Notification) {
        Logger.info("did reach end", topic: .network)
        if let playerItem = notification.object as? AVPlayerItem,
           avPlayer?.currentItem === playerItem {
            playAtStart(playAgain: false)
            didEndRelay.accept(())
        }
    }
    
    func play() {
        avPlayer?.play()
        playerStatus.accept(.isPlaying)
    }
    
    func playAtStart(playAgain: Bool) {
        updateTimeAndProgress(time: 0, progress: 0)
        avPlayer?.currentItem?.seek(to: .zero, completionHandler: { [weak self] _ in
            if playAgain {
                self?.play()
            } else {
                self?.pause()
            }
        })
    }
    
    func pause() {
        playerStatus.accept(.isPaused)
        avPlayer?.pause()
    }
    
}

enum PlayerStatus {
    case loading
    case isReadyToPlay
    case isPlaying
    case isPaused
    case failed
    case unknown
}
