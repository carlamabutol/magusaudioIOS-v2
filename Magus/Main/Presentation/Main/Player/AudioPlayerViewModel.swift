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
    var playerDisposeBag = DisposeBag()
    
    private let appState: AppState
    private let store: Store
    private let audioPlayerManager = AudioPlayerManager.shared
    private let subliminalUseCase: SubliminalUseCase
    private let subliminalQueue: () -> [Subliminal]
    private let addedQueue: () -> [Subliminal]
    private let playlistQueue: () -> [Subliminal]
    
    private let selectedSubliminalRelay = PublishRelay<Subliminal>()
    var selectedSubliminal: Subliminal?
    var selectedSubliminalObservable: Observable<Subliminal> { selectedSubliminalRelay.asObservable() }
    var timeRelay = BehaviorRelay<String>(value: "--/--")
    var progressRelay = BehaviorRelay<Float>(value: 0)
    var progressObservable: Observable<Float> { progressRelay.asObservable() }
    
    let repeatStatus = BehaviorRelay<Repeat>(value: .repeatAll)
    private let playerStatusRelay = BehaviorRelay<PlayerStatus>(value: .unknown)
    var playerStatusObservable: Observable<PlayerStatus> { playerStatusRelay.asObservable() }
    var playerStateObservable: Observable<AppState.PlayerState>
    var isRepealAllObservable: Observable<Bool>
    var repeatedSubliminals: [String] = []
    
    init(dependencies: Dependencies = .standard) {
        appState = dependencies.appState
        store = dependencies.store
        subliminalUseCase = dependencies.subliminalUseCase
        playerStateObservable = dependencies.playerState
        isRepealAllObservable = dependencies.isRepeatAll
        subliminalQueue = dependencies.subliminalQueue
        addedQueue = dependencies.addedQueue
        playlistQueue = dependencies.playlistQeueu
        super.init()
        audioPlayerManager.activePlayerObservable
            .subscribe { [weak self] player in
                self?.playerStatusRelay.accept(.isReadyToPlay)
                self?.playBackSubscriber(audioPlayer: player)
            }.disposed(by: disposeBag)
    }
    
    var activePlayer: CustomAudioPlayer?
    
    private func playBackSubscriber(audioPlayer: CustomAudioPlayer) {
        playerDisposeBag = DisposeBag()
        activePlayer = audioPlayer
        audioPlayer.progressObservable
            .distinctUntilChanged()
            .bind(to: progressRelay)
            .disposed(by: playerDisposeBag)
        
        audioPlayer.timeObservable
            .map {
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
    
    func playAll() {
        playerStatusRelay.accept(.isPlaying)
        audioPlayerManager.playAllAudioPlayers()
    }
    
    func resetPlayer(playAgain: Bool) {
        playerStatusRelay.accept(.isPlaying)
        audioPlayerManager.playAgainAllAudioPlayers(playAgain: playAgain)
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
        case .repeatCurrentlyPlaying:
            resetPlayer(playAgain: true)
        case .repeatAll:
            resetPlayer(playAgain: false)
            next()
//        case .noRepeat:
//            resetPlayer(playAgain: false)
        }
    }
    
    func pauseAllAudio() {
        playerStatusRelay.accept(.isPaused)
        audioPlayerManager.pauseAllAudioPlayers()
    }
    
    func next() {
        let subliminalQueue = self.subliminalQueue()
        let addedQueue = self.addedQueue()
        var currentIndex = 0
        if let index = subliminalQueue.firstIndex(where: { $0.subliminalID == selectedSubliminal?.subliminalID ?? ""}) {
            currentIndex = index
        }
        currentIndex += 1
        switch repeatStatus.value {
        case .repeatAll:
            if currentIndex < (subliminalQueue.count - 1) {
                store.appState.selectedSubliminal = subliminalQueue[currentIndex]
            } else if currentIndex == (subliminalQueue.count - 1) {
                if let addedQueueIndex = addedQueue.firstIndex(where: { $0.subliminalID == selectedSubliminal?.subliminalID ?? ""}) {
                    currentIndex = addedQueueIndex
                }
                if currentIndex < (subliminalQueue.count - 1) {
                    store.appState.selectedSubliminal = addedQueue[currentIndex]
                } else {
                    store.appState.selectedSubliminal = subliminalQueue[0]
                }
            } else {
                store.appState.selectedSubliminal = subliminalQueue[0]
            }
        case .repeatCurrentlyPlaying:
            guard let selectedSubliminal = self.selectedSubliminal else { return }
            createArrayAudioPlayer(with: selectedSubliminal)
        }
    }
    
    func previous() {
        let subliminalQueue = self.subliminalQueue()
        let addedQueue = self.addedQueue()
        var currentIndex = 0
        if let index = subliminalQueue.firstIndex(where: { $0.subliminalID == selectedSubliminal?.subliminalID ?? ""}) {
            currentIndex = index
        }
        let index = currentIndex - 1
        switch repeatStatus.value {
        case .repeatAll:
            if currentIndex < (subliminalQueue.count - 1) {
                store.appState.selectedSubliminal = subliminalQueue[currentIndex]
            } else if currentIndex == (subliminalQueue.count - 1) {
                if let addedQueueIndex = addedQueue.firstIndex(where: { $0.subliminalID == selectedSubliminal?.subliminalID ?? ""}) {
                    currentIndex = addedQueueIndex
                }
                if currentIndex < (subliminalQueue.count - 1) {
                    store.appState.selectedSubliminal = addedQueue[currentIndex]
                } else {
                    store.appState.selectedSubliminal = subliminalQueue[0]
                }
            } else {
                store.appState.selectedSubliminal = subliminalQueue[0]
            }
        case .repeatCurrentlyPlaying:
            guard let selectedSubliminal = self.selectedSubliminal else { return }
            createArrayAudioPlayer(with: selectedSubliminal)
        }
    }
    
    func updateFavorite() {
        guard let selectedSubliminal = selectedSubliminal else { return }
        var subliminal = selectedSubliminal
        subliminal.isLiked = subliminal.isLiked == 0 ? 1 : 0
        selectedSubliminalRelay.accept(subliminal)
        self.selectedSubliminal = subliminal
        self.store.appState.selectedSubliminal = subliminal
        Task {
            do {
                if selectedSubliminal.isLiked == 0 {
                    let _ = try await subliminalUseCase.addToFavorite(id: selectedSubliminal.subliminalID)
                    Logger.info("Successfully added to favorite", topic: .presentation)
                } else {
                    let _ = try await subliminalUseCase.deleteToFavorite(id: selectedSubliminal.subliminalID)
                    Logger.info("Successfully removed from favorite", topic: .presentation)
                }
            } catch {
                Logger.info("Failed to update favorite \(error)", topic: .presentation)
            }
        }
    }
    
    func updateRepat() {
        switch repeatStatus.value {
        case .repeatAll:
            repeatStatus.accept(.repeatCurrentlyPlaying)
        case .repeatCurrentlyPlaying:
            repeatStatus.accept(.repeatAll)
        }
    }
    
    func updateVolume(level: Float, trackID: String) {
        audioPlayerManager.updateVolume(level: level, trackID: trackID)
    }
    
    func clearAudioPlayers() {
        pauseAllAudio()
        playerStatusRelay.accept(.loading)
        timeRelay.accept("--/--")
        progressRelay.accept(0)
        playerDisposeBag = DisposeBag()
        audioPlayerManager.removePlayers()
    }
}

extension AudioPlayerViewModel {
    
    enum Repeat {
        case repeatCurrentlyPlaying
        case repeatAll
//        case noRepeat
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
        let subliminalQueue: () -> [Subliminal]
        let playlistQeueu: () -> [Subliminal]
        let addedQueue: () -> [Subliminal]
        
        static var standard: Dependencies {
            return .init(
                networkService: SharedDependencies.sharedDependencies.networkService,
                subliminalUseCase: SharedDependencies.sharedDependencies.useCases.subliminalUseCase,
                appState: SharedDependencies.sharedDependencies.store.appState,
                store: SharedDependencies.sharedDependencies.store,
                playerState: SharedDependencies.sharedDependencies.store.observable(of: \.playerState),
                isRepeatAll: SharedDependencies.sharedDependencies.store.observable(of: \.playerRepeatAll),
                subliminalQueue: { SharedDependencies.sharedDependencies.store.appState.subliminalQueue },
                playlistQeueu: { SharedDependencies.sharedDependencies.store.appState.playlistQueue },
                addedQueue: { SharedDependencies.sharedDependencies.store.appState.addedQueue }
            )
        }
    }
    
}
