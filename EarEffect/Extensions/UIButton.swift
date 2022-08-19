//
//  UIButton.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-16.
//

import Foundation
import UIKit
extension UIButton {
    func dropShadow(){
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
    }
    
}
