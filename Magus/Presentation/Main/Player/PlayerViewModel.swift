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
    
    private let selectedAudioPlayer = PublishRelay<AudioPlayer>()
    var timeRelay = PublishRelay<String>()
    var progressRelay = PublishRelay<Float>()
    let selectedPlayer = BehaviorRelay<Int>(value: 0)
    let audioUrlRelay = BehaviorRelay<[URL]>(value: [])
    
    var playerDisposeBag = DisposeBag()
    
    override init() {
        super.init()
        selectedAudioPlayer.asObservable()
            .subscribe { [weak self] audioPlayer in
                self?.playBackSubscriber(audioPlayer: audioPlayer)
            }.disposed(by: disposeBag)
    }
    
    var activePlayer: AudioPlayer? {
        get {
            guard !audioPlayerManager.audioPlayers.isEmpty && !audioUrlRelay.value.isEmpty else { return nil }
            return audioPlayerManager.audioPlayers[audioUrlRelay.value[selectedPlayer.value]]
        }
    }
    
    private func playBackSubscriber(audioPlayer: AudioPlayer) {
        playerDisposeBag = DisposeBag()
        audioPlayer.progressObservable
            .subscribe { [weak self] progressRelay in
                Logger.info("Play Time - \(progressRelay)", topic: .presentation)
                self?.progressRelay.accept(progressRelay)
            }
            .disposed(by: playerDisposeBag)
    }

    @discardableResult
    func createAudioPlayer(with url: URL) -> AudioPlayer? {
        audioPlayerManager.createAudioPlayer(with: url)
    }
    
    func createArrayAudioPlayer(with strings: [String]) {
        clearAudioPlayers()
        var urls: [URL] = []
        let defaultStrings = ["https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3"]
        for urlString in defaultStrings {
            guard let url = URL(string: urlString) else {
                Logger.info("Incorrect URL \(urlString)", topic: .presentation)
                continue
            }
            createAudioPlayer(with: url)
            urls.append(url)
        }
        selectedPlayer.accept(0)
        audioUrlRelay.accept(urls)
        guard let selectedPlayer = activePlayer else { return }
        selectedAudioPlayer.accept(selectedPlayer)
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
