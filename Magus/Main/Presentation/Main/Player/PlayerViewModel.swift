//
//  PlayerViewModel.swift
//  Magus
//
//  Created by Jomz on 8/15/23.
//

import Foundation
import AVFoundation
import RxRelay
import RxSwift

class AudioPlayerViewModel: ViewModel {
    private let audioPlayerManager = AudioPlayerManager.shared
    var selectedSubliminal: Subliminal?
    private let selectedAudioPlayer = PublishRelay<AudioPlayer>()
    var timeRelay = PublishRelay<String>()
    var progressRelay = PublishRelay<Float>()
    let selectedPlayer = BehaviorRelay<Int>(value: 0)
    let audioUrlRelay = BehaviorRelay<[URL]>(value: [])
    
    var progressObservable: Observable<Float> { progressRelay.asObservable() }
    
    var playerDisposeBag = DisposeBag()
    
    override init() {
        super.init()
        
        audioPlayerManager.activePlayerObservable
            .subscribe { [weak self] player in
                self?.playBackSubscriber(audioPlayer: player)
            }.disposed(by: disposeBag)
        
    }
    
    var activePlayer: AudioPlayer?
    
    private func playBackSubscriber(audioPlayer: AudioPlayer) {
        playerDisposeBag = DisposeBag()
        activePlayer = audioPlayer
        audioPlayer.progressObservable
            .subscribe { [weak self] progressRelay in
                self?.progressRelay.accept(progressRelay)
            }
            .disposed(by: playerDisposeBag)
        
        audioPlayer.timeObservable
            .subscribe { [weak self] time in
                self?.timeRelay.accept(time.toMinuteAndSeconds())
            }
            .disposed(by: playerDisposeBag)
    }
    
    func createArrayAudioPlayer(with subliminal: Subliminal) {
        print("CHECK IDS - \(subliminal.id) == \(selectedSubliminal?.id)")
        if subliminal.id == selectedSubliminal?.id {
            return
        }
        let audios: [URL] = subliminal.info.compactMap { $0.link }.compactMap { URL(string: $0) }
        selectedSubliminal = subliminal
        clearAudioPlayers()
        var urls: [URL] = []
        let defaultStrings = ["https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3"]
        for x in 0...(subliminal.info.count - 1) {
            guard let url = URL(string: defaultStrings[x]) else {
                Logger.info("Incorrect URL \(defaultStrings[x])", topic: .presentation)
                continue
            }
            audioPlayerManager.createAudioPlayer(with: subliminal.info[x], url: url)
            urls.append(url)
        }
//        selectedPlayer.accept(0)
//        audioUrlRelay.accept(urls)
//        guard let selectedPlayer = activePlayer else { return }
//        selectedAudioPlayer.accept(selectedPlayer)
    }
    
    func clearAudioPlayers() {
        audioPlayerManager.removePlayers()
    }

    func playAudio() {
        audioPlayerManager.playAllAudioPlayers()
    }
    
    func pauseAllAudio() {
        audioPlayerManager.pauseAllAudioPlayers()
    }
    
    func next() {
        let index = selectedPlayer.value
        if index < (audioUrlRelay.value.count - 1) {
            selectedPlayer.accept(index + 1)
            guard let selectedPlayer = activePlayer else { return }
            selectedAudioPlayer.accept(selectedPlayer)
        }
    }
    
    func previous() {
        let index = selectedPlayer.value
        if index > 0 {
            selectedPlayer.accept(index - 1)
            guard let selectedPlayer = activePlayer else { return }
            selectedAudioPlayer.accept(selectedPlayer)
        }
    }
}
