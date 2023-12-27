//
//  WeeklyDayDetailView.swift
//  Magus
//
//  Created by Jomz on 7/27/23.
//

import UIKit
import SDWebImage

class WeeklyDayDetailView: ReusableXibView {
    
    @IBOutlet var moodImageView: UIImageView!
    @IBOutlet var moodLbl: UILabel! {
        didSet {
            moodLbl.font = .Montserrat.bold17
        }
    }
    
    @IBOutlet var descriptionLbl: UILabel! {
        didSet {
            descriptionLbl.font = .Montserrat.body1
        }
    }
    
    func configure(url: URL?, mood: String, desc: String) {
        moodImageView.sd_setImage(with: url)
        moodLbl.text = mood
        descriptionLbl.text = desc
    }
    
}
