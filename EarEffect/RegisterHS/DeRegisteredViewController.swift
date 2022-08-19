//
//  DeRegisteredViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-11.
//

import UIKit

class DeRegisteredViewController: UIViewController {

    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ReregiterButtonPressed(_ sender: Any) {
        
        guard let VC = self.navigationController?.viewControllers.filter({$0.isKind(of: RegisterViewController.self)}).first else {
            return
        }
        self.navigationController?.popToViewController(VC, animated: true)
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
