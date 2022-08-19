//
//  QAViewController.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-24.
//

import UIKit

class QAViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationTitleFont = UIFont(name: "NotoSans-Bold", size: 18)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: navigationTitleFont,
                                                                        NSAttributedString.Key.foregroundColor: UIColor.white]

        self.title = "Help"
    }

}
