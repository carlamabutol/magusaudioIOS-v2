//
//  MoodViewController.swift
//  Magus
//
//  Created by Jomz on 6/7/23.
//

import UIKit
import RxCocoa
import RxSwift

class MoodViewController: CommonViewController {
    
    private let viewModel = MoodViewModel()
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
            titleLabel.font = UIFont.Montserrat.title2
            titleLabel.text = LocalizedStrings.MoodSelection.title
        }
    }
    
    @IBOutlet var continueButton: UIButton! {
        didSet {
            continueButton.setTitle(LocalizedStrings.MoodSelection.continueButtonTitle, for: .normal)
            continueButton.setTitleColor(.ButtonColor.primaryBlue, for: .normal)
            continueButton.titleLabel?.font = .Montserrat.bold1
        }
    }
    
    @IBOutlet var moodCollectionView: UICollectionView! {
        didSet {
            moodCollectionView.backgroundColor = .clear
            setUpCollectionView()
        }
    }
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getMoodList()
        setupCollectionDataSource()
    }
    
    override func setupBinding() {
        viewModel.moodCollectionHiddenObservable
            .bind(to: moodCollectionView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.loadingSpinnerObservable
            .bind(to: loadingIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.moodSelectedObservable
            .bind(to: continueButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        continueButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.updateSelectedMood()
            })
            .disposed(by: disposeBag)
    }
    
    private func setUpCollectionView() {
        moodCollectionView.register(UINib(nibName: "MoodCell", bundle: nil), forCellWithReuseIdentifier: MoodCell.identifier)
//        moodCollectionView.register(MoodCell.self, forCellWithReuseIdentifier: MoodCell.identifier)
        moodCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 24
        
        moodCollectionView
            .setCollectionViewLayout(layout, animated: true)
        
    }
    
    private func setupCollectionDataSource() {
        viewModel.moodListObservable
            .bind(to: moodCollectionView.rx.items(cellIdentifier: MoodCell.identifier, cellType: MoodCell.self)) { (row, element, cell) in
                cell.configure(model: element)
            }
            .disposed(by: self.disposeBag)
    }
    
}

extension MoodViewController: UICollectionViewDelegateFlowLayout {
    /// 1
    func collectionView(_ collectionView: UICollectionView,
                  layout collectionViewLayout: UICollectionViewLayout,
                  insetForSectionAt section: Int) -> UIEdgeInsets {
        /// 2
        return .zero
    }

    /// 3
    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        /// 4
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        /// 5
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        /// 6
        return CGSize(width: widthPerItem, height: 45)
    }
}

/// Extension for random value get.
extension CGFloat {
    static func randomValue() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
/// Extension for random color using random value.
extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(
           red:   .randomValue(),
           green: .randomValue(),
           blue:  .randomValue(),
           alpha: 1.0
        )
    }
}
