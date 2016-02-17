//
//  PathFinder.swift
//  SwiftRecognizer
//
//  Created by Mike Mikina on 2/14/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import Foundation
import UIKit


class PathFinder {
  var dividers: Int = 8
  var dividerAngle: Double {
    return M_PI * 2.0 / Double(self.dividers)
  }
  var datasource: [GestureModel] = []
  
  func getDirections(points: [CGPoint]) -> [Int] {
    var result: [Int] = []
    
    if points.count < 2 {
      return []
    }
    
    for (key,_) in points.enumerate() {
      if key < points.count - 1 {
        var calculatedAngle: Double = self.calculateAngleForPoints(points[key], point2: points[key + 1])
        calculatedAngle = calculatedAngle >= 0 ? calculatedAngle : (2 * M_PI + calculatedAngle)
        if (calculatedAngle < self.dividerAngle / 2.0 || calculatedAngle > M_PI * 2.0 - self.dividerAngle){
          result.append(0)
        }
        else {
          let rounded:Int = Int(round(calculatedAngle / self.dividerAngle))
          result.append(rounded)
        }
      }
    }
    
    return result
  }
  
  func addModel(item: GestureModel) {
    self.datasource.append(item)
  }
  
  func calculateAngleForPoints(point1: CGPoint, point2: CGPoint) -> Double {
    let x:Double = Double(point2.x) - Double(point1.x)
    let y:Double = Double(point2.y) - Double(point1.y)
    return atan2(y, x)
  }
  
  func recognizeShape(input: [Int]) -> GestureModel? {
    var selected: GestureModel?
    var bestResult: Double = 0.0
    
    for item in self.datasource {
      let result = self.compareArrays(item.directions, b: input)
      if result >= bestResult {
        bestResult = result
        selected = item
      }
    }
    
    if bestResult >= 0.6 {
      return selected
    }
    
    return nil
  }
  
  func compareArrays(a: [Int], b: [Int]) -> Double {
    let normalizeA: [Int] = self.normalizeArray(a)
    let normalizeB: [Int] = self.normalizeArray(b)
    
    var longerArray: [Int]
    var compareArray: [Int]
    
    if normalizeA.count > normalizeB.count {
      longerArray = normalizeA
      compareArray = normalizeB
    }
    else {
      longerArray = normalizeB
      compareArray = normalizeA
    }
    
    var match = 0
    
    for (index, value) in compareArray.enumerate() {
      if value == longerArray[index] {
        match = match + 1
      }
    }
    
    let matched: Double = Double(match) / Double(longerArray.count)
    
    return matched
  }
  
  func normalizeArray(input: [Int]) -> [Int] {
    var lastOne: Int?
    var filter = [Int]()
    
    for number in input {
      if let last = lastOne {
        if number != last {
          lastOne = number
          filter.append(number)
        }
      }
      else {
        lastOne = number
        filter.append(number)
      }
    }
    
    return filter
  }
  
}