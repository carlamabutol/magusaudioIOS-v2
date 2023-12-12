//
//  FAQsViewController.swift
//  Magus
//
//  Created by Jomz on 10/12/23.
//

import UIKit
import RxSwift
import RxDataSources

class FAQsViewController: CommonViewController {
    
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
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.title1
            titleLabel.text = LocalisedStrings.FAQs.title
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet var searchView: SearchView! {
        didSet {
            searchView.backgroundColor = .white
            searchView.textField.attributedPlaceholder = NSAttributedString(string: "Need help with anything?", attributes: [.font: UIFont.Montserrat.body3])
            searchView.cornerRadius(with: 10)
            searchView.applyShadow(radius: 5)
        }
    }
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.register(HeaderTitleRightButtonView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTitleRightButtonView.identifier)
            collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
            collectionView.alwaysBounceVertical = true
            collectionView.backgroundColor = .clear
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupDataSource()
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        viewModel.faqsObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.collectionView.reloadData()
                self?.collectionView.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
    
        searchView.textField.rx.text
            .orEmpty
            .subscribe { [weak self] text in
                guard let self = self else { return }
                self.viewModel.setSearchFilter(text)
            }
            .disposed(by: disposeBag)
        
        searchView.configure { [weak self] in
            guard let self = self else { return }
            self.viewModel.setSearchFilter("")
        }
    }
    
    private func setupDataSource() {
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SettingsViewModel.FAQsSection>(configureCell: { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FAQsCell.identifier, for: indexPath) as! FAQsCell
            cell.configure(description: item.description)
            return cell
        }, configureSupplementaryView: { dataSource, collectionView, title, indexPath in
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: title, withReuseIdentifier: HeaderTitleRightButtonView.identifier, for: indexPath) as! HeaderTitleRightButtonView
            let model = dataSource.sectionModels[indexPath.section]
            view.configure(text: model.title ?? "", tapAction: model.tapHandler)
            return view
        })

        viewModel.faqsObservable
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}

extension FAQsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.faqsRelay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model = viewModel.faqsRelay.value[section]
        return model.isCollapsed ? model.items.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.faqsRelay.value[indexPath.section]
        let item = model.items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FAQsCell.identifier, for: indexPath) as! FAQsCell
        cell.configure(description: item.description)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderTitleRightButtonView.identifier, for: indexPath) as! HeaderTitleRightButtonView
            let model = viewModel.faqsRelay.value[indexPath.section]
            view.configure(text: model.title ?? "", isCollapsed: model.isCollapsed, tapAction: model.tapHandler)
            return view
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let model = viewModel.faqsRelay.value[section]
        let imageWidth: CGFloat = 20
        let width = collectionView.frame.width - 40 - imageWidth
        let height = model.title?.heigh1t(withConstrainedWidth: width - 20, font: .Montserrat.bold17) ?? 0
        let finalHeight = height > 50 ? height + 20 : 50
        print("HEADER HEIGHT \(model.title) - \(height) - \(finalHeight)")
        return .init(width: width, height: height + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 40
        return .init(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = collectionView.frame.width - 40
        return .init(width: width, height: 10)
    }
    
}

extension String {
    
    func heigh1t(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)

            return ceil(boundingBox.height)
        }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
            
            var wordBoxes = [CGSize]()
            var calculatedHeight = CGFloat.zero
            var currentLine = 0
            
            for word in self.wordsWithWordSeparators() {
                
                let box = word.boundingRect(with: CGSize.zero, attributes: [.font: font], context: nil)
                let boxSize = CGSize(width: box.width, height: box.height)
                
                if wordBoxes.isEmpty == true {
                    wordBoxes.append(boxSize)
                }
                else if wordBoxes[currentLine].width + boxSize.width > width {
                    wordBoxes.append(boxSize)
                    currentLine += 1
                }
                else {
                    wordBoxes[currentLine].width += boxSize.width
                    wordBoxes[currentLine].height = max(wordBoxes[currentLine].height, boxSize.height)
                }
            }
            
            for wordBox in wordBoxes {
                calculatedHeight += wordBox.height
            }
            
            return calculatedHeight
        }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }// Should work with any language supported by Apple
    func wordsWithWordSeparators () -> [String] {
        
        let range = self.startIndex..<self.endIndex
        var words = [String]()
        
        self.enumerateSubstrings(in: range, options: .byWords) { (substr, substrRange, enclosingRange, stop) in
            let wordWithWordSeparators = String(self[enclosingRange])
            words.append(wordWithWordSeparators)
        }
        
        return words
    }
}
