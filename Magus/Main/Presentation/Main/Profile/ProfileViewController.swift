//
//  ProfileViewController.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import UIKit
import SDWebImage
import RxSwift

class ProfileViewController: CommonViewController {
    
    private let viewModel = ProfileViewModel()
    
    var tabViewModel: MainTabViewModel!
    
    @IBOutlet var welcomeBackLbl: UILabel! {
        didSet {
            welcomeBackLbl.font = .Montserrat.bold15
        }
    }
    
    @IBOutlet var nameLbl: UILabel! {
        didSet {
            nameLbl.numberOfLines = 2
            nameLbl.font = .Montserrat.title
        }
    }
    
    @IBOutlet var emailLbl: UILabel! {
        didSet {
            emailLbl.font = .Montserrat.body2
        }
    }
    
    @IBOutlet var scrollViewContentView: UIView!
    @IBOutlet var tabStackView: UIStackView!
    
    @IBOutlet var tabSelectedIndicator: UIView!
    private var tabSelectedIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .TextColor.primaryBlue
        return view
    }()
    
    @IBOutlet var subscriptionContainerView: UIView! {
        didSet {
            subscriptionContainerView.isHidden = viewModel.user()?.info.subscriptionID != 2
            subscriptionContainerView.backgroundColor = .Background.subscriptionBG
            subscriptionContainerView.cornerBorderRadius(cornerRadius: 5, borderColor: UIColor.black.withAlphaComponent(0.10), borderWidth: 0.5)
            subscriptionContainerView.applyShadow(radius: 5, offset: .init(width: 0, height: 2))
        }
    }
    
    @IBOutlet var subscriptionTypeLbl: UILabel! {
        didSet {
            subscriptionTypeLbl.font = .Montserrat.bold3
            subscriptionTypeLbl.textColor = .white
            subscriptionTypeLbl.text = viewModel.user()?.isPremium == true ? "PREMIUM" : "FREE"
        }
    }
    
    @IBOutlet var containerProfileImageView: UIView! {
        didSet {
            containerProfileImageView.circle()
            containerProfileImageView.applyShadow(radius: 5, shadowOpacity: 0.2, offset: .init(width: 0, height: 5))
        }
    }
    
    @IBOutlet var profileImageView: UIImageView! {
        didSet {
            profileImageView.circle()
            profileImageView.clipsToBounds = true
        }
    }
    @IBOutlet var editProfileButton: UIButton!
    
    private var centerXLayoutConstraint: NSLayoutConstraint!
    
    private var tabButtons: [UIButton] = []
    private var selectedIndex = 0
    
    @IBOutlet var pageView: UIView! {
        didSet {
            pageView.backgroundColor = .gray
        }
    }
    var viewControllers: [UIViewController]!
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabSelection()
        setupPageController()
        updateUserDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileImageView.sd_setImage(with: tabViewModel.profileImage(), placeholderImage: .init(named: .coverImage))
        updateUserDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.circle()
    }
    
    private func updateUserDetails() {
        emailLbl.text = tabViewModel.userEmail()
        nameLbl.text = tabViewModel.userFullname()
    }
    
    func selectedIndex(_ index: Int) {
        selectedIndex = index
        let button = tabButtons[index]
        tabButtons.map {
            $0.titleLabel?.font = .Montserrat.body3
        }
        button.titleLabel?.font = .Montserrat.bold15
        self.centerXLayoutConstraint.isActive = false
        self.centerXLayoutConstraint = self.tabSelectedIndicatorView.centerXAnchor.constraint(equalTo: self.tabButtons[index].centerXAnchor)
        self.centerXLayoutConstraint.isActive = true
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        pageViewController.setViewControllers([viewControllerAtIndex(selectedIndex)!], direction: .forward, animated: false, completion: nil)
        
    }
    
    fileprivate func setupTabSelection() {
        for tab in viewModel.tabSelections {
            let button = UIButton()
            button.setTitle(tab.title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .Montserrat.body3
            if selectedIndex == tab.index {
                button.titleLabel?.font = .Montserrat.bold15
            }
            button.rx.tap
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: { [weak self] _ in
                    self?.selectedIndex(tab.index)
                })
                .disposed(by: disposeBag)
            tabButtons.append(button)
            tabStackView.addArrangedSubview(button)
        }
        let x = tabStackView.frame.width / CGFloat(viewModel.tabSelections.count)
        scrollViewContentView.addSubview(tabSelectedIndicatorView)
        centerXLayoutConstraint = tabSelectedIndicatorView.centerXAnchor.constraint(equalTo: tabButtons[0].centerXAnchor)
        centerXLayoutConstraint.isActive = true
        tabSelectedIndicatorView.centerYAnchor.constraint(equalTo: tabSelectedIndicator.centerYAnchor).isActive = true
        tabSelectedIndicatorView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        tabSelectedIndicatorView.widthAnchor.constraint(equalToConstant: x + 10).isActive = true
        tabSelectedIndicatorView.cornerRadius(with: 2.5)
    }
    
    override func setupBinding() {
        editProfileButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.presentEditProfile()
            }
            .disposed(by: disposeBag)
    }
    
    private func presentEditProfile() {
        let editProfileVC = EditProfileViewController.instantiate(from: .editProfile)
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    private func setupPageController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        
        viewControllers = createOrderedViewControllers(from: viewModel.tabSelections)
        
//        viewControllers.forEach { viewController in
//            viewController.view.backgroundColor = .randomColor()
//        }
        
        pageViewController.setViewControllers([viewControllerAtIndex(0)!], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        pageView.addSubview(pageViewController.view)
        pageViewController!.view.frame = pageView.bounds
        pageViewController.didMove(toParent: self)
        // Add the page view controller's gesture recognizers to the view controller's view so that the gestures are started more easily.
        pageView.gestureRecognizers = pageViewController.gestureRecognizers
    }
}

extension ProfileViewController {
    
    private func createOrderedViewControllers(from tabItems: [ProfileViewModel.TabSelection]) -> [UIViewController] {
        return tabItems
            .sorted(by: { $0.index < $1.index })
            .map({ createPageViewController(tabItem: $0) })
        
    }
    
    private func createPageViewController(tabItem: ProfileViewModel.TabSelection) -> UIViewController {
        let viewController: UIViewController
        switch tabItem {
        case .mood:
            let profileVC = ProfileMoodViewController.instantiate(from: .profileMood) as! ProfileMoodViewController
            profileVC.profileViewModel = viewModel
            viewController = profileVC
        case .sub:
            let viewC = MySubsViewController.instantiate(from: .mySubs) as! MySubsViewController
            viewC.profileViewModel = viewModel
            viewController = viewC
        case .settings:
            let viewC = SettingsViewController.instantiate(from: .settings) as! SettingsViewController
            viewC.profileViewModel = viewModel
            viewController = viewC
            return viewController
        }
        return viewController
    }
}

// MARK: - UIPageViewController DataSource and Delegate
extension ProfileViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
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
extension ProfileViewController {
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
