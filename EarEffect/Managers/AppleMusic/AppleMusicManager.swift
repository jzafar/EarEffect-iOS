//
//  AppleMusicManager.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-08-09.
//

import Foundation
import MediaPlayer
import StoreKit
import SwiftUI

final class AppleMusicManager {
    static let shared = AppleMusicManager()
    private init() {}

    var isSignedIn: Bool {
        return userToken != nil
    }

    var userToken: String? {
        return UserDefaults.standard.string(forKey: UserDefaults.apple_token)
    }

    let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IlAzTjhLOFZIMzMifQ.eyJpc3MiOiJDODZaRk1aNFg5IiwiZXhwIjoxNjc1ODQ2MDc3LCJpYXQiOjE2NjAwNzQ0Nzd9.UW6yiFicg9YmYPRE6gH7DfTEXuoWgH9u39qTbd2RoMST40mdmgZl0ZwGOhwACq9DrQMs-eYxhGT9VcwqNNvYnA"

    func getUserToken(completion: @escaping (String?) -> Void) {
        SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken) { receivedToken, error in
            guard error == nil else {
                completion(nil)
                return
            }
            if let token = receivedToken {
                UserDefaults.standard.set(token, forKey: UserDefaults.apple_token)
                UserDefaults.standard.synchronize()
                completion(token)

            } else {
                completion(nil)
            }
        }
    }

    func requestStorefrontCountryCode(completion: @escaping (String) -> Void) {
        if SKCloudServiceController.authorizationStatus() == .authorized {
            SKCloudServiceController().requestStorefrontCountryCode { code, _ in
                if let code = code {
                    UserDefaults.standard.set(code, forKey: UserDefaults.country_code)
                    UserDefaults.standard.synchronize()
                    completion(code)
                }
            }
        }
    }

    func requestCloudServiceAuthorization(completion: @escaping (SKCloudServiceAuthorizationStatus) -> Void) {
        SKCloudServiceController.requestAuthorization { authorizationStatus in
            completion(authorizationStatus)
        }
    }

    func requestCloudServiceCapabilities(completion: @escaping (SKCloudServiceCapability?, Error?) -> Void) {
        SKCloudServiceController().requestCapabilities(completionHandler: { cloudServiceCapability, error in
            guard error == nil else {
                print("An error occurred when requesting capabilities: \(error!.localizedDescription)")
                completion(nil, error)
                return
            }
            completion(cloudServiceCapability, nil)
        })
    }

    func requestMediaLibraryAuthorization() {
        /*
         An application should only ever call `MPMediaLibrary.requestAuthorization(_:)` when their
         current authorization is `MPMediaLibraryAuthorizationStatusNotDetermined`
         */
        guard MPMediaLibrary.authorizationStatus() == .notDetermined else { return }

        /*
         `MPMediaLibrary.requestAuthorization(_:)` triggers a prompt for the user asking if they wish to allow the application
         that requested authorization access to the device's media library.

         This prompt will also include the value provided in the application's Info.plist for the `NSAppleMusicUsageDescription` key.
         This usage description should reflect what the application intends to use this access for.
         */

        MPMediaLibrary.requestAuthorization { _ in
//            NotificationCenter.default.post(name: AuthorizationManager.cloudServiceDidUpdateNotification, object: nil)
        }
    }
}
