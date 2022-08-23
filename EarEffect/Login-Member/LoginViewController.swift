//
//  LoginViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-12.
//

import AuthenticationServices
import CryptoKit
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn
import IHProgressHUD
import UIKit

class LoginViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        btnFaceBook.permissions = ["public_profile", "email"]
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @IBAction func loginWithApple(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    @IBAction func loginWithGoogle(_ sender: Any) {
        let signInConfig = GIDConfiguration(clientID: "664847321403-e42cjkbb7grgn7hihoqqhl3ru6f2kcvb.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { [weak self] user, error in
            guard let signInUser = user else {
                // Inspect error
                if let error = error {
                    if error._code != -5 {
                        self?.showOkAlert(title: "Error", message: "\(error.localizedDescription)")
                    }
                }
                return
            }
            print("\(signInUser)")

            let user = LoginUser(name: signInUser.profile?.name ?? "", email: signInUser.profile?.email ?? "", id: signInUser.userID ?? "", type: .google)
            guard let userid = signInUser.userID else {
                self?.showOkAlert(title: "Error", message: "Something went wrong try again")
                return
            }
//            user.saveUserInfo()
            IHProgressHUD.show()
            let param = ["name": user.name,
                         "email": user.email,
                         "platform": "google",
                         "user_id": userid] as [String: Any]
            ApiManager.shared.login(params: param) {
                IHProgressHUD.dismiss()
                self?.goToNextScreen()
            }
        }
    }

    func goToNextScreen() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "BecomeMemberViewController", sender: nil)
        }
    }

    @IBAction func loginWithFaceBook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] result, error in
            guard error == nil else {
                self?.showOkAlert(title: "Error", message: "Something went wrong try again")
                print(error!.localizedDescription)
                return
            }
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }

            guard let userid = result.token?.userID else {
                self?.showOkAlert(title: "Error", message: "Something went wrong try again")
                return
            }

            Profile.loadCurrentProfile { profile, error in
                let param = ["name": profile?.name ?? "",
                             "email": profile?.email ?? "",
                             "platform": "facebook",
                             "user_id": userid] as [String: Any]
                IHProgressHUD.show()
                ApiManager.shared.login(params: param) {
                    IHProgressHUD.dismiss()
                    self?.goToNextScreen()
                }
            }
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) { credentialState, _ in
                switch credentialState {
                case .authorized:
                    DispatchQueue.main.async {
                        let user = LoginUser(name: String(describing: fullName), email: email ?? "", id: userIdentifier, type: .apple)
                        user.saveUserInfo()
                        let param = ["name": user.name,
                                     "email": user.email,
                                     "platform": "apple",
                                     "user_id": userIdentifier] as [String: Any]
                        IHProgressHUD.show()
                        ApiManager.shared.login(params: param) {
                            IHProgressHUD.dismiss()
                            self.goToNextScreen()
                        }
                        self.performSegue(withIdentifier: "BecomeMemberViewController", sender: nil)
                    }
                case .revoked:
                    DispatchQueue.main.async {
                        self.showOkAlert(title: "Error", message: "It seems your  Apple ID credential is revoked. Please fix your account")
                    }
                case .notFound:
                    DispatchQueue.main.async {
                        self.showOkAlert(title: "Error", message: "No credential was found.")
                    }
                default:
                    break
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    }
}
