//
//  ViewController+Storyboard+Extension.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/21/23.
//

import UIKit

enum StoryboardString: String {
    
    case rootView = "RootViewController"
    
    // OnBoarding
    case splashscreen = "SplashScreen"
    case welcome = "Welcome"
    
    // Authentication
    case login = "Login"
    case signUp = "SignUp"
    case termsAndCondition = "TermsAndCondition"
    case forgotPassword = "ForgotPassword"
    
    case mood = "Mood"
    
    // Tabbar
    case mainTabBar = "MainTabBar"
    case home = "Home"
    case search = "Search"
    case subs = "Subs"
    case premium = "Premium"
    case profile = "Profile"
    
}

extension UIViewController {
    
    static func instantiate(from storyboard: StoryboardString) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("UIViewController you are attempting to instantiate might noe be the inital view controller or the storyboard name might be incorrect")
        }
        return viewController
    }
    
}

extension UIView {
    
    
    static func instantiate() -> UINib? {
        UINib(nibName: String(describing: type(of: self)), bundle: nil)
    }
}
