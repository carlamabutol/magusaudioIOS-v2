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

protocol AudioPlayerDelegate: AnyObject {
    func audioPlayerDidStartPlaying()
    func audioPlayerDidPause()
    func audioPlayerDidUpdateDuration(duration: TimeInterval)
    func audioPlayerDidUpdateCurrentTime(currentTime: TimeInterval)
}

class AudioPlayer {
    private var avPlayer: AVPlayer?
    private var timeObserver: Any?
    
    weak var delegate: AudioPlayerDelegate?
    
    private let timeRelay = PublishRelay<TimeInterval>()
    var timeObservable: Observable<TimeInterval> { timeRelay.asObservable() }
    private let progressRelay = BehaviorRelay<Float>(value: 0)
    var progressObservable: Observable<Float> { progressRelay.asObservable() }
    private let playerStatus = BehaviorRelay<PlayerStatus>(value: .loading)
    var playerStatusObservable: Observable<PlayerStatus> { playerStatus.asObservable() }
    
    private var observer: NSKeyValueObservation? {
        willSet {
            guard let observer = observer else { return }
            observer.invalidate()
        }
    }
    
    var isPlaying: Bool {
        return avPlayer?.rate != 0.0
    }
    
    var duration: TimeInterval {
        guard let player = avPlayer, let currentItem = player.currentItem else {
            return 0
        }
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    var currentTime: TimeInterval {
        guard let player = avPlayer else {
            return 0
        }
        return CMTimeGetSeconds(player.currentTime())
    }
    
    init(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        avPlayer = AVPlayer(playerItem: playerItem)
        repeatAllAudioPlayers()
        addTimeObserver()
        
        // Register as an observer of the player item's status property
        self.observer = playerItem.observe(\.status, options:  [.new, .old], changeHandler: { [unowned self](playerItem, change) in
            switch playerItem.status {
            case .failed:
                self.playerStatus.accept(.failed)
            case .readyToPlay:
                self.playerStatus.accept(.isReadyToPlay)
            case .unknown:
                self.playerStatus.accept(.unknown)
            @unknown default:
                self.playerStatus.accept(.unknown)
            }
        })
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = avPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            let currentTime = CMTimeGetSeconds(time)
            let duration = self?.duration ?? 0
            let progress = currentTime / duration
            self?.timeRelay.accept(currentTime)
            self?.progressRelay.accept(Float(progress))
        }
    }
    
    private func repeatAllAudioPlayers() {
        avPlayer?.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePlayerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
    }
    
    @objc private func handlePlayerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem,
           avPlayer?.currentItem === playerItem {
            avPlayer?.seek(to: .zero)
            play()
        }
    }
    
    func play() {
        if isPlaying {
            pause()
        } else {
            avPlayer?.play()
            delegate?.audioPlayerDidStartPlaying()
        }
    }
    
    func pause() {
        avPlayer?.pause()
        delegate?.audioPlayerDidPause()
    }
    
}

enum PlayerStatus {
    case loading
    case isReadyToPlay
    case failed
    case unknown
}
