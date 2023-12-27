//
//  SubliminalGuideViewController.swift
//  Magus
//
//  Created by Jomz on 10/12/23.
//

import UIKit
import RxSwift

class SubliminalGuideViewController: CommonViewController {
    
    private let viewModel = SettingsViewModel()
    
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
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.register(SubliminalGuideCell.self, forCellWithReuseIdentifier: SubliminalGuideCell.identifier)
            collectionView.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
            collectionView.backgroundColor = .clear
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        viewModel.guideObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.collectionView.reloadData()
            }.disposed(by: disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getGuide()
    }
    
}

extension SubliminalGuideViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.guideRelay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubliminalGuideCell.identifier, for: indexPath) as? SubliminalGuideCell else { fatalError() }
        let model = viewModel.guideRelay.value[indexPath.row]
        cell.configure(index: indexPath.row, guide: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = viewModel.guideRelay.value[indexPath.row]
        return .init(width: collectionView.frame.width - 40, height: model.potentialHeight == 0 ? 152 : model.potentialHeight)
    }
}
