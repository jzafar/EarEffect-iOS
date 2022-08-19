//
//  HelpViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-24.
//

import UIKit

class HelpViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setRightBarButton()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func instructionBtnPressed(_ sender: UIButton) {
        
        let inst = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InstructionsViewController") as! InstructionsViewController
        inst.isPushed = true
        self.navigationController?.pushViewController(inst, animated: true)
    }
    @IBAction func faqBtnPressed(_ sender: UIButton) {
        let qa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QAViewController") as! QAViewController
        self.navigationController?.pushViewController(qa, animated: true)
    }
    @IBAction func submitEnquiryBtnPressed(_ sender: UIButton) {
        let enc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubmitEnquiryViewController") as! SubmitEnquiryViewController
        enc.isPushed = true
        self.navigationController?.pushViewController(enc, animated: true)
    }
    
}
