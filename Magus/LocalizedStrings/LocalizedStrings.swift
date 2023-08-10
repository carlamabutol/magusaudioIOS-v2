//
//  LocalizedStrings.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/10/23.
//

import Foundation

struct LocalizedStrings {
    
    enum Auth {
        static let fullName = "Full Name"
        static let email = "Email"
        static let password = "Password"
        static let confirmPassword = "Confirm Password"
    }
    
    enum Welcome {
        static let signInWithEmail = "SIGN IN WITH YOUR E-MAIL"
        static let newHere = "New here? "
        static let createAccountForFree = "Create an Account for Free"
    }
    
    enum Login {
        static let loginTitleButton = "Login"
        static let forgotPassword = "Forgot Password?"
        static let welcomeBackTitle = "Welcome back!"
        static let signInStartListening = "Sign in to start listening."
        static let dontHaveAnAccount = "Don’t have an account? "
        static let signUp = "SIGN UP"
        static let signIn = "SIGN IN"
        static let signInError = "Username or Password is less than 8 characters"
    }
    
    enum SignUp {
        static let title = "Welcome back!"
        static let description = "Sign up and transform your life today."
        static let termsAndCondition = "Terms and Conditions"
        static let iAgreeWithTermsAndCondition = "I agree with the Terms and Conditions"
        static let alrdyHaveAnAccount = "Already have an Account? SIGN IN"
        static let signUp = "SIGN UP"
        static let signIn = "SIGN IN"
    }
    
    enum TermsAndCondition {
        static let title = "Terms And Condition"
        static let description = """
        Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.
        1. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
        2. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.
        3.At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
        Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
        """
        static let accept = "Accept"
    }
    
    enum ForgotPassword {
        static let title = "Forgotten your password?"
        static let description = "No worries! We'll help you reset it in a breeze."
        static let submit = "Submit"
        static let dontHaveAnAccount = "Don’t have an account? "
        static let signUp = "SIGN UP"
    }
    
    enum MoodSelection {
        static let title = "How are you feeling, User?"
        static let continueButtonTitle = "Continue"
    }
    
    enum TabBarTitle {
        static let home = "Home"
        static let search = "Search"
        static let subs = "My Subs"
        static let premium = "Go Premium"
        static let profile = "Profile"
    }
    
    enum HomeHeaderTitle {
        static let category = "Category"
        static let recommendations = "Recommendations"
        static let featuredPlayList = "Featured Playlists"
    }
    
    enum SearchHeaderTitle {
        static let playlist = "Playlist"
        static let subliminal = "Subliminal"
    }
    
    enum Premium {
        static let title = "Upgrade plan to\nExperience More."
        static let subTitle = "Unlock all Premium Features"
        static let chooseYourPlan = "Choose your Plan"
        static let continueBtn = "Continue"
    }
    
    enum EditProfile {
        static let userDetailsTitle = "User Details"
        static let accountPrivacy = "Account Privacy"
        static let changePassword = "Change Password"
        static let deletePassword = "Delete Account"
        static let firstName = "First Name"
        static let lastName = "Last Name"
        static let email = "Email"
        static let currentPassword = "Current Password"
        static let enterNewPassword = "Enter New Password"
        static let confirmPassword = "Confirm Password"
        static let save = "Save"
    }
    
    enum ChangePassword {
        static let contain8Characters = "Contain at least 8 characters"
        static let includeOneUppercase = "Include at least one uppercase letter (A-Z)"
        static let includeOneNumber = "Include at least one number (0-9)"
        static let passwordMust = "Password must:"
    }
}
