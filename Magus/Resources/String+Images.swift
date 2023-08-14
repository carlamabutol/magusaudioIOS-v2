//
//  String+Images.swift
//  Magus
//
//  Created by Jomz on 5/15/23.
//

import UIKit

extension String {
    
    static let magusLogoSignIn = "MagusLogo"
    static let splashMagusLogo = "MagusLogoSplashScreen"
    static let splashBetterWith = "SplashBetterWith"
    static let splashListening = "SplashListening"
    static let splashSunHeader = "SplashSunHeader"
    
    static let checkIcon = "check"
    static let eyeHide = "eyeHide"
    static let eyeShow = "eyeShow"
    
}

extension UIImage {
    
    convenience init!(named name: ImageAsset) {
        self.init(named: name.rawValue)
    }
    
}

enum ImageAsset: String {
    
    // MARK: Tab
    
    case tabHomeUnselected = "TabHome"
    case tabHomeSelected = "TabHomeSelected"
    
    case tabSearchUnselected = "TabSearch"
    case tabSearchSelected = "TabSearchSelected"
    
    case tabSoundUnselected = "TabSound"
    case tabSoundSelected = "TabSoundSelected"
    
    case tabPremiumUnselected = "TabPremium"
    case tabPremiumSelected = "TabPremiumSelected"
    
    case tabUserUnselected = "TabUser"
    case tabUserSelected = "TabUserSelected"
    
    case cross
    case check
    
    case goodPassword = "Good Password"
    
}
