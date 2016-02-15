//
//  GestureModel.swift
//  SwiftRecognizer
//
//  Created by Mike Mikina on 2/14/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import Foundation

@objc enum GestureType: Int32 {
  case OpenGooglePage = 1
  case OpenCamera = 2
  case OpenApplePage = 3
  case NoType = 0
}

class GestureModel {
  let name: String
  let gestureType: GestureType
  let directions: [Int]
  
  init(name: String, directions: [Int], type: GestureType) {
    self.name = name
    self.directions = directions
    self.gestureType = type
  }
}