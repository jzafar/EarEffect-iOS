//
//  BLEConnectionViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-12.
//

import UIKit

class BLEConnectionViewController: BaseViewController {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var dotsView: DotsLoadingView!
    @IBOutlet weak var failView: UIView!
    let bleManger = BLEManager.shared
    @IBOutlet weak var lblConnecting: UILabel!
    var selectedIndex = 0
    var device : Device?
    override func viewDidLoad() {
        super.viewDidLoad()
        bleManger.scanForBLEDevices()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.failView.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        dotsView.show()
        self.perform(#selector(connect), with: nil, afterDelay: 2)
    }

    override func viewWillDisappear(_ animated: Bool) {
        dotsView.stop()
    }
    @objc func connect(){
        switch selectedIndex {
        case 0:
            self.performSegue(withIdentifier: "BLEConnectedViewController", sender: nil)
        case 1:
            lblConnecting.isHidden = true
            self.loadingView.isHidden = true
            self.failView.isHidden = false
        default:
            self.performSegue(withIdentifier: "BLEConnectedViewController", sender: nil)
            break
            
        }
        
    }
    @IBAction func avaiableDevicesBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! BLEConnectedViewController
        vc.device = device
    }
    

}
