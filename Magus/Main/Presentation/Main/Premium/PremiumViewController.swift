//
//  PremiumViewController.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import UIKit
import RxSwift

class PremiumViewController: CommonViewController {
    
    let viewModel = PremiumViewModel()
    
    @IBOutlet var scrollView: UIScrollView! {
        didSet {
            scrollView.backgroundColor = .clear
        }
    }
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.text = LocalizedStrings.Premium.title
            titleLabel.font = .Montserrat.title3
        }
    }
    
    @IBOutlet var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = LocalizedStrings.Premium.subTitle
            subTitleLabel.font = .Montserrat.body3
        }
    }
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 20
            layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
            collectionView
                .setCollectionViewLayout(layout, animated: true)
            collectionView.delegate = self
        }
    }
    
    @IBOutlet var chooseYourPlanLabel: UILabel! {
        didSet {
            chooseYourPlanLabel.text = LocalizedStrings.Premium.chooseYourPlan
            chooseYourPlanLabel.font = .Montserrat.body3
        }
    }
    
    @IBOutlet var planStackView: UIStackView!
    
    @IBOutlet var continueButton: UIButton! {
        didSet {
            continueButton.setTitle(LocalizedStrings.Premium.continueBtn, for: .normal)
            continueButton.setTitleColor(.ButtonColor.primaryBlue, for: .normal)
            continueButton.titleLabel?.font = .Montserrat.bold1
        }
    }
    
    @IBOutlet var planStackHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupBinding() {
        
        viewModel.premiumFeatures.bind(to: collectionView.rx.items(cellIdentifier: PremiumFeatureCell.reuseId, cellType: PremiumFeatureCell.self)) { (row,item,cell) in
            cell.configure(item: item)
        }.disposed(by: disposeBag)
        
        viewModel.planRelay.asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] plans in
                self?.setupPlanStackView(plans: plans)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupPlanStackView(plans: [PremiumViewModel.PremiumPlan]) {
        planStackView.arrangedSubviews.forEach {
            planStackView.removeArrangedSubview($0)
        }
        for plan in plans {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            view.heightAnchor.constraint(equalToConstant: 80).isActive = true
            let planView = PlanView()
            planView.translatesAutoresizingMaskIntoConstraints = false
            planView.configure(model: plan)
            view.addSubview(planView)
            NSLayoutConstraint.activate([
                planView.topAnchor.constraint(equalTo: view.topAnchor),
                planView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                planView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                planView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
            planStackView.addArrangedSubview(view)
        }
        view.layoutIfNeeded()
    }
}

extension PremiumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 130, height: collectionView.frame.height)
    }
}
