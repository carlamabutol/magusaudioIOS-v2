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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupTapActions() {
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        if saveHandler != nil {
            saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        }
    }
    
    func hideShowButton(isHidden: Bool) {
        saveButton.isHidden = isHidden
    }
    
    func configure(goBackHandler: @escaping CompletionHandler,
                   saveHandler: CompletionHandler? = nil) {
        self.goBackHandler = goBackHandler
        self.saveHandler = saveHandler
        self.hideShowButton(isHidden: saveHandler == nil)
        self.setupTapActions()
    }
    
    @objc private func backAction() {
        goBackHandler?()
    }
    
    @objc private func saveAction() {
        saveHandler?()
    }
    
}
