//
//  CustomGestureRecognizer.swift
//  SwiftRecognizer
//
//  Created by Mike Mikina on 2/14/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class CustomGestureRecognizer: UIGestureRecognizer {
  var pathFinder: PathFinder?
  
  var touchedPoints = [CGPoint]()
  var path = CGPathCreateMutable()
  
  var lastPoint = CGPoint.zero
  var red: CGFloat = 0.0
  var green: CGFloat = 0.0
  var blue: CGFloat = 0.0
  var brushWidth: CGFloat = 5.0
  var opacity: CGFloat = 1.0
  var swiped = false
  var recognizedShape: GestureModel?
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesBegan(touches, withEvent: event)
    touchedPoints.removeAll()
    
    let window = view?.window
    if let loc = touches.first?.locationInView(window) {
      CGPathMoveToPoint(path, nil, loc.x, loc.y) // start the path
    }
    
    if touches.count != 1 {
      state = .Failed
    }
    
    state = .Began
    self.recognizedShape = nil
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesEnded(touches, withEvent: event)
    
    if let pathFinder = self.pathFinder {
      let points = pathFinder.getDirections(self.touchedPoints)
      self.recognizedShape = pathFinder.recognizeShape(points)
      if let _ = self.recognizedShape {
        state = .Ended
      }
      else {
        state = .Failed
      }
    }
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
    super.touchesMoved(touches, withEvent: event)
    
    if state == .Failed {
      return
    }
    
    let window = view?.window
    if let loc = touches.first?.locationInView(window) {
      touchedPoints.append(loc)
      CGPathAddLineToPoint(path, nil, loc.x, loc.y)
      state = .Changed
    }
  }
  
}
