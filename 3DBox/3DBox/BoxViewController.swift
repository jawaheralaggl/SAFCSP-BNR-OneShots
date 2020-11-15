//
//  BoxViewController.swift
//  3DBox
//
//  Created by Jawaher Alagel on 11/15/20.
//

import UIKit

class BoxViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    let box = CATransformLayer()
    
    var isButtonPressed = false {
        // Adding a Property Observer that reacts to changes in button state
        didSet{
            if isButtonPressed{
                // Run the animation function.
                startAnimation()
            }else{
                // Stop animation function.
                stopAnimation()
            }
        }
    }
    
    @IBOutlet weak var spinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        spinButton.layer.cornerRadius = spinButton.frame.height / 2
        
        // Create the front side
        let transform1 = CATransform3DMakeTranslation(0, 0, 100)
        box.addSublayer(side(with: transform1, color: .systemPurple, image: UIImage(systemName: "star")!))
        
        // Create the right side
        var transform2 = CATransform3DMakeTranslation(100, 0, 0)
        transform2 = CATransform3DRotate(transform2, CGFloat.pi / 2, 0, 1, 0)
        box.addSublayer(side(with: transform2, color: .yellow, image: UIImage(systemName: "moon")!))
        
        // Create the top side
        var transform3 = CATransform3DMakeTranslation(0, -100, 0)
        transform3 = CATransform3DRotate(transform3, CGFloat.pi / 2, 1, 0, 0)
        box.addSublayer(side(with: transform3, color: .green, image: UIImage(systemName: "sun.min")!))
        
        // Create the bottom side
        var transform4 = CATransform3DMakeTranslation(0, 100, 0)
        transform4 = CATransform3DRotate(transform4, -(CGFloat.pi / 2), 1, 0, 0)
        box.addSublayer(side(with: transform4, color: .white, image: UIImage(systemName: "suit.heart")!))
        
        // Create the left side
        var transform5 = CATransform3DMakeTranslation(-100, 0, 0)
        transform5 = CATransform3DRotate(transform5, -(CGFloat.pi / 2), 0, 1, 0)
        box.addSublayer(side(with: transform5, color: .cyan, image: UIImage(systemName: "cloud")!))
        
        // Create the back side
        var transform6 = CATransform3DMakeTranslation(0, 0, -100)
        transform6 = CATransform3DRotate(transform6, CGFloat.pi, 0, 1, 0)
        box.addSublayer(side(with: transform6, color: .magenta, image: UIImage(systemName: "sparkle")!))
        
        // Position the transform layer in the center
        box.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        
        // Add the box to our main view's layer
        view.layer.addSublayer(box)
    }
    
    // MARK: - Creat a function to set each side of the box
    
    func side(with transform: CATransform3D, color: UIColor, image: UIImage) -> CALayer {
        let face = CALayer()
        face.frame = CGRect(x: -100, y: -100, width: 200, height: 200)
        face.backgroundColor = color.cgColor
        face.contents = image.cgImage
        face.contentsGravity = CALayerContentsGravity.center
        face.transform = transform
        return face
    }
    
    // MARK: - Manage sliders for each axis
    
    @IBAction func sliderXValueChanged(_ sender: Any) {
        UpdateTransform.shared.updateTransformX(box: self.box)
    }
    
    @IBAction func sliderYValueChanged(_ sender: Any) {
        UpdateTransform.shared.updateTransformY(box: self.box)
    }
    
    @IBAction func sliderZValueChanged(_ sender: Any) {
        UpdateTransform.shared.updateTransformZ(box: self.box)
    }
    
    // MARK: - Manage spin button
    
    @IBAction func spinArroundTapped(_ sender: UIButton) {
        // Toggle the button value
        isButtonPressed = !isButtonPressed
    }
    
    func startAnimation() {
        // Set animation to keep spinning the box indefinitely
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = box.transform
        animation.toValue = CATransform3DMakeRotation(CGFloat.pi, 1, 1, 1)
        animation.duration = 2
        animation.isCumulative = true
        animation.repeatCount = .greatestFiniteMagnitude
        box.add(animation, forKey: "transform")
    }
    
    func stopAnimation() {
        // Stop Animation
        box.removeAllAnimations()
    }
    
}
