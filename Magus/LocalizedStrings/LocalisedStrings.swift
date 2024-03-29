//
//  LocalisedStrings.swift
//  Magus
//
//  Created by Jose Mari Pascual on 5/10/23.
//

import Foundation

struct LocalisedStrings {
    
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
        static let title = "Unleash Your Mind's Potential"
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
        static let mood = "Mood"
        static let category = "Category"
        static let recommendations = "Recommendations"
        static let featuredPlayList = "Featured Playlists"
        static let featuredSubliminal = "Featured Subliminal"
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
        static let includeOneLowercase = "Include at least one lowercase letter (a-z)"
        static let includeOneNumber = "Include at least one number (0-9)"
        static let passwordMust = "Password must:"
    }
    
    enum HowMagusWorks {
        static let title = "How Magus Works"
    }
    
    enum Company {
        static let termsAndConditions = "Terms and Conditions"
        static let privacyAndPolicy = "Privacy and Policy"
    }
    
    enum FAQs {
        static let title = "Frequently Asked Questions"
        static let whatIsMagus = "What is Magus?"
        static let whatIsSubliminalAudio = "What is Subliminal Audio?"
        static let benefits = "What are the benefits listening to Subliminals?"
        static let audiosSafe = "Is subliminal audios safe?"
    }
    
    enum LoremIpsum {
        static let title = "Lorem Ipsum"
        static let desc1 = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        static let desc2 = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)."
    }
    
    enum Player {
        static let favorites = "Favorites"
        static let favorite = "Add to Favorites"
        static let favoriteRemove = "Remove from Favorites"
        static let like = "Like"
        static let addToQueue = "Add to Queue"
        static let addedToQueue = "Added to Queue"
        static let addToPlaylist = "Add to Playlist"
        static let removeFromPlaylist = "Remove from Playlist"
    }
}
