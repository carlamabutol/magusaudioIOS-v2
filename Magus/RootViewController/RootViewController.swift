//
//  RootViewController.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/6/23.
//

import UIKit

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
            print("Family: \(family) Font names: \(names)")
        }
    }
    
    override func setupView() {
    }
    
    override func setupBinding() {
        super.setupBinding()
        viewModel.selectedRoute.subscribe { [weak self] route in
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
        case .home:
            rootViewController?.dismiss(animated: false)
            rootViewController = UIViewController.instantiate(from: .mainTabBar)
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
