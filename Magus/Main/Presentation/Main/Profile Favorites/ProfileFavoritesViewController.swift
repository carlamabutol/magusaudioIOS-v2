//
//  ProfileFavoritesViewController.swift
//  Magus
//
//  Created by Jomz on 9/20/23.
//

import UIKit
import RxSwift
import RxRelay

class ProfileFavoritesViewController: BlurCommonViewController {
    
    private let viewModel = ProfileFavoritesViewModel()
    @IBOutlet var backButton: UIButton!
    @IBOutlet var gradientView: UIView!
    
    @IBOutlet var coverImageView: UIImageView! {
        didSet {
            coverImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.title3
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet var repeatButton: UIButton! {
        didSet {
            repeatButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var playButton: UIButton! {
        didSet {
            playButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet var tabSelectionView: TabSelectionView!
    
    @IBOutlet var pageView: UIView!
    var viewControllers: [UIViewController]!
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.setTextWithShadow(text: LocalisedStrings.Player.favorites)
        tabSelectionView.delegate = self
        tabSelectionView.configure(tabSelections: viewModel.tabSelectionModel)
        viewModel.getAllPlaylistFavorites()
        viewModel.getAllSubliminalFavorites()
        setupGradientView(view: gradientView)
        setupPageController()
        removeSwipeGesture()
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        backButton.rx.tap
            .subscribe { [weak self] _ in self?.popViewController() }
            .disposed(by: disposeBag)
        
        /*viewModel.firstSubliminalObservable
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe (onNext: { [weak self] subliminal in
                self?.configure(subliminal: subliminal)
            })
            .disposed(by: disposeBag)*/
        
        viewModel.selectedPlaylistObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe (onNext: { [weak self] playlist in
                self?.goToPlaylist(playlist: playlist)
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedOptionObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe (onNext: { [weak self] subliminal in
                self?.goToOptions(subliminal: subliminal)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func configure(subliminal: Subliminal) {
        coverImageView.sd_setImage(with: .init(string: subliminal.cover))
    }
    
    private func removeSwipeGesture(){
        for view in self.pageViewController!.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    private func setupPageController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        
        viewControllers = createOrderedViewControllers(from: viewModel.tabSelectionModel)
        
        pageViewController.setViewControllers([viewControllerAtIndex(0)!], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        pageView.addSubview(pageViewController.view)
        pageViewController!.view.frame = pageView.bounds
        pageViewController.didMove(toParent: self)
        // Add the page view controller's gesture recognizers to the view controller's view so that the gestures are started more easily.
        pageView.gestureRecognizers = pageViewController.gestureRecognizers
    }
    
    private func goToPlaylist(playlist: Playlist) {
        let playlistVC = PlaylistViewController.instantiate(from: .playlist) as! PlaylistViewController
        navigationController?.pushViewController(playlistVC, animated: true)
        playlistVC.setPlaylist(playlist: playlist)
    }
    
    private func goToOptions(subliminal: Subliminal) {
        let viewController = PlayerOptionViewController.instantiate(from: .playerOption) as! PlayerOptionViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.isHidden = true
        viewController.loadViewIfNeeded()
        viewController.configure(subliminal: subliminal, playlistId: subliminal.playlistId) {
            self.toggleBlurEffect(isHidden: true)
        }
        toggleBlurEffect(isHidden: false)
        tabBarController?.presentModally(navController, animated: true)
    }
}

extension ProfileFavoritesViewController {
    
    private func createOrderedViewControllers(from tabItems: [TabSelectionView.TabSelectionModel]) -> [UIViewController] {
        return tabItems
            .sorted(by: { $0.index < $1.index })
            .map({ createPageViewController(tabItem: $0) })
        
    }
    
    private func createPageViewController(tabItem: TabSelectionView.TabSelectionModel) -> UIViewController {
        let viewController: UIViewController
        switch tabItem.index {
        case 0:
            let vc = SubliminalCollectionViewController()
            vc.favoritesViewModel = viewModel
            viewController = vc
        case 1:
            let vc = PlaylistCollectionViewController()
            vc.favoritesViewModel = viewModel
            viewController = vc
        default:
            viewController = UIViewController()
        }
        
        return viewController
    }
}

// MARK: - ProfileFavoritesViewController DataSource and Delegate
extension ProfileFavoritesViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController)
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController)
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == viewControllers.count {
            return nil
        }
        return viewControllerAtIndex(index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

// MARK: - Helpers
extension ProfileFavoritesViewController {
    
    fileprivate func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        if viewControllers.count == 0 || index >= viewControllers.count {
            return nil
        }
        return viewControllers[index]
    }
    
    fileprivate func indexOfViewController(_ viewController: UIViewController) -> Int {
        return viewControllers.firstIndex(of: viewController) ?? NSNotFound
    }
    
}


extension ProfileFavoritesViewController: TabSelectionDelegate {
    
    func selectedTabIndex(_ selectedIndex: Int) {
        pageViewController.setViewControllers([viewControllerAtIndex(selectedIndex)!], direction: selectedIndex == 0 ? .reverse : .forward, animated: true, completion: nil)
        playButton.layer.opacity = selectedIndex == 1 ? 0 : 1
        repeatButton.layer.opacity = selectedIndex == 1 ? 0 : 1
    }
    
}
