//
//  Shakeable.swift
//  Captcha
//
//  Created by Kousa, Yahya on 2/14/24.
//

import Foundation
import UIKit

protocol Shakeable
{
    func shake()
}

extension Shakeable where Self : UIView
{
    func shake()
    {
        let animation = CABasicAnimation(keyPath: "position")
        
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 4.0, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4.0, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")

    }
}
