//
//  Locked.swift
//  Wordalysis
//
//  Created by Jawaher Alagel on 11/19/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit

class Locked<Content> {
    
    private var content: Content
    private let semaphore = DispatchSemaphore(value: 1)
    
    init(_ content: Content) {
        self.content = content
    }
    
    func withLock<Return>(_ workItem: (inout Content) throws -> Return) rethrows -> Return {
        semaphore.wait()
        defer {
            semaphore.signal()
        }
        
        let retVal = try workItem(&content)
                return retVal
    }
}
