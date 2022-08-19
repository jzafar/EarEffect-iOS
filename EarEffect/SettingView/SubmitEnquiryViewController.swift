//
//  SubmitEnquiryViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-24.
//

import UIKit

class SubmitEnquiryViewController: BaseViewController {
    @IBOutlet var lblEmail: GBTextField!
    @IBOutlet var lblName: GBTextField!
    @IBOutlet var phonrNumber: GBTextField!
    var placeholderLabel = UILabel()
    @IBOutlet var textView: UITextView!
    var isPushed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isPushed {
            self.setRightBarButton()
        }
        textView.delegate = self
        placeholderLabel.text = "Enter text..."
        placeholderLabel.font = UIFont(name: "NotoSans-Medium", size: (textView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    @IBAction func submitBtnPressed(_ sender: UIButton) {
        if !isPushed {
            dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }

}

extension SubmitEnquiryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
