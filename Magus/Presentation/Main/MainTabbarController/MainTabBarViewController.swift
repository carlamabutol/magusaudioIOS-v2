//
//  MainTabBarViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/14/23.
//

import UIKit
import RxSwift

class MainTabBarViewController: UITabBarController {
    
    private let viewModel = MainTabViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTabBar()
        setupBindings()
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
            viewController.view.backgroundColor = .orange
        case .search:
            viewController = SearchViewController.instantiate(from: .search)
            viewController.view.backgroundColor = .yellow
        case .sound:
            viewController = SubsViewController.instantiate(from: .subs)
            viewController.view.backgroundColor = .green
        case .premium:
            viewController = PremiumViewController.instantiate(from: .premium)
            viewController.view.backgroundColor = .brown
        case .user:
            viewController = ProfileViewController.instantiate(from: .profile)
            viewController.view.backgroundColor = .cyan
        }
        viewController.tabBarItem = Self.createTabItem(item: tabItem)
        return viewController
    }
    
    private static func createTabItem(item: MainTabViewModel.TabItem) -> UITabBarItem {
        let tabItem = UITabBarItem(title: nil, image: UIImage(named: item.imageNameUnSelected)?.withRenderingMode(.alwaysOriginal), tag: item.orderIndex)
        tabItem.selectedImage = UIImage(named: item.imageNameSelected)?.withRenderingMode(.alwaysOriginal)
        tabItem.isAccessibilityElement = true
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
