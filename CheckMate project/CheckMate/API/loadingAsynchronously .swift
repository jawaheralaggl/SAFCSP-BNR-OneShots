//
//  loadingAsynchronously .swift
//  CheckMate
//
//  Created by Jawaher Alagel on 11/16/20.
//

import UIKit

class loadingAsynchronously: Operation {
    
    // MARK: - Data persistance (Gold Challenge)

    // Saving data entered in the app
    let DocumentsDirectory =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    lazy var ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")
        .appendingPathExtension("plist")
    
    // Loads the saved data from disk
    func loadTasks() -> [ToDoList]?  {
        guard let codedTasks = try? Data(contentsOf: ArchiveURL) else { return nil }
        
        let decoder = PropertyListDecoder()
        return try? decoder.decode([ToDoList].self, from: codedTasks)
    }
    
}
