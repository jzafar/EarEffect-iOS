//
//  BLEConnectedViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-13.
//

import UIKit

class BLEConnectedViewController: BaseViewController {
    
    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var lblDeviceName: UILabel!
    var device : Device?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let device = device {
            lblDeviceName.text = device.name
            self.deviceImage.image = UIImage(named: device.image)
        }
        navigationController?.removeViewController(BLEConnectionViewController.self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConnectedDeviceViewController" {
            let vc = segue.destination as! ConnectedDeviceViewController
            vc.device = device
        }
    }
    
    @IBAction func backToSettingsBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ConnectedDeviceViewController", sender: self)
    }
    
}
