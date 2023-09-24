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
    static let shared = AudioPlayerViewModel()
    private let store: Store
    private let audioPlayerManager = AudioPlayerManager.shared
    var selectedSubliminal: Subliminal?
    var subliminals: [Subliminal] = []
    private let selectedSubliminalRelay = PublishRelay<Subliminal>()
    var selectedSubliminalObservable: Observable<Subliminal> { selectedSubliminalRelay.asObservable() }
    private let selectedAudioPlayer = PublishRelay<AudioPlayer>()
    var timeRelay = BehaviorRelay<String>(value: "--/--")
    var progressRelay = BehaviorRelay<Float>(value: 0)
    let selectedPlayer = BehaviorRelay<Int>(value: 0)
    let audioUrlRelay = BehaviorRelay<[URL]>(value: [])
    var progressObservable: Observable<Float> { progressRelay.asObservable() }
    
    private let playerStatusRelay = BehaviorRelay<PlayerStatus>(value: .unknown)
    var playerStatusObservable: Observable<PlayerStatus> { playerStatusRelay.asObservable() }
    
    var playerDisposeBag = DisposeBag()
    private let subliminalUseCase: SubliminalUseCase
    
    init(dependencies: Dependencies = .standard) {
        store = dependencies.store
        subliminalUseCase = dependencies.subliminalUseCase
        super.init()
        audioPlayerManager.activePlayerObservable
            .subscribe { [weak self] player in
                self?.playerStatusRelay.accept(.isReadyToPlay)
                self?.playBackSubscriber(audioPlayer: player)
            }.disposed(by: disposeBag)
        
    }
    
    var activePlayer: AudioPlayer?
    
    private func playBackSubscriber(audioPlayer: AudioPlayer) {
        activePlayer = audioPlayer
        audioPlayer.progressObservable
            .distinctUntilChanged()
            .bind(to: progressRelay)
            .disposed(by: playerDisposeBag)
        
        audioPlayer.timeObservable
            .map {
                Logger.info("DURATION - \(audioPlayer.getDuration())", topic: .other)
                return $0.toMinuteAndSeconds() + " - " + audioPlayer.getDuration().toMinuteAndSeconds()
            }
            .bind(to: timeRelay)
            .disposed(by: playerDisposeBag)
    }
    
    public func createArrayAudioPlayer(with subliminal: Subliminal) {
        if subliminal.id == selectedSubliminal?.id && activePlayer != nil {
            playBackSubscriber(audioPlayer: activePlayer!)
            return
        }
        selectedSubliminal = subliminal
        selectedSubliminalRelay.accept(subliminal)
        clearAudioPlayers()
        audioPlayerManager.createAudioPlayers(with: subliminal, isPlaying: playerStatusRelay.value == .isPlaying)
    }
    
    func clearAudioPlayers() {
        pauseAllAudio()
        playerStatusRelay.accept(.loading)
        timeRelay.accept("--/--")
        progressRelay.accept(0)
        playerDisposeBag = DisposeBag()
        audioPlayerManager.removePlayers()
    }

    func playAudio() {
        if playerStatusRelay.value == .isPlaying {
            pauseAllAudio()
        } else {
            playerStatusRelay.accept(.isPlaying)
            audioPlayerManager.playAllAudioPlayers()
        }
    }
    
    func pauseAllAudio() {
        playerStatusRelay.accept(.isPaused)
        audioPlayerManager.pauseAllAudioPlayers()
    }
    
    func next() {
        var currentIndex = 0
        if let index = subliminals.firstIndex(where: { $0.subliminalID == selectedSubliminal?.subliminalID ?? ""}) {
            currentIndex = index
        }
        let index = currentIndex + 1
        if index < (subliminals.count - 1) {
            createArrayAudioPlayer(with: subliminals[index])
        }
    }
    
    func previous() {
        var currentIndex = 0
        if let index = subliminals.firstIndex(where: { $0.subliminalID == selectedSubliminal?.subliminalID ?? ""}) {
            currentIndex = index
        }
        let index = currentIndex - 1
        if index < (subliminals.count - 1) {
            createArrayAudioPlayer(with: subliminals[index])
        } else {
            
        }
    }
    
    func updateFavorite() {
        guard let selectedSubliminal = selectedSubliminal else { return }
        Task {
            do {
                var subliminal = selectedSubliminal
                subliminal.isLiked = subliminal.isLiked == 0 ? 1 : 0
                if selectedSubliminal.isLiked == 0 {
                    let _ = try await subliminalUseCase.addToFavorite(id: selectedSubliminal.subliminalID)
                    Logger.info("Successfully added to favorite", topic: .presentation)
                } else {
                    let _ = try await subliminalUseCase.deleteToFavorite(id: selectedSubliminal.subliminalID)
                    Logger.info("Successfully removed from favorite", topic: .presentation)
                }
                self.selectedSubliminal = subliminal
                self.selectedSubliminalRelay.accept(subliminal)
                self.store.appState.selectedSubliminal = subliminal
            } catch {
                Logger.info("Failed to update favorite \(error)", topic: .presentation)
            }
        }
    }
}

extension AudioPlayerViewModel {
    
    struct Dependencies {
        let networkService: NetworkService
        let subliminalUseCase: SubliminalUseCase
        let store: Store
        
        static var standard: Dependencies {
            return .init(
                networkService: SharedDependencies.sharedDependencies.networkService,
                subliminalUseCase: SharedDependencies.sharedDependencies.useCases.subliminalUseCase,
                store: SharedDependencies.sharedDependencies.store
            )
        }
    }
    
}
