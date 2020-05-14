//
//  Issue.swift
//  Twister
//
//  Created by Isaac Eaton on 5/13/20.
//  Copyright © 2020 Isaac Eaton. All rights reserved.
//

import UIKit
import CoreData

class Issue: NSManagedObject {
    
    @NSManaged var uniqueID: Int16
    @NSManaged var version: Version
    @NSManaged var title: String
    @NSManaged var cover: UIImage
    @NSManaged var date: Date
    
    @NSManaged var webLocation: URL
    @NSManaged var fileLocation: String?
    @NSManaged var fileType: String
    
    func quickset(id: Int16, title: String, cover: UIImage, date: Date, webLocation: URL, fileLocation: String?, fileType: String) {
        self.uniqueID = id
        self.title = title
        self.cover = cover
        self.date = date
        self.webLocation = webLocation
        self.fileLocation = fileLocation
        self.fileType = fileType
    }
    
}
