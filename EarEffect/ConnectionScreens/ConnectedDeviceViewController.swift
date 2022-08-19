//
//  ConnectedDeviceViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-24.
//

import UIKit

class ConnectedDeviceViewController: BaseViewController {

    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var deviceImage: UIImageView!
    var device : Device?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let device = device {
            deviceName.text = device.name
            deviceImage.image = UIImage(named: device.image)
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func avaiableDeviceListBtnPressed(_ sender: RoundButton) {
        goToAvailableDeviceListViewController()
        
    }
    @IBAction func disconnectBtnPressed(_ sender: RoundButton) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to disconnect your device?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
            self.goToAvailableDeviceListViewController()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        self.present(alert, animated: true)
    }
    
    func goToAvailableDeviceListViewController(){
        if let viewControllers = self.navigationController?.viewControllers{
            for aViewController in viewControllers {
                if aViewController is AvailableDeviceListViewController {
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }
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
