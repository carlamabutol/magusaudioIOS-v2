//
//  HowMagusWorksViewController.swift
//  Magus
//
//  Created by Jomz on 9/4/23.
//

import UIKit

class HowMagusWorksViewController: CommonViewController {
    
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
    
    private func setupPageController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        
        createViewControllers()
        
        pageViewController.setViewControllers([viewControllerAtIndex(0)!], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        pageView.addSubview(pageViewController.view)
        pageViewController!.view.frame = pageView.bounds
        pageViewController.didMove(toParent: self)
        // Add the page view controller's gesture recognizers to the view controller's view so that the gestures are started more easily.
        pageView.gestureRecognizers = pageViewController.gestureRecognizers
    }
    
    private func createViewControllers() {
        viewControllers.append(createViewController(with: HowMagusWorksViewModel.first))
        viewControllers.append(createViewController(with: HowMagusWorksViewModel.second))
    }
    
    func createViewController(with model: HowMagusWorksViewModel.Model) -> HowMagusWorkInfoViewController {
        let viewController = HowMagusWorkInfoViewController.instantiate(from: .howMagusWorksInfo) as! HowMagusWorkInfoViewController
        viewController.loadViewIfNeeded()
        viewController.configure(with: model)
        return viewController
    }
    
}

// MARK: - Helpers
extension HowMagusWorksViewController {
    
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
