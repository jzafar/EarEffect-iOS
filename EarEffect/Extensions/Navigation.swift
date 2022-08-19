//
//  Navigation.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-11.
//

import Foundation
import UIKit
public extension UINavigationBar {
//    func fixAppearance() {
//        if #available(iOS 14.0, *) {
//            topItem?.backButtonDisplayMode = .minimal
//        } else if #available(iOS 13.0, *) {
//            let newAppearance = standardAppearance.copy()
//            newAppearance.backButtonAppearance.normal.titleTextAttributes = [
//                .foregroundColor: UIColor.clear,
//                .font: UIFont.systemFont(ofSize: 0)
//            ]
//            standardAppearance = newAppearance
//        } else {
//            topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        }
//    }
}
extension UINavigationController {
    
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}
