//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Jawaher Alagel on 11/29/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var dateTaken: Date?
    @NSManaged public var photoID: String?
    @NSManaged public var remoteURL: URL?
    @NSManaged public var title: String?
    @NSManaged public var numberOfViews: Int16

}

extension Photo : Identifiable {

}
