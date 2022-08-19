//
//  DotedStragintLine.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-14.
//

import Foundation
import UIKit
class DotedStragintLine: UIView {
    override func awakeFromNib() {
        drawArc()
    }

    private func drawArc() {
//        let startAngle: CGFloat = CGFloat(0)
//
//        let endAngle: CGFloat = CGFloat(90)
//
//        let path = UIBezierPath(arcCenter: CGPoint(x: frame.size.height / 2, y: frame.size.height / 2), radius: frame.size.height / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        let x = self.frame.size.width/2
        let y = self.frame.size.height
        let startPoint = CGPoint(x: x, y: y)
        let ex = self.frame.size.width/2
        let endPoint = CGPoint(x: ex, y: 0)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineDashPattern = [1, 25]
        layer.addSublayer(shapeLayer)
        
        
        
        
    }
}
