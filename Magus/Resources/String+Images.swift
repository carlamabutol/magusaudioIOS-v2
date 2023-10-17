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
    
    func resizeImage(targetHeight: CGFloat) -> UIImage {
        // Get current image size
        let size = self.size

        // Compute scaled, new size
        let heightRatio = targetHeight / size.height
        let newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Create new image
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Return new image
        return newImage!
    }
    
}

enum ImageAsset: String {
    
    // MARK: Tab
    
    case coverImage = "Cover Image"
    
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
    
    case leftArrow = "left arrow"
    case option = "option"
    
    // player
    case favorite = "heart"
    case favoriteIsActive = "active heart"
    case repeatAll = "repeat"
    
    case addPlaylist = "add playlist"
    
    case trash = "trash can"
    case edit = "edit profile"
    
    case delete = "Trash Delete"
    
    // mood
    case positive
    case negative
    
    // How Magus Works
    case howMagusWorks1 = "how-magus-works-1"
    case howMagusWorks2 = "how-magus-works-2"
    
    // Subliminal Guide
    case guide1 = "guide-1"
    case guide2 = "guide-2"
    case guide3 = "guide-3"
    
    case collapsedDown = "collapsed-down"
    case collapsedUp = "collapsed-up"
    
}
