//
//  AutoModeViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-15.
//

import UIKit
protocol AutoModeDelegate {
    func setAutoMode(mode: String)
}
class AutoModeViewController: BaseViewController {
    
    var delegate: AutoModeDelegate?
    @IBOutlet weak var lblMode: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeCategoryBtnPressed(_ sender: RoundButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModeViewController") as! ModeViewController
        //vc.modalPresentationStyle = .overCurrentContext
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        vc.view.alpha = 0.9
        vc.view.backgroundColor = UIColor.hexStr(hexStr: "#005292", alpha: 0.9)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
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
extension AutoModeViewController:ModeControllerDelegate{
    func setMode(mode: String) {
        lblMode.text = mode
        self.delegate?.setAutoMode(mode: mode)
    }
    
}
