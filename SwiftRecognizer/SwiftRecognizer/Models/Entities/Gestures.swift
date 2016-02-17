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
  
  class func update(item: Gestures, name: String, itemType: NSNumber, image: NSData, directions: NSObject) -> Gestures? {
    item.name = name
    item.itemType = itemType
    item.image = image
    item.directions = directions
    
    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    return item;
  }
  
  class func deleteGesture(item: Gestures) {
    item.MR_deleteEntityInContext(NSManagedObjectContext.MR_defaultContext())
  }
  
  class func getAllElementsAsGestureModel() -> [GestureModel] {
    var model: [GestureModel] = []
    
    if let data = Gestures.MR_findAll() as? [Gestures] {
      for item in data {
        if let name = item.name, directions = item.directions, itemType = item.itemType {
          let type = GestureType(rawValue: itemType.intValue)!
          let gesture: GestureModel = GestureModel(name: name, directions: directions as! [Int], type: type)
          model.append(gesture)
        }
      }
    }
    
    return model
  }
}
