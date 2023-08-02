//
//  ProfileMoodViewController.swift
//  Magus
//
//  Created by Jomz on 7/30/23.
//

import UIKit
import RxSwift

class ProfileMoodViewController: CommonViewController {
    
    var profileViewModel: ProfileViewModel!
    
    @IBOutlet var dateTypeSelectionView: DateTypeSelectionView! {
        didSet {
            let tapWeekly = UITapGestureRecognizer(target: self, action: #selector(self.tapWeekly))
            let tapMonthly = UITapGestureRecognizer(target: self, action: #selector(self.tapMonthly))
            dateTypeSelectionView.weeklyContainerView.isUserInteractionEnabled = true
            dateTypeSelectionView.monthlyContainerView.isUserInteractionEnabled = true
            dateTypeSelectionView.weeklyContainerView.addGestureRecognizer(tapWeekly)
            dateTypeSelectionView.monthlyContainerView.addGestureRecognizer(tapMonthly)
        }
    }
    
    @IBOutlet var weeklyView: WeeklyView!
    
    @IBOutlet var monthlyView: WeeklyView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weeklyView.configure(profileViewModel.weeklyData)
    }
    
    override func setupBinding() {
        profileViewModel.moodViewTypeObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] viewType in
                UIView.animate(withDuration: 0.2) {
                    switch viewType {
                    case .weekly:
                        self?.dateTypeSelectionView.weeklyContainerView.backgroundColor = .Background.buttonGray
                        self?.dateTypeSelectionView.monthlyContainerView.backgroundColor = .white
                        self?.weeklyView.isHidden = false
                        self?.monthlyView.isHidden = true
                    case .monthly:
                        self?.dateTypeSelectionView.monthlyContainerView.backgroundColor = .Background.buttonGray
                        self?.dateTypeSelectionView.weeklyContainerView.backgroundColor = .white
                        self?.weeklyView.isHidden = true
                        self?.monthlyView.isHidden = false
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func tapWeekly() {
        profileViewModel.selectMood(.weekly)
    }
    
    @objc private func tapMonthly() {
        profileViewModel.selectMood(.monthly)
    }
}
