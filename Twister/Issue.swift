//
//  Issue.swift
//  Twister
//
//  Created by Isaac Eaton on 5/13/20.
//  Copyright © 2020 Isaac Eaton. All rights reserved.
//

import UIKit
import CoreData
import SwiftUI

class Issue: NSManagedObject, Identifiable {
    
    @NSManaged var id: Int16
    @NSManaged var version: Version
    @NSManaged var title: String
    @NSManaged var cover: UIImage
    @NSManaged var date: Date
    
    @NSManaged var webLocation: URL
    @NSManaged var fileLocation: URL?
    @NSManaged var fileType: String
    
}
