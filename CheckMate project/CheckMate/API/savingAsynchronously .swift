//
//  savingAsynchronously .swift
//  CheckMate
//
//  Created by Jawaher Alagel on 11/16/20.
//

import UIKit

class savingAsynchronously: Operation {
    
    // MARK: - Data persistance (Gold Challenge)
    
    // Saving data entered in the app
    let DocumentsDirectory =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    lazy var ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")
        .appendingPathExtension("plist")
    
    // Saves data to disk
    func saveTasks(_ tasks: [ToDoList]) {
            let encoder = PropertyListEncoder()
            
            let codedTasks = try? encoder.encode(tasks)
            try? codedTasks?.write(to: self.ArchiveURL, options: .noFileProtection)
    }
    
}
