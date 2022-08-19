//
//  BecomeMemberViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-12.
//

import UIKit

class BecomeMemberViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func becomePaidMemberpressed(_ sender: Any) {
        self.performSegue(withIdentifier: "StartViewController", sender: self)
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
