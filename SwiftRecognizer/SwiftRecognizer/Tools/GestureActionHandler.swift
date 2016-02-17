//
//  GestureActionHandler.swift
//  SwiftRecognizer
//
//  Created by Mike Mikina on 2/17/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import Foundation
import UIKit

class GestureActionHanlder {
  
  let googleURL = "https://google.com"
  let appleURL = "https://apple.com"
  var openCamera: ((picker: UIImagePickerController) -> ())?
  
  func handleAction(type: GestureType) {
    switch type {
      case .OpenApplePage:
        UIApplication.sharedApplication().openURL(NSURL(string: appleURL)!)
      break
      case .OpenGooglePage:
        UIApplication.sharedApplication().openURL(NSURL(string: googleURL)!)
      break
      case .OpenCamera:
        if UIImagePickerController.isSourceTypeAvailable(
          UIImagePickerControllerSourceType.Camera) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            
            if let camera = self.openCamera {
              camera(picker: imagePicker)
            }
        }
      break
      case .NoType:
      break
    }
  }
}