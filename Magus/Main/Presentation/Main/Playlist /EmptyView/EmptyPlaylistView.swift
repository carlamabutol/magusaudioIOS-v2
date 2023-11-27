//
//  EmptyPlaylistView.swift
//  Magus
//
//  Created by Jomz on 11/25/23.
//

import UIKit
import RxSwift

class EmptyPlaylistView: ReusableXibView {
    
    @IBOutlet var textLabel: UILabel! {
        didSet {
            textLabel.text = "Let’s start building your playlist"
            textLabel.font = .Montserrat.bold1
            textLabel.textAlignment = .center
        }
    }
    
    @IBOutlet var addButton: FormButton! {
        didSet {
            let titleAttributed = NSAttributedString(string: "Add Subliminal", attributes: [.font: UIFont.Montserrat.bold15, .foregroundColor: UIColor.TextColor.primaryBlue])
            addButton.setAttributedTitle(titleAttributed, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAnimation() {
        addButton.animateWhenPressed(disposeBag: disposeBag)
    }
}
