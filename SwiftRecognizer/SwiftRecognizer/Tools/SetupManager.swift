//
//  SetupManager.swift
//  SwiftRecognizer
//
//  Created by Mike Mikina on 2/14/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import Foundation
import MagicalRecord

class SetupManager {
  
  init() {
    self.initDB()
  }
  
  func initDB() {
    let bundleID = NSBundle.mainBundle().bundleIdentifier
    MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed(bundleID!)
  }
  
  
}