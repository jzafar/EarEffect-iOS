//
//  LoginViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-12.
//

import AuthenticationServices
import GoogleSignIn
import UIKit

class LoginViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

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
            user.saveUserInfo()
            self?.performSegue(withIdentifier: "BecomeMemberViewController", sender: nil)
        }
    }

    @IBAction func loginWithFaceBook(_ sender: Any) {
        performSegue(withIdentifier: "BecomeMemberViewController", sender: nil)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
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
                        let user = LoginUser(name: String(describing: fullName) , email: email ?? "", id: userIdentifier, type: .apple)
                        user.saveUserInfo()
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
