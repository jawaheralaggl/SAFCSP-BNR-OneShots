//
//  UpdateTransform.swift
//  3DBox
//
//  Created by Jawaher Alagel on 11/15/20.
//

import UIKit

struct UpdateTransform {
    static let shared = UpdateTransform()
    
    // rotate the box for X axis
    func updateTransformX(box: CATransformLayer) {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        
        let initial = box.transform
        animation.fromValue = initial
        let angle = CGFloat.pi/4
        let rotateAround = CATransform3DRotate(initial, angle, 1.0, 0.0, 0.0)
        animation.toValue = rotateAround
        animation.duration = 0.0
        box.add(animation, forKey: "spin")
        box.transform = rotateAround
    }
    
    // rotate the box for Y axis
    func updateTransformY(box: CATransformLayer) {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        
        let initial = box.transform
        animation.fromValue = initial
        let angle = CGFloat.pi/4
        let rotateAround = CATransform3DRotate(initial, angle, 0.0, 1.0, 0.0)
        animation.toValue = rotateAround
        animation.duration = 0.0
        box.add(animation, forKey: "spin")
        box.transform = rotateAround
    }
    
    // rotate the box for Z axis
    func updateTransformZ(box: CATransformLayer) {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        
        let initial = box.transform
        animation.fromValue = initial
        let angle = CGFloat.pi/4
        let rotateAround = CATransform3DRotate(initial, angle, 0.0, 0.0, 1.0)
        animation.toValue = rotateAround
        animation.duration = 0.0
        box.add(animation, forKey: "spin")
        box.transform = rotateAround
    }
    
    
}
