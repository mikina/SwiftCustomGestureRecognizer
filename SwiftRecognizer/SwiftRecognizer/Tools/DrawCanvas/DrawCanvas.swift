//
//  DrawCanvas.swift
//  SwiftRecognizer
//
//  Created by Mike Mikina on 2/15/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import UIKit

class DrawCanvas: UIView {

  @IBOutlet weak var imageView: UIImageView!
  var lastPoint = CGPoint.zero
  var red: CGFloat = 0.0
  var green: CGFloat = 0.0
  var blue: CGFloat = 0.0
  var brushWidth: CGFloat = 5.0
  var opacity: CGFloat = 1.0
  var swiped = false
  var touchedPoints = [CGPoint]()
  var directions = [Int]()
  var completeAction: (([Int], UIImage) -> ())?
  var customImage: UIImage?
  
  override func layoutSubviews() {
    if let imageView = self.imageView, let img = self.customImage {
      imageView.image = img
    }
  }
  
  func setupWithImage(image: UIImage) {
    self.customImage = image
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.swiped = false
    self.touchedPoints.removeAll()
    
    if let touch = touches.first {
      self.lastPoint = touch.locationInView(self)
    }
    
    self.imageView.image = nil
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    swiped = true
    if let touch = touches.first {
      let currentPoint = touch.locationInView(self)
      self.drawLineFrom(self.lastPoint, toPoint: currentPoint)
      touchedPoints.append(currentPoint)
      self.lastPoint = currentPoint
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let finder = PathFinder()
    self.directions = finder.getDirections(self.touchedPoints)
    
    if let complete = completeAction {
      if let img = self.imageView.image {
        complete(self.directions, img)
      }
    }
  }
  
  func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
    UIGraphicsBeginImageContext(self.frame.size)
    let context = UIGraphicsGetCurrentContext()
    imageView.image?.drawInRect(CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
    CGContextSetLineCap(context, .Round)
    CGContextSetLineWidth(context, brushWidth)
    CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
    CGContextSetBlendMode(context, .Normal)
    CGContextStrokePath(context)
    imageView.image = UIGraphicsGetImageFromCurrentImageContext()
    imageView.alpha = opacity
    UIGraphicsEndImageContext()
  }
}
