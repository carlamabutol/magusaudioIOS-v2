//
//  EditProfileViewController.swift
//  Magus
//
//  Created by Jomz on 7/27/23.
//

import UIKit

class EditProfileViewController: CommonViewController {
    
    @IBOutlet var profileNavigationBar: ProfileNavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileNavigationBar.configure { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        } saveHandler: { [weak self] in
            self?.dismiss(animated: true)
        }

    }
    
}
