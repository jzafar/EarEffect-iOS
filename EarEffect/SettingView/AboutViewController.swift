//
//  AboutViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-24.
//

import UIKit

class AboutViewController: BaseViewController {
    @IBOutlet weak var txtAboutView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setRightBarButton()
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
