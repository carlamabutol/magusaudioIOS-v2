//
//  PremiumViewController.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import UIKit

class PremiumViewController: CommonViewController {
    
    let viewModel = PremiumViewModel()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupBinding() {
        
        viewModel.premiumFeatures.bind(to: collectionView.rx.items(cellIdentifier: PremiumFeatureCell.reuseId, cellType: PremiumFeatureCell.self)) { (row,item,cell) in
            cell.configure(item: item)
        }.disposed(by: disposeBag)
    }
    
}

extension PremiumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 130, height: collectionView.frame.height)
    }
}
