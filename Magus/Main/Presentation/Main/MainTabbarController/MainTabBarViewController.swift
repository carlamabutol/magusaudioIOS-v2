//
//  MainTabBarViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/14/23.
//

import UIKit
import RxSwift
import Hero

class MainTabBarViewController: UITabBarController {
    
    private let viewModel = MainTabViewModel()
    private let playerViewModel = AudioPlayerViewModel()
    private let disposeBag = DisposeBag()
    
    var collapsedPlayerView: CollapsedPlayerView = {
        let view = CollapsedPlayerView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHeroEnabled = true
        view.heroID = "sample"
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTabBar()
        setupBindings()
        hideKeyboardOnTap()
        setupCollapsedPlayerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collapsedPlayerView.isHidden = playerViewModel.selectedSubliminal == nil
    }
    
    fileprivate func setupCollapsedPlayerView() {
        let padding: CGFloat = 10
        let bottom = getSafeAreaLayoutGuide().1
        let paddingBottom = bottom + tabBar.height + padding
        view.addSubview(collapsedPlayerView)
        NSLayoutConstraint.activate([
            collapsedPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -paddingBottom),
            collapsedPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            collapsedPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            collapsedPlayerView.heightAnchor.constraint(equalToConstant: 90)
        ])
        collapsedPlayerView.cornerRadius(with: 5)
        collapsedPlayerView.applyShadow(radius: 5)
    }
    
    private func styleTabBar() {
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.Montserrat.bold3, .foregroundColor: UIColor.TabItemTitleColor.primaryColor], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.Montserrat.bold3, .foregroundColor: UIColor.clear], for: .normal)
        
    }
    
    private func setupBindings() {
        
        viewModel.tabItems
            .compactMap( { [weak self] in self?.createOrderedViewControllers(from: $0) } )
            .bind(to: rx.viewControllers)
            .disposed(by: disposeBag)
        
        viewModel.selectedTabIndexObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] item in
                self?.setSelectedIndex(item)
            }
            .disposed(by: disposeBag)
        
        viewModel.selectedSubliminalObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] sub in
                self?.goToPlayer(subliminal: sub)
            }
            .disposed(by: disposeBag)
    }
    
    func setSelectedIndex(_ tabItem: MainTabViewModel.TabItem) {
        selectedIndex = tabItem.orderIndex
    }
    
}

// MARK: - Tab Bar Configuration

extension MainTabBarViewController {
    
    private func createOrderedViewControllers(from tabItems: [MainTabViewModel.TabItem]) -> [UIViewController] {
        return tabItems
            .sorted(by: { $0.orderIndex < $1.orderIndex })
            .map({ createViewController(tabItem: $0) })
        
    }
    
    private func createViewController(tabItem: MainTabViewModel.TabItem) -> UIViewController {
        let viewController: UIViewController
        switch tabItem {
        case .home:
            viewController = HomeViewController.instantiate(from: .home)
        case .search:
            let searchVC = SearchViewController.instantiate(from: .search) as! SearchViewController
            searchVC.tabViewModel = viewModel
//            searchVC.tabNavigationDelegate = self
            viewController = searchVC
//        case .sound:
//            let playerVC = PlayerViewController.instantiate(from: .player) as! PlayerViewController
//            playerVC.tabViewModel = viewModel
//            viewController = playerVC
        case .premium:
            viewController = PremiumViewController.instantiate(from: .premium)
        case .user:
            let profileVC = ProfileViewController.instantiate(from: .profile) as! ProfileViewController
            profileVC.tabViewModel = viewModel
            let navVC = UINavigationController(rootViewController: profileVC)
            navVC.navigationBar.isHidden = true
            viewController = navVC
        }
        viewController.tabBarItem = Self.createTabItem(item: tabItem)
        return viewController
    }
    
    private static func createTabItem(item: MainTabViewModel.TabItem) -> UITabBarItem {
        let tabItem = UITabBarItem(title: nil, image: UIImage(named: item.imageNameUnSelected)?.withRenderingMode(.alwaysOriginal), tag: item.orderIndex)
        tabItem.selectedImage = UIImage(named: item.imageNameSelected)?.withRenderingMode(.alwaysOriginal)
        tabItem.isAccessibilityElement = true
        tabItem.tag = item.orderIndex
        tabItem.accessibilityIdentifier = item.title
        tabItem.accessibilityHint = item.title
        tabItem.title = item.title
        return tabItem
    }
    
}

extension MainTabBarViewController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        item.title = item.accessibilityIdentifier
    }
}

extension MainTabBarViewController {
    
    func goToPlayer(subliminal: Subliminal) {
        let playerVC = PlayerViewController.instantiate(from: .player) as! PlayerViewController
        playerVC.tabViewModel = viewModel
        playerVC.playerViewModel = playerViewModel
        playerVC.playerViewModel.createArrayAudioPlayer(with: subliminal)
        playerVC.view.heroID = "sample"
        playerVC.isHeroEnabled = true
        playerVC.modalPresentationStyle = .currentContext
        collapsedPlayerView.configure(title: subliminal.title, image: subliminal.cover)
        navigationController?.present(playerVC, animated: true)
        playerVC.configure(subliminal: subliminal)
//        present(playerVC, animated: true)
    }
    
}
//protocol TabNavigationDelegate: AnyObject {
//    func goToPlayer(subliminal: Subliminal)
//}
