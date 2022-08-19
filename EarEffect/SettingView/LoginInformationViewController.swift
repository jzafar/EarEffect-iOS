//
//  LoginInformationViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-24.
//

import UIKit
import GoogleSignIn
class LoginInformationViewController: BaseViewController {

    @IBOutlet weak var lblLoginDetails: UILabel!
    @IBOutlet weak var loginImageView: UIImageView!
    var isPushed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isPushed {
            self.setRightBarButton()
        }
        //You are logging in with ○○○○○○ account
        let user = LoginUser.getLoginUserInfo()
        if let user = user {
            switch user.type {
            case .apple:
                loginImageView.image = UIImage(named: "apple_white")
                lblLoginDetails.text = "You are logging in with \n Apple account."
            case .google:
                loginImageView.image = UIImage(named: "google_logo")
                lblLoginDetails.text = "You are logging in with \n Google account."
            case .facebook:
                loginImageView.image = UIImage(named: "facebook_logo")
                lblLoginDetails.text = "You are logging in with \n Facebook account."
            case .unknown:
                break
            }
        }
    }
    
    @IBAction func logOutBtnPressed(_ sender: RoundButton) {
        if let user = LoginUser.getLoginUserInfo(){
            if user.type == .google {
                GIDSignIn.sharedInstance.signOut()
                LoginUser.deleteUserInfo()
            }
            if user.type == .apple {
                LoginUser.deleteUserInfo()
            }
        }
        
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "RegiterNavigaton") as! UINavigationController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
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
