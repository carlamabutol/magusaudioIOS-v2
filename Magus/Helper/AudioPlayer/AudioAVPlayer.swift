//
//  AudioAVPlayer.swift
//  Magus
//
//  Created by Jomz on 8/15/23.
//

import Foundation
import AVFoundation
import RxSwift
import RxRelay

class AudioPlayerManager {
    static let shared = AudioPlayerManager()
    private var disposeBag = DisposeBag()
    private var playerDisposeBag = DisposeBag()
    
    var currentSubliminal: String = ""
    var currentTracks: Int = 0
    var audioPlayers: [String: CustomAudioPlayer] = [:]
    private let playerStatusUpdate = PublishRelay<Void>()
    private let activePlayer = BehaviorRelay<CustomAudioPlayer?>(value: nil)
    private let isPlayingRelay = BehaviorRelay<Bool>(value: false)
    var activePlayerObservable: Observable<CustomAudioPlayer> {
        activePlayer
            .compactMap{ $0 }
            .asObservable()
        
    }
    var playerStatusObservable: Observable<Void> { playerStatusUpdate.asObservable() }
    // Observer
    private let session = AVAudioSession.sharedInstance()
    private var progressObserver: NSKeyValueObservation!

    init() {
        playerStatusObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.setActiveLongestDurationPlayer()
            }.disposed(by: disposeBag)
        
        do {
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("cannot activate session")
        }

        progressObserver = session.observe(\.outputVolume) { (session, value) in
            print(session.outputVolume)
        }
    }
    
    @objc private func systemVolumeDidChange(notification: NSNotification) {

        print(notification.userInfo?["AVSystemController_AudioVolumeNotificationParameter"] as? Float)
    }
    
    private func setActiveLongestDurationPlayer() {
        Logger.info("SET ACTIVE LONGEST DURATION -x \(audioPlayers.map { $0.value.getDuration() })", topic: .other)
        let player = audioPlayers.max { old, new in
            return new.value.getDuration() > old.value.getDuration()
        }?.value
        Logger.info("SET ACTIVE LONGEST DURATION 1 - \(player)", topic: .other)
        if getCurrentTracks().count == currentTracks {
            activePlayer.accept(player)
        }
    }

    fileprivate func updatePlayerStatus(isPlaying: Bool, player: CustomAudioPlayer) {
        if isPlaying {
            player.play()
        } else {
            player.pause()
        }
    }
    
    func createAudioPlayers(with subliminal: Subliminal, isPlaying: Bool = false) {
        currentSubliminal = subliminal.subliminalID
        currentTracks = 0
        removePlayers()
        for audio in subliminal.info {
            /// sample url https://samplelib.com/lib/preview/mp3/sample-15s.mp3
            guard let url = URL(string: audio.link ?? "") else {
                Logger.info("Incorrect URL \(String(describing: audio.link))", topic: .presentation)
                continue
            }
            createAudioPlayer(with: audio, url: url, isPlaying: isPlaying)
        }
    }
    
    func createAudioPlayer(with subliminalAudioInfo: SubliminalAudioInfo, url: URL, isPlaying: Bool = false) {
        if let player = audioPlayers.first(where: { $0.key == subliminalAudioInfo.trackID })?.value {
            updatePlayerStatus(isPlaying: isPlaying, player: player)
            currentTracks += 1
            return
        }
        playerDisposeBag = DisposeBag()
        let newPlayer = CustomAudioPlayer(url: url, isPlaying: isPlaying)
        newPlayer.setDuration(duration: subliminalAudioInfo.duration)
        newPlayer.setVolume(volume: Float(subliminalAudioInfo.volume))
        newPlayer.playerStatusObservable
            .subscribe { [weak self] status in
                guard status == .isReadyToPlay else { return }
                self?.setActiveLongestDurationPlayer()
            }.disposed(by: playerDisposeBag)
        audioPlayers[subliminalAudioInfo.trackID] = newPlayer
        currentTracks += 1
    }
    
    func getCurrentTracks() -> [CustomAudioPlayer] {
        return audioPlayers.map { $0.value }
    }
    
    func playAllAudioPlayers() {
        getCurrentTracks().forEach { $0.play() }
    }
    
    func playAgainAllAudioPlayers(playAgain: Bool) {
        getCurrentTracks().forEach { $0.playAtStart(playAgain: playAgain) }
    }
    
    func pauseAllAudioPlayers() {
        getCurrentTracks().forEach {
            $0.pause()
        }
    }
    
    func getLongestDuration() -> Double {
        getCurrentTracks().map { $0.getDuration() }.max() ?? 0
    }
    
    func removePlayers() {
        audioPlayers.removeAll()
        disposeBag = DisposeBag()
    }
    
    func updateVolume(level: Float, trackID: String) {
        guard let player = audioPlayers[trackID] as? CustomAudioPlayer else {
            Logger.error("No Audio Player is associated with track ID \(trackID)", topic: .configuration)
            return
        }
        player.setVolume(volume: level)
    }
}
