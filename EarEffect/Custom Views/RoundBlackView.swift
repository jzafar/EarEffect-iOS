//
//  RoundBlackView.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-13.
//

import UIKit

class RoundBlackView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
//    override func awakeFromNib() {
//        addBottomLine(color: .gray, height: 1)
//    }
    
    override func layoutSubviews() {
            super.layoutSubviews()

            let path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 0, dy: 0), byRoundingCorners: [ .topLeft, .bottomLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 6, height: 6))

            let gradient = CAGradientLayer()
            gradient.frame =  CGRect(origin: CGPoint.zero, size: frame.size)
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
            gradient.colors = [UIColor.lightGray.cgColor, UIColor.clear.cgColor]

            let shape = CAShapeLayer()
            shape.lineWidth = 1
            shape.path = path.cgPath
            shape.strokeColor = UIColor.lightGray.cgColor
            shape.fillColor = UIColor.clear.cgColor
            gradient.mask = shape

            layer.insertSublayer(gradient, at: 0)
        }
    
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
}
