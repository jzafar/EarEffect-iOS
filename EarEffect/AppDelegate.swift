//
//  AppDelegate.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-11.
//

import AVFoundation
import IQKeyboardManagerSwift
import UIKit
import GoogleSignIn
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().tintColor = .white
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
       
        
//        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//            if error != nil || user == nil {
//              // Show the app's signed-out state.
//            } else {
//              // Show the app's signed-in state.
//            }
//          }

        if SpotifyAuthManager.shared.isSignedIn {
            SpotifyAuthManager.shared.refreshIfNeeded(completion: nil)
        }
        // Init facebook sdk
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
//        printFonts()
        return true
    }

    func printFonts() {
        for familyName in UIFont.familyNames {
            print("\n-- \(familyName) \n")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//      var handled: Bool
//      handled = GIDSignIn.sharedInstance.handle(url)
//      if handled {
//        return true
//      }
//
//      // Handle other custom URL types.
//
//      // If not handled by this app, return false.
//      return false
//    }
}
