//
//  WordCounter.swift
//  AsyncStock
//
//  Created by Michael Ward on 9/30/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit

class WordCounter {
    
    private let counterQueue = DispatchQueue.global(qos: .userInitiated)
    
    struct State {
        var totalCount = 0
        var wordList: [String:Int] = [:]
    }
    
    private var lockedState = Locked(State())
    
    var currentState: State {
        return lockedState.withLock({ $0 })
    }
    
    private(set) var text: Text
    
    init(text: Text) {
        self.text = text
    }
    
    // MARK: - Counting
    
    func start(completion: @escaping ()->Void) {
        print("Analyzing \"\(text.name)\"")
        counterQueue.async { [weak self] in
            guard let self = self else { return }
            self.countWords()
            print("Finished  \"\(self.text.name)\"")
            DispatchQueue.main.async {
                completion()
            }
        }
        
    }
    
    private func countWords() {
        
        let textRange: Range<String.Index> =
            text.body.startIndex..<text.body.endIndex
        
        text.body.enumerateSubstrings(in: textRange, options: .byWords) {
            (substring, subRange, enclosingRange, stop) in
            guard let substring = substring else { return }
            
            self.lockedState.withLock({ state in
                if let count = state.wordList[substring] {
                    let newCount = count + 1
                    state.wordList[substring] = newCount
                } else {
                    state.wordList[substring] = 1
                }
                
                state.totalCount += 1
            })
            
        }
    }
    
}
