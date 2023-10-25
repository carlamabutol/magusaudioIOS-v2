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
    private var avUrlAsset: AVAsset?
    private var avPlayer: AVPlayer?
    private var audioPlayer: AudioPlayer?
    private var timeObserver: Any?
    
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
        
//        audioPlayer = AudioPlayer()
//        let audioItem = DefaultAudioItem(audioUrl: url.absoluteString, sourceType: .stream)
//        audioPlayer?.load(item: audioItem, playWhenReady: true) // Load the item and start playing when the player is ready.
        repeatAllAudioPlayers()
        addTimeObserver()
        // Register as an observer of the player item's status property
        observer = playerItem.observe(\.status, options:  [.new, .old], changeHandler: { [unowned self](playerItem, change) in
            switch playerItem.status {
            case .failed:
                self.playerStatus.accept(.failed)
            case .readyToPlay:
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
    
    func setDuration(duration: Int) {
        self.duration = TimeInterval(duration / 1000)
    }
    
    func setVolume(volume: Int) {
        avPlayer?.volume = Float(volume)
    }
    
    func getDuration() -> TimeInterval {
        return duration
    }
    
    // Function to handle the notification
    @objc func assetDurationDidChange(_ notification: Notification) {
        if let asset = notification.object as? AVAsset {
            // The duration of the asset has changed
            let duration = CMTimeGetSeconds(asset.duration)
            print("Asset Duration Changed: \(duration) seconds")
        }
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
                let progress = currentTime / duration
                self?.timeRelay.accept(currentTime)
                self?.progressRelay.accept(Float(progress))
            }
        }
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
            playAtStart()
            didEndRelay.accept(())
        }
    }
    
    func play() {
        avPlayer?.play()
        playerStatus.accept(.isPlaying)
    }
    
    func playAtStart() {
        avPlayer?.currentItem?.seek(to: .zero, completionHandler: { [weak self] _ in
            self?.repeatAllAudioPlayers()
            self?.addTimeObserver()
            self?.avPlayer?.play()
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
