//
//  ViewController.swift
//  layersOfFun
//
//  Created by Jawaher Alagel on 11/15/20.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIView!
    @IBOutlet var topPin: NSLayoutConstraint!
    @IBOutlet var imageHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20.0
        imageView.layer.masksToBounds = true
        
        imageView.layer.borderWidth = 5.0
        imageView.layer.borderColor = UIColor.orange.cgColor
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let layer = imageView.layer
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.transform))
        
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0/1000.0
        layer.transform = perspective
        
        let initial = layer.transform
        
        let angle = CGFloat.pi/2
        let rotateAround = CATransform3DRotate(initial, angle, 0.0, 1.0, 0.0)
        let rotateAndMoveLeft = CATransform3DTranslate(rotateAround, 0.0, 0.0, -100.0)
        let rotateAndMoveRight = CATransform3DTranslate(rotateAround, 0.0, 0.0, 100.0)
        
        animation.values = [
            initial, rotateAround, rotateAndMoveLeft,
            rotateAndMoveRight, rotateAround, initial
        ]
        
        animation.duration = 2.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        animation.repeatCount = Float.infinity
        
        layer.add(animation, forKey: "spin")
        layer.transform = rotateAround
    }
    
    
}

