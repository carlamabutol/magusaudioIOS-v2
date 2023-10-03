//
//  ProfileNavigationBar.swift
//  Magus
//
//  Created by Jomz on 7/27/23.
//

import UIKit

class ProfileNavigationBar: ReusableXibView {
    
    @IBOutlet private var backButton: UIButton!
    
    @IBOutlet private var saveButton: UIButton!
    
    private var goBackHandler: CompletionHandler?
    private var saveHandler: CompletionHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTapActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTapActions()
    }
    
    private func setupTapActions() {
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
    }
    
    func hideShowButton(isHidden: Bool) {
        saveButton.isHidden = isHidden
    }
    
    func configure(model: Model) {
        self.goBackHandler = model.leftButtonHandler
        self.saveHandler = model.rightButtonHandler
        self.hideShowButton(isHidden: saveHandler == nil)
        saveButton.setTitle(model.rightButtonModel?.title, for: .normal)
        saveButton.setTitleColor(UIColor.TextColor.primaryBlue, for: .normal)
        if let imageAsset = model.rightButtonModel?.image {
            let image = UIImage(named: imageAsset).resizeImage(targetHeight: 28)
            saveButton.setImage(image, for: .normal)
            saveButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @objc private func backAction() {
        goBackHandler?()
    }
    
    @objc private func saveAction() {
        saveHandler?()
    }
    
    struct Model {
        let leftButtonHandler: CompletionHandler
        let rightButtonHandler: CompletionHandler?
        let rightButtonModel: ButtonModel?
        
    }
    
    struct ButtonModel {
        let title: String?
        let image: ImageAsset?
    }
    
    static func saveButtonModel(backHandler: @escaping CompletionHandler, saveHandler: @escaping CompletionHandler, title: String) -> Model {
        Model(
            leftButtonHandler: backHandler,
            rightButtonHandler: saveHandler,
            rightButtonModel: .init(title: title, image: nil)
        )
    }
    
}
