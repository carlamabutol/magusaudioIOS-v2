//
//  HowMagusWorksViewController.swift
//  Magus
//
//  Created by Jomz on 9/4/23.
//

import UIKit
import RxSwift

class HowMagusWorksViewController: CommonViewController {
    
    let viewModel: SettingsViewModel = SettingsViewModel()
    
    @IBOutlet var navigationBar: ProfileNavigationBar! {
        didSet {
            navigationBar.backgroundColor = .clear
            navigationBar.configure(
                model: .init(leftButtonHandler: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }, rightButtonModel: nil, rightButtonHandler: nil)
            )
        }
    }
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.title1
            titleLabel.text = LocalisedStrings.HowMagusWorks.title
        }
    }
    
    @IBOutlet var pageView: UIView! {
        didSet {
            pageView.backgroundColor = .clear
        }
    }
    
    var viewControllers: [UIViewController] = []
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        viewModel.ipoObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] ipos in
                self?.createViewControllers(ipos: ipos)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setupPageController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        pageView.addSubview(pageViewController.view)
        pageViewController!.view.frame = pageView.bounds
        pageViewController.didMove(toParent: self)
        // Add the page view controller's gesture recognizers to the view controller's view so that the gestures are started more easily.
        pageView.gestureRecognizers = pageViewController.gestureRecognizers
    }
    
    private func createViewControllers(ipos: [IPO]) {
        for ipo in ipos {
            viewControllers.append(createViewController(with: ipo))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.setViewControllers()
        }
    }
    
    private func setViewControllers() {
        guard let viewController = viewControllerAtIndex(0) else { return }
        pageViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    func createViewController(with model: IPO) -> HowMagusWorkInfoViewController {
        let viewController = HowMagusWorkInfoViewController.instantiate(from: .howMagusWorksInfo) as! HowMagusWorkInfoViewController
        viewController.loadViewIfNeeded()
        viewController.configure(with: model)
        return viewController
    }
    
}

// MARK: - Helpers
extension HowMagusWorksViewController {
    
    private func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        if viewControllers.count == 0 || index >= viewControllers.count {
            return nil
        }
        return viewControllers[index]
    }
    
    private func indexOfViewController(_ viewController: UIViewController) -> Int {
        return viewControllers.firstIndex(of: viewController) ?? NSNotFound
    }
    
}

// MARK: - HowMagusWorksViewController DataSource and Delegate
extension HowMagusWorksViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
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
