//
//  MainTabBarViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/14/23.
//

import UIKit
import RxSwift
import Hero
import RxRelay

class MainTabBarViewController: UITabBarController {
    
    private let viewModel = MainTabViewModel()
    private let playerViewModel = AudioPlayerViewModel.shared
    private let disposeBag = DisposeBag()
    
    lazy var collapsedPlayerView: CollapsedPlayerView = {
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
        registerForKeyboardNotifications()
        hideKeyboardOnTap()
        setupCollapsedPlayerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collapsedPlayerView.isHidden = playerViewModel.selectedSubliminal == nil
    }
    
    var playerBottomConstraint: NSLayoutConstraint!
    var paddingBottom: CGFloat = 0
    
    fileprivate func setupCollapsedPlayerView() {
        let padding: CGFloat = 10
        let bottom = getSafeAreaLayoutGuide().1
        paddingBottom = bottom + tabBar.height + padding
        view.addSubview(collapsedPlayerView)
        playerBottomConstraint = collapsedPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -paddingBottom)
        NSLayoutConstraint.activate([
            playerBottomConstraint,
            collapsedPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            collapsedPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            collapsedPlayerView.heightAnchor.constraint(equalToConstant: 90)
        ])
        collapsedPlayerView.cornerRadius(with: 5)
        collapsedPlayerView.applyShadow(radius: 5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPlayer))
        collapsedPlayerView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showPlayer() {
        guard let selectedSubliminal = playerViewModel.selectedSubliminal else { return }
        goToPlayer(subliminal: selectedSubliminal)
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
        
        playerViewModel.progressObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] progress in
                self?.collapsedPlayerView.configureProgress(progress: progress)
            }.disposed(by: disposeBag)
        
        playerViewModel.timeRelay
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] time in
                self?.collapsedPlayerView.configureTime(time: time)
            }.disposed(by: disposeBag)
        
        playerViewModel.playerStateObservable
            .distinctUntilChanged()
            .subscribe { [weak self] status in
                self?.collapsedPlayerView.updatePlayerStatus(status: status)
            }
            .disposed(by: disposeBag)
        
        viewModel.selectedSubliminalObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] subliminal in
                self?.collapsedPlayerView.configure(subliminal: subliminal)
                self?.playerViewModel.createArrayAudioPlayer(with: subliminal)
            }
            .disposed(by: disposeBag)
        
        collapsedPlayerView.favoriteButton.rx.tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.playerViewModel.updateFavorite()
            }
            .disposed(by: disposeBag)
        
        
        collapsedPlayerView.playPauseButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.playerViewModel.playAudio()
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
            let homeVC = HomeViewController.instantiate(from: .home) as! HomeViewController
//            homeVC.tabViewModel = viewModel
            let navVC = UINavigationController(rootViewController: homeVC)
            navVC.navigationBar.isHidden = true
            viewController = navVC
        case .search:
            let searchVC = SearchViewController.instantiate(from: .search) as! SearchViewController
            searchVC.tabViewModel = viewModel
            let navVC = UINavigationController(rootViewController: searchVC)
            navVC.navigationBar.isHidden = true
            viewController = navVC
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
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowWrapper), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideWrapper), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShowWrapper(notification: NSNotification) {
        keyboardWillShow(notification: notification)
    }
    
    @objc private func keyboardWillHideWrapper(notification: NSNotification) {
        keyboardWillHide(notification: notification)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo: [AnyHashable: Any] = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as?
                NSValue,
              let firstResponder = view.firstResponder, // The text field
              let containerView = firstResponder.superview,
              let windowHeight = view.window?.height
                
        else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        let padding: CGFloat = 65
        let existingBottomInset = view.frame.height - (collapsedPlayerView.frame.origin.y +
                                                       collapsedPlayerView.frame.size.height)
        let containerViewYPositionInWindow =
        containerView.convert(firstResponder.frame.origin, to: nil).y
        let containerViewYPositionDifference = (containerViewYPositionInWindow +
                                               firstResponder.frame.size.height) - (windowHeight - keyboardHeight)
        UIView.animate(withDuration: 0.3) {
            self.playerBottomConstraint.constant = -(keyboardHeight + padding - existingBottomInset)
            
//            if containerViewYPositionDifference > 0 {
//                self.scrollView.contentOffset.y += containerViewYPositionDifference + padding
//            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let userinfo: [AnyHashable: Any] = notification.userInfo,
              let keyboardFrame = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        let padding: CGFloat = 65
        let existingBottomInset = view.frame.height - (collapsedPlayerView.frame.origin.y +  collapsedPlayerView.frame.size.height)
        
        UIView.animate(withDuration: 0.3) {
            self.playerBottomConstraint.constant = -self.paddingBottom
        }
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
        playerVC.audioPlayerViewModel = playerViewModel
        playerVC.audioPlayerViewModel.createArrayAudioPlayer(with: subliminal)
        playerVC.view.heroID = "sample"
        playerVC.isHeroEnabled = true
        playerVC.modalPresentationStyle = .currentContext
        playerVC.configure(subliminal: subliminal)
        navigationController?.present(playerVC, animated: true)
    }
    
}
