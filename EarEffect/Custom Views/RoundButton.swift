//
//  RoundButton.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-11.
//

import Foundation
import UIKit

@IBDesignable
class RoundButton: UIButton {
    // button corner radius
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
           self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
           self.layer.borderColor = borderColor.cgColor
        }
    }
    // button border width
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
           self.layer.borderWidth = borderWidth
        }
    }
    
    var streamButton: Streams?
}
