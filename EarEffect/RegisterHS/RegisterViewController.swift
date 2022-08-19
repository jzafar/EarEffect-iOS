//
//  RegisterViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-11.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var txtFirstName: GBTextField!
    @IBOutlet weak var txtLastName: GBTextField!
    @IBOutlet weak var txtEmail: GBTextField!
    
    @IBOutlet weak var txtSerialNumber: GBTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backButtonTitle = ""
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        }
    }
    @IBAction func registerBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "RegisteredViewController", sender: self)
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
