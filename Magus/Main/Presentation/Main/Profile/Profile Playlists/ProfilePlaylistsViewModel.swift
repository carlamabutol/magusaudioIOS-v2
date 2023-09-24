//
//  ProfilePlaylistsViewModel.swift
//  Magus
//
//  Created by Jose Mari Pascual on 9/24/23.
//

import Foundation
import RxSwift
import RxRelay

class ProfilePlaylistsViewModel: ViewModel {
    
    static let SEARCH_DEBOUNCE_TIME: RxTimeInterval = .milliseconds(500)
    
    enum SearchSection {
        case subliminal
        case playlist
        
        var title: String {
            switch self {
            case .subliminal:
                return LocalizedStrings.SearchHeaderTitle.subliminal
            case .playlist:
                return LocalizedStrings.SearchHeaderTitle.playlist
            }
        }
    }
    
    let sections = BehaviorRelay<[SectionViewModel]>(value: [])
    let subliminalRelay = BehaviorRelay<[Subliminal]>(value: [])
    let playlistRelay = BehaviorRelay<[Playlist]>(value: [])
    private let searchRelay = BehaviorRelay<String>(value: "")
    private let playlistUseCase: PlaylistUseCase
    
    init(dependencies: ProfilePlaylistsViewModel.Dependencies = .standard) {
        playlistUseCase = dependencies.playlistUseCase
    }
    
    
}

extension ProfilePlaylistsViewModel {
    
    struct Dependencies {
        let store: Store
        let playlistUseCase: PlaylistUseCase
        
        static var standard: Dependencies {
            .init(
                store: SharedDependencies.sharedDependencies.store,
                playlistUseCase: SharedDependencies.sharedDependencies.useCases.playlistUseCase
            )
        }
    }
    
}
