//
//  RegisteredViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-11.
//

import UIKit
import Kingfisher
class RegisteredViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblEnjoye: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backButtonTitle = ""
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        }
        let userDefaults = UserDefaults.standard
        do {
            let device = try userDefaults.getObject(forKey: UserDefaults.registeredDevice, castTo: RegisterDevice.self)
            print(device.name)
            
        } catch {
            print(error.localizedDescription)
        }
    }

}
