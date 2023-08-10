//
//  MySubsViewController.swift
//  Magus
//
//  Created by Jomz on 8/10/23.
//

import UIKit

class MySubsViewController: CommonViewController {
    var profileViewModel: ProfileViewModel!
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .Montserrat.bold17
        }
    }
    
    @IBOutlet var playlistsButton: UIButton! {
        didSet {
            playlistsButton.titleLabel?.font = .Montserrat.bold15
        }
    }
    @IBOutlet var favoritesButton: UIButton! {
        didSet {
            favoritesButton.titleLabel?.font = .Montserrat.bold15
        }
    }
}
