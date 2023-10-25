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
    private let appState: AppState
    private let store: Store
    private let audioPlayerManager = AudioPlayerManager.shared
    var selectedSubliminal: Subliminal?
    private let selectedSubliminalRelay = PublishRelay<Subliminal>()
    var selectedSubliminalObservable: Observable<Subliminal> { selectedSubliminalRelay.asObservable() }
    private let selectedAudioPlayer = PublishRelay<CustomAudioPlayer>()
    var timeRelay = BehaviorRelay<String>(value: "--/--")
    var progressRelay = BehaviorRelay<Float>(value: 0)
    var progressObservable: Observable<Float> { progressRelay.asObservable() }
    
    let repeatStatus = BehaviorRelay<Repeat>(value: .repeatAll)
    private let playerStatusRelay = BehaviorRelay<PlayerStatus>(value: .unknown)
    var playerStatusObservable: Observable<PlayerStatus> { playerStatusRelay.asObservable() }
    var playerStateObservable: Observable<AppState.PlayerState>
    var isRepealAllObservable: Observable<Bool>
    var playerDisposeBag = DisposeBag()
    private let subliminalUseCase: SubliminalUseCase
    private let subliminals: () -> [Subliminal]
    
    init(dependencies: Dependencies = .standard) {
        appState = dependencies.appState
        store = dependencies.store
        subliminalUseCase = dependencies.subliminalUseCase
        playerStateObservable = dependencies.playerState
        isRepealAllObservable = dependencies.isRepeatAll
        subliminals = dependencies.subliminals
        super.init()
        audioPlayerManager.activePlayerObservable
            .subscribe { [weak self] player in
                self?.playerStatusRelay.accept(.isReadyToPlay)
                self?.playBackSubscriber(audioPlayer: player)
            }.disposed(by: disposeBag)
        
    }
    
    var activePlayer: CustomAudioPlayer?
    
    private func playBackSubscriber(audioPlayer: CustomAudioPlayer) {
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
        
        audioPlayer.didEndObservable
            .subscribe { [weak self] _ in
                self?.didEndPlayer()
            }.disposed(by: playerDisposeBag)
        
        audioPlayer.playerStatusObservable
            .subscribe { [weak self] status in
                if status == .isPlaying {
                    self?.store.appState.playerState = .isPlaying
                } else {
                    self?.store.appState.playerState = .isPaused
                }
            }
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
        audioPlayerManager.createAudioPlayers(with: subliminal, isPlaying: true)
    }
    
    func clearAudioPlayers() {
        pauseAllAudio()
        playerStatusRelay.accept(.loading)
        timeRelay.accept("--/--")
        progressRelay.accept(0)
        playerDisposeBag = DisposeBag()
        audioPlayerManager.removePlayers()
    }
    
    func playAll() {
        playerStatusRelay.accept(.isPlaying)
        audioPlayerManager.playAllAudioPlayers()
    }
    
    func playAllAtStart() {
        playerStatusRelay.accept(.isPlaying)
        audioPlayerManager.playAgainAllAudioPlayers()
    }

    func playAudio() {
        if playerStatusRelay.value == .isPlaying {
            pauseAllAudio()
        } else {
            playAll()
        }
    }
    
    private func didEndPlayer() {
        switch repeatStatus.value {
        case .repeatOnce:
            playAll()
        case .repeatAll:
            next()
        case .noRepeat:
            break
        }
    }
    
    func pauseAllAudio() {
        playerStatusRelay.accept(.isPaused)
        audioPlayerManager.pauseAllAudioPlayers()
    }
    
    func next() {
        let subliminals = self.subliminals()
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
        let subliminals = self.subliminals()
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
    
    func updateRepat() {
        switch repeatStatus.value {
        case .repeatAll:
            repeatStatus.accept(.repeatOnce)
        case .repeatOnce:
            repeatStatus.accept(.repeatAll)
        case .noRepeat:
            repeatStatus.accept(.repeatAll)
        }
    }
}

extension AudioPlayerViewModel {
    
    enum Repeat {
        case repeatOnce
        case repeatAll
        case noRepeat
    }
    
}

extension AudioPlayerViewModel {
    
    struct Dependencies {
        let networkService: NetworkService
        let subliminalUseCase: SubliminalUseCase
        let appState: AppState
        let store: Store
        let playerState: Observable<AppState.PlayerState>
        let isRepeatAll: Observable<Bool>
        let subliminals: () -> [Subliminal]
        
        static var standard: Dependencies {
            return .init(
                networkService: SharedDependencies.sharedDependencies.networkService,
                subliminalUseCase: SharedDependencies.sharedDependencies.useCases.subliminalUseCase,
                appState: SharedDependencies.sharedDependencies.store.appState,
                store: SharedDependencies.sharedDependencies.store,
                playerState: SharedDependencies.sharedDependencies.store.observable(of: \.playerState),
                isRepeatAll: SharedDependencies.sharedDependencies.store.observable(of: \.isRepeatAll),
                subliminals: { SharedDependencies.sharedDependencies.store.appState.subliminals }
            )
        }
    }
    
}
