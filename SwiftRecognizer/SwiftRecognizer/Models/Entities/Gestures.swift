//
//  Gestures.swift
//  SwiftRecognizer
//
//  Created by Mike Mikina on 2/15/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import Foundation
import CoreData

@objc(Gestures)
class Gestures: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
  class func create(name: String, itemType: NSNumber, image: NSData, directions: NSObject) -> Gestures? {
    if let item = Gestures.MR_createEntity() {
      item.name = name
      item.itemType = itemType
      item.image = image
      item.directions = directions
      
      NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
      return item;
    }
    else {
      return nil
    }
  }
  
}
