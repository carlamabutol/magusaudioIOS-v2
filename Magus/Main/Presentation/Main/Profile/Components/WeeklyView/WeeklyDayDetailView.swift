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
    
    func configure(url: URL?, mood: String, subliminal: String, desc: String) {
        if(url != nil){
            moodImageView.sd_setImage(with: url)
        }
        if(subliminal != "-"){
            descriptionLbl.text = "You mostly listend to " + subliminal
        }else{
            descriptionLbl.text = ""
        }
        if(url == nil && subliminal == "-"){
            moodLbl.text = "No data to display"
        }else{
            moodLbl.text = mood
        }
    }
    
}
