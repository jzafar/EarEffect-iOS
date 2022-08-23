//
//  RegisterViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-11.
//

import UIKit
import IHProgressHUD
class RegisterViewController: BaseViewController {
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
        guard let firstName = txtFirstName.text?.trimmingLeadingAndTrailingSpaces() else {
            return
        }
        if (firstName.count == 0) {
            showOkAlert(title: "Error", message: "Please enter First Name")
            return
        }
        
        guard let lastName = txtLastName.text?.trimmingLeadingAndTrailingSpaces() else {
            return
        }
        if lastName.count == 0 {
            showOkAlert(title: "Error", message: "Please enter Last Name")
            return
        }
        
        guard let email = txtEmail.text?.trimmingLeadingAndTrailingSpaces() else {
            return
        }
        if (email.count == 0) {
            showOkAlert(title: "Error", message: "Please enter your email")
            return
        }
        if !email.isValidEmail() {
            showOkAlert(title: "Error", message: "Please enter valid email")
            return
        }
        
        guard let txtSerialNumber = txtSerialNumber.text?.trimmingLeadingAndTrailingSpaces() else{
            return
        }
        if txtSerialNumber.count == 0 {
            showOkAlert(title: "Error", message: "Please enter Device Serial Number")
            return
        }
        
        let parameters = ["first_name":firstName,
                          "last_name":lastName,
                          "email":email,
                          "serial_number": txtSerialNumber]

        IHProgressHUD.show()
        ApiManager.shared.registerDevice(params: parameters) { (device, error) in
            IHProgressHUD.dismiss()
            DispatchQueue.main.async {
                if error == nil {
                    guard let device = device else {
                        self.showOkAlert(title: "Error", message: "Something went wrong. Please try again.")
                        return
                    }
                    var editedDevice = device
                    editedDevice.email = email
                    do {
                         try UserDefaults.standard.setObject(editedDevice, forKey: UserDefaults.registeredDevice)
                    } catch let error1 {
                        print(error1.localizedDescription)
                    }
                    UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: "RegisteredViewController", sender: self)
                } else {
                    if let error = error {
                        self.showOkAlert(title: "Error", message: "\(error.localizedDescription)")
                    }
                    
                }
            }
            
           
        }
        
//
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
