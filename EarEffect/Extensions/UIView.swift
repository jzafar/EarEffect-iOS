//
//  UIView.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-16.
//

import Foundation
import UIKit

extension UIView {
    func dropShadowUnderView() {
        layer.shadowOffset = CGSize(width: 0,
                                    height: 15)
        layer.shadowRadius = 10
        layer.shadowOpacity = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

//    public class func fromNib<T: UIView>() -> T {
//        let name = String(describing: Self.self);
//        guard let nib = Bundle(for: Self.self).loadNibNamed(
//                name, owner: nil, options: nil)
//        else {
//            fatalError("Missing nib-file named: \(name)")
//        }
//        return nib.first as! T
//    }
    func fixInView(_ container: UIView!) {
        translatesAutoresizingMaskIntoConstraints = false
        frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

