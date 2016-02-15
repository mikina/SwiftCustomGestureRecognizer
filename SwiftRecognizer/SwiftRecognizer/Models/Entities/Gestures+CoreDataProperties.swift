//
//  Gestures+CoreDataProperties.swift
//  SwiftRecognizer
//
//  Created by Mike Mikina on 2/15/16.
//  Copyright © 2016 FDT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Gestures {

    @NSManaged var name: String?
    @NSManaged var itemType: NSNumber?
    @NSManaged var image: NSData?
    @NSManaged var directions: NSObject?

}
