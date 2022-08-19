//
//  PolicyViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-11.
//

import UIKit

class PolicyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } 
        // Do any additional setup after loading the view.
    }
    

    @IBAction func AcceptButtonPressed(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "RegiterNavigaton") as! UINavigationController
//        let navRootView = UINavigationController(rootViewController: vc)

        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
//        if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
//            delegate.window?.rootViewController = self
//            delegate.window?.makeKeyAndVisible()
//        }
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
