//
//  GradiantLayer.swift
//  health_app
//
//  Created by Ana Carolina Nascimento on 7/14/16.
//  Copyright © 2016 Ana Carolina Nascimento. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView
{
    
    @IBInspectable var startColor: UIColor = UIColor.white()
    @IBInspectable var endColor:   UIColor = UIColor.black()
    
    @IBInspectable var startLocation: Double = 0.05
    @IBInspectable var endLocation:   Double = 0.95
    
    @IBInspectable var horizontalMode: Bool = false
    @IBInspectable var diagonalMode: Bool = false
    
    override class func layerClass() -> AnyClass { return CAGradientLayer.self }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layer = layer as? CAGradientLayer else { return }
        if horizontalMode {
            if diagonalMode {
                layer.startPoint = CGPoint(x: 1, y: 0)
                layer.endPoint   = CGPoint(x: 0, y: 1)
            } else {
                layer.startPoint = CGPoint(x: 0, y: 0.5)
                layer.endPoint   = CGPoint(x: 1, y: 0.5)
            }
        } else {
            if diagonalMode {
                layer.startPoint = CGPoint(x: 0, y: 0)
                layer.endPoint   = CGPoint(x: 1, y: 1)
            } else {
                layer.startPoint = CGPoint(x: 0.5, y: 0)
                layer.endPoint   = CGPoint(x: 0.5, y: 1)
            }
        }
        layer.locations = [startLocation     , endLocation]
        layer.colors    = [startColor.cgColor, endColor.cgColor]
    }
}
