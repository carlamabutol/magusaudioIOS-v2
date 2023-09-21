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
    typealias SubliminalTracks = [[SubliminalAudioInfo: AudioPlayer]]
    static let shared = AudioPlayerManager()
    private var disposeBag = DisposeBag()
    
    var currentSubliminal: String = ""
    var currentTracks: Int = 0
    var audioPlayers: [SubliminalAudioInfo: AudioPlayer] = [:]
    private let playerStatusUpdate = PublishRelay<Void>()
    private let activePlayer = BehaviorRelay<AudioPlayer?>(value: nil)
    private let isPlayingRelay = BehaviorRelay<Bool>(value: false)
    var activePlayerObservable: Observable<AudioPlayer> {
        activePlayer
            .compactMap{ $0 }
            .asObservable()
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
        
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

        progressObserver = session.observe(\.outputVolume) { [weak self] (session, value) in
            print(session.outputVolume)
        }
    }
    
    @objc private func systemVolumeDidChange(notification: NSNotification) {

        print(notification.userInfo?["AVSystemController_AudioVolumeNotificationParameter"] as? Float)
    }
    
    private func setActiveLongestDurationPlayer() {
        let player = audioPlayers.max { old, new in
            return old.value.getDuration() > new.value.getDuration()
        }?.value
        
        if getCurrentTracks().count == currentTracks {
            activePlayer.accept(player)
        }
    }

    fileprivate func updatePlayerStatus(isPlaying: Bool, player: AudioPlayer) {
        if isPlaying {
            player.play()
        } else {
            player.pause()
        }
    }
    
    func createAudioPlayers(with subliminal: Subliminal, isPlaying: Bool = false) {
        currentSubliminal = subliminal.subliminalID
        currentTracks = 0
        for audio in subliminal.info {
            guard let url = URL(string: audio.link ?? "") else {
                Logger.info("Incorrect URL \(audio.link)", topic: .presentation)
                continue
            }
            createAudioPlayer(with: audio, url: url, isPlaying: isPlaying)
        }
    }
    
    func createAudioPlayer(with subliminalAudioInfo: SubliminalAudioInfo, url: URL, isPlaying: Bool = false) {
        if let player = audioPlayers.first(where: { $0.key.id == subliminalAudioInfo.id })?.value {
            updatePlayerStatus(isPlaying: isPlaying, player: player)
            currentTracks += 1
            return
        }
        
        let newPlayer = AudioPlayer(url: url, isPlaying: isPlaying)
        newPlayer.setDuration(duration: subliminalAudioInfo.duration)
        newPlayer.setVolume(volume: subliminalAudioInfo.volume)
        updatePlayerStatus(isPlaying: isPlaying, player: newPlayer)
        newPlayer.playerStatusObservable
            .subscribe { [weak self] status in
                guard status == .isReadyToPlay else { return }
                self?.setActiveLongestDurationPlayer()
            }.disposed(by: disposeBag)
        audioPlayers[subliminalAudioInfo] = newPlayer
        currentTracks += 1
    }
    
    func getCurrentTracks() -> [AudioPlayer] {
        return audioPlayers.filter { $0.key.subliminalID == currentSubliminal }.map { $0.value }
    }
    
    func playAllAudioPlayers() {
        getCurrentTracks().forEach { $0.play() }
    }
    
    func pauseAllAudioPlayers() {
        getCurrentTracks().forEach { $0.pause() }
    }
    
    func getLongestDuration() -> Double {
        getCurrentTracks().map { $0.getDuration() }.max() ?? 0
    }
    
    func removePlayers() {
        audioPlayers.removeAll()
        disposeBag = DisposeBag()
    }
}
