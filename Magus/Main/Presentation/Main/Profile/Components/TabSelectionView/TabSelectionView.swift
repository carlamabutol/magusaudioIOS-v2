//
//  TabSelectionView.swift
//  Magus
//
//  Created by Jose Mari Pascual on 9/23/23.
//

import UIKit
import RxSwift

protocol TabSelectionDelegate: AnyObject {
    func selectedTabIndex(_ selectedIndex: Int)
}

class TabSelectionView: ReusableXibView {
    
    private var centerXLayoutConstraint: NSLayoutConstraint!
    
    private var tabButtons: [UIButton] = []
    private var selectedIndex = 0
    
    @IBOutlet var tabStackView: UIStackView!
    
    @IBOutlet var lineView: UIView!
    
    weak var delegate: TabSelectionDelegate?
    
    private var tabSelectedIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .TextColor.primaryBlue
        return view
    }()
    
    func configure(tabSelections: [TabSelectionModel]) {
        for tab in tabSelections {
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
        
        /// Needs to call `layoutIfNeeded` to update the subviews frames
        layoutIfNeeded()
        
        let x = lineView.frame.width / CGFloat(tabSelections.count)
        addSubview(tabSelectedIndicatorView)
        centerXLayoutConstraint = tabSelectedIndicatorView.centerXAnchor.constraint(equalTo: tabButtons[0].centerXAnchor)
        centerXLayoutConstraint.isActive = true
        tabSelectedIndicatorView.centerYAnchor.constraint(equalTo: lineView.centerYAnchor).isActive = true
        tabSelectedIndicatorView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        tabSelectedIndicatorView.widthAnchor.constraint(equalToConstant: x + 10).isActive = true
        tabSelectedIndicatorView.cornerRadius(with: 2.5)
    }
    
    
    func selectedIndex(_ index: Int) {
        delegate?.selectedTabIndex(index)
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
            self.layoutIfNeeded()
        }
//        pageViewController.setViewControllers([viewControllerAtIndex(selectedIndex)!], direction: .forward, animated: false, completion: nil)
        
    }
}

extension TabSelectionView {
    struct TabSelectionModel {
        let index: Int
        let title: String
    }
}
