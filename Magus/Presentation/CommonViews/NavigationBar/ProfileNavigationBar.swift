//
//  ProfileNavigationBar.swift
//  Magus
//
//  Created by Jomz on 7/27/23.
//

import UIKit

class ProfileNavigationBar: ReusableXibView {
    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var saveButton: UIButton!
    
    var goBackHandler: CompletionHandler?
    var saveHandler: CompletionHandler?
    
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
    
    func configure(goBackHandler: @escaping CompletionHandler,
                   saveHandler: @escaping CompletionHandler) {
        self.goBackHandler = goBackHandler
        self.saveHandler = saveHandler
    }
    
    @objc private func backAction() {
        goBackHandler?()
    }
    
    @objc private func saveAction() {
        saveHandler?()
    }
    
}
