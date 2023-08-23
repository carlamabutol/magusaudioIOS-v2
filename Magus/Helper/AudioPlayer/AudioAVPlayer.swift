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

    init() {
        playerStatusObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.setActiveLongestDurationPlayer()
            }.disposed(by: disposeBag)
        
    }
    
    private func setActiveLongestDurationPlayer() {
        let player = audioPlayers.max { old, new in
            return old.value.duration > new.value.duration
        }?.value
        activePlayer.accept(player)
    }

    func createAudioPlayer(with subliminalAudioInfo: SubliminalAudioInfo, url: URL) {
        if audioPlayers.contains(where: { $0.key.id == subliminalAudioInfo.id }) {
            return
        }
        
        let newPlayer = AudioPlayer(url: url)
        newPlayer.playerStatusObservable
            .subscribe { [weak self] status in
                guard status == .isReadyToPlay else { return }
                self?.setActiveLongestDurationPlayer()
            }.disposed(by: disposeBag)
        audioPlayers[subliminalAudioInfo] = newPlayer
    }
    
    func playAllAudioPlayers() {
        if audioPlayers.first?.value.isPlaying == true {
            for (_, player) in audioPlayers {
                player.pause()
            }
        } else {
            for (_, player) in audioPlayers {
                player.play()
            }
        }
    }
    
    func pauseAllAudioPlayers() {
        for (_, player) in audioPlayers {
            player.pause()
        }
    }
    
    func getLongestDuration() -> Double {
        audioPlayers.map { $0.value.duration }.reduce(0, +)
    }
    
    func removePlayers() {
        audioPlayers.removeAll()
        disposeBag = DisposeBag()
    }
}
