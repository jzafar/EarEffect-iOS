//
//  ViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } 
        // Do any additional setup after loading the view.
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let accepted = UserDefaults.standard.bool(forKey: UserDefaults.privacyPolicy)
        if accepted {
            let story = UIStoryboard(name: "Main", bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: "RegiterNavigaton") as! UINavigationController
    //        let navRootView = UINavigationController(rootViewController: vc)

            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.performSegue(withIdentifier: "PolicyViewController", sender: self)
            }

            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PolicyViewController" {
            //let loginPage = segue.destination as! PolicyViewController
       }
    }
    
}

