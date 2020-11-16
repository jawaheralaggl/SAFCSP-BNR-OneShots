//
//  ImageProcessingOperation.swift
//  Photorama
//
//  Created by Jawaher Alagel on 11/16/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ImageProcessingOperation: Operation {
    
    var image: UIImage?
    let actions: [ImageProcessor.Action]
    let context: CIContext
    let completion: ImageProcessor.ResultHandler
    
    init(image: UIImage, actions: [ImageProcessor.Action], context: CIContext, priority: ImageProcessor.Priority = .low, completion: @escaping ImageProcessor.ResultHandler) {
        self.image = image
        self.actions = actions
        self.context = context
        self.completion = completion
        super.init()
        
        switch priority {
        case .high:
            qualityOfService = .userInitiated
            queuePriority = .high
        case .low:
            qualityOfService = .utility
            queuePriority = .low
        }
    }
    
    override func cancel() {
    super.cancel()
    image = nil
    }
    
    convenience init(operation: ImageProcessingOperation, priority: ImageProcessor.Priority = .low) {
        
        guard let image = operation.image else {
        preconditionFailure("FATAL: Attempt to clone an operation with nil image")
        }

        self.init(image: image, actions: operation.actions, context: operation.context, priority: priority, completion: operation.completion)
    }
    
    override func main() {
        guard let image = image else {
            completion(.failure(ImageProcessor.Error.cancelled))
            return
        }
        
        do {
            let processedImage = try perform(actions, on: image)
            completion(.success(processedImage))
        } catch {
            completion(.failure(error)) }
    }
    
    
    func perform(_ actions: [ImageProcessor.Action], on image: UIImage) throws -> UIImage {
        
        guard !isCancelled else { throw ImageProcessor.Error.cancelled }
        // Set up the CIImage and context
        guard var workingImage = CIImage(image: image) else {
            throw ImageProcessor.Error.incompatibleImage
        }
        
        // Apply requested processing
        for action in actions {
            guard !isCancelled else { throw ImageProcessor.Error.cancelled }
            
            switch action {
            case .pixelateFaces:
                workingImage = workingImage.pixelatedFaces(using: context)
            case .scale(let maxSize):
                workingImage = workingImage.scaled(toFit: maxSize)
            case .filter(let filter):
                workingImage = try workingImage.filtered(filter)
            }
        }
        
        // Rasterize the final UIImage from the CIImage recipe.
        let resultImage = UIImage(ciImage: workingImage)
        guard !isCancelled else { throw ImageProcessor.Error.cancelled }
        return resultImage
        
    }
    
    
}
