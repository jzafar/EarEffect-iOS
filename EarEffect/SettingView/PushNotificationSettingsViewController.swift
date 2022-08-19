//
//  PushNotificationSettingsViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-24.
//

import UIKit

class PushNotificationSettingsViewController: BaseViewController {

    @IBOutlet weak var campaignSwitch: UISwitch!
    
    @IBOutlet weak var latestRelease: UISwitch!
    
    @IBOutlet weak var newRelease: UISwitch!
    
    @IBOutlet weak var maintenenceInformation: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func campaignInformationBtnPressed(_ sender: UISwitch) {
    }
    @IBAction func latestInformationBtnPressed(_ sender: UISwitch) {
    }
    
    @IBAction func newRelaseBtnPressed(_ sender: UISwitch) {
    }
    
    @IBAction func maintenenceInformationBtnPressed(_ sender: UISwitch) {
    }
}
