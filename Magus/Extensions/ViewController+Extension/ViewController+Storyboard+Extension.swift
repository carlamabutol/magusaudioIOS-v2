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
    
    // profile
    case profileMood = "ProfileMood"
    
    // Alert
    case loginAlert = "LoginAlert"
    
    // Edit Profile
    case editProfile = "EditProfile"
    case changePassword = "ChangePassword"
    case deleteAccount = "DeleteAccount"
    
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
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static func instantiateNibView() -> UIView? {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        guard let view = nib.instantiate(withOwner: nil, options: nil)[0] as? Self else {
            fatalError("UIVIew you are attempting to instantiate might be incorrect")
        }
        return view
    }
}

extension NSObject {
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}

public extension UITableView {
    
    /**
     Register nibs faster by passing the type - if for some reason the `identifier` is different then it can be passed
     - Parameter type: UITableViewCell.Type
     - Parameter identifier: String?
     */
    func registerCell(type: UITableViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: identifier ?? cellId)
    }
    
    /**
     DequeueCell by passing the type of UITableViewCell
     - Parameter type: UITableViewCell.Type
     */
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier) as? T
    }
    
    /**
     DequeueCell by passing the type of UITableViewCell and IndexPath
     - Parameter type: UITableViewCell.Type
     - Parameter indexPath: IndexPath
     */
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
    
}

public extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
