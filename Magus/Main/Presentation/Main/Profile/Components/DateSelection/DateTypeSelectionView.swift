//
//  DateTypeSelectionView.swift
//  Magus
//
//  Created by Jomz on 7/26/23.
//

import UIKit

class DateTypeSelectionView: ReusableXibView {
    
    @IBOutlet var titleLbl: UILabel! {
        didSet {
            titleLbl.text = "March 23, 2023"
            titleLbl.font = .Montserrat.bold15
        }
    }
    @IBOutlet var selectionView: UIView! {
        didSet {
            selectionView.backgroundColor = .clear
            selectionView.applyShadow(radius: 5)
        }
    }
    
    @IBOutlet var weeklyContainerView: UIView! {
        didSet {
            weeklyContainerView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 5)
        }
    }
    
    @IBOutlet var monthlyContainerView: UIView! {
        didSet {
            monthlyContainerView.roundCorners(corners: [.topRight, .bottomRight], radius: 5)
            monthlyContainerView.layer.opacity = 0
        }
    }
    
}
