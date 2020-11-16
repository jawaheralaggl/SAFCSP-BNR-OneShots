//
//  ImageProcessor.swift
//  Photorama
//
//  Created by Michael Ward on 9/14/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ImageProcessor {
    
    enum Priority {
        case high
        case low
    }
    
    enum Action {
        case scale(maxSize: CGSize)
        case pixelateFaces
        case filter(Filter)
    }
    
    enum Filter {
        case none
        case gloom(intensity: Double, radius: Double)
        case sepia(intensity: Double)
        case blur(radius: Double)
    }
    
    enum Error: Swift.Error {
        case incompatibleImage
        case filterConfiguration(name: String, params: [String:Any]?)
        case cancelled
    }
    
    
    let context = CIContext()
    
    typealias ResultHandler = (Result<UIImage, Swift.Error>) -> Void
    
    private let processingQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    @discardableResult
    func process(image: UIImage, actions: [Action], priority: ImageProcessor.Priority, completion: @escaping ResultHandler) -> ImageProcessingRequest {
        let imageOp = ImageProcessingOperation(image: image,
                                               actions: actions,
                                               context: context,
                                               priority: priority,
                                               completion: completion)
        
        let request = ImageProcessingRequest(operation: imageOp, queue: processingQueue)
        processingQueue.addOperation(imageOp)
        return request
    }
}
