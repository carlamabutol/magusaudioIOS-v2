//
//  RootViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/6/23.
//

import UIKit
import RxSwift

class RootViewController: CommonViewController {
    
    private let viewModel = RootViewModel(dependencies: SharedDependencies.sharedDependencies)
    
    var rootViewController: UIViewController? {
        didSet {
            removeRootViewController(oldValue)
            addRootViewController(rootViewController)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Background.primary
        // Do any additional setup after loading the view.
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
        }
    }
    
    override func setupView() {
    }
    
    override func setupBinding() {
        super.setupBinding()
        viewModel.selectedRoute
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] route in
                self?.navigate(to: route)
            }
            .disposed(by: disposeBag)
    }
    
    private func navigate(to route: Route) {
        switch route {
        case .splashscreen:
            rootViewController?.dismiss(animated: false)
            rootViewController = SplashScreenViewController.instantiate(from: .splashscreen)
        case .welcomeOnBoard:
            rootViewController?.dismiss(animated: false)
            rootViewController = UINavigationController(rootViewController: WelcomeViewController.instantiate(from: .welcome))
        case .mood:
            rootViewController?.dismiss(animated: false)
            rootViewController = MoodViewController.instantiate(from: .mood)
        case .home:
            rootViewController?.dismiss(animated: false)
            let navigationController = UINavigationController(rootViewController: UIViewController.instantiate(from: .mainTabBar))
            navigationController.navigationBar.isHidden = true
            rootViewController = navigationController
        }
    }
    
    private func removeRootViewController(_ childViewController: UIViewController?) {
        guard let childViewController = childViewController else { return }
        if let presentedViewController = childViewController.presentedViewController {
            presentedViewController.dismiss(animated: false)
        }
        // Remove the current Root View Controller
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
    
    private func addRootViewController(_ childViewController: UIViewController?) {
        guard let childViewController = childViewController else { return }
        addChild(childViewController)
        view.addSubview(childViewController.view)
        NSLayoutConstraint.activate([
            childViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        childViewController.didMove(toParent: self)
    }

}
