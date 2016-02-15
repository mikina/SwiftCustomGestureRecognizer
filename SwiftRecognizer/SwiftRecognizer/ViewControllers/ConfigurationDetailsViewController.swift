//
//  ConfigurationDetailsViewController.swift
//  SwiftRecognizer
//
//  Created by Mike Mikina on 2/15/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import UIKit

class ConfigurationDetailsViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var gestureTypeButton: UIButton!
  @IBOutlet weak var gestureName: UITextField!
  @IBOutlet weak var titleLabel: UILabel!
  var gestureType: GestureType = .NoType
  var gestureModel: GestureModel?
  var gestureEntity: Gestures?
  var drawCanvas: DrawCanvas?
  @IBOutlet weak var gestureDrawSpace: DrawCanvas!
  var directions = [Int]()
  var gestureImage: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
  }
  
  func setupView() {
    self.titleLabel.text = NSLocalizedString("Draw gesture", comment: "Draw gesture")
    self.gestureTypeButton .setTitle(NSLocalizedString("Choose action type", comment: ""), forState: .Normal)
    self.gestureName.placeholder = NSLocalizedString("Gesture name", comment: "Gesture name")
    
    self.drawCanvas = NSBundle.mainBundle().loadNibNamed("DrawCanvas", owner: self, options: nil)[0] as? DrawCanvas
    if let canvas = self.drawCanvas {
      self.gestureDrawSpace.addSubview(canvas)
      canvas.completeAction = { [weak self] (directions: [Int], gestureImage: UIImage) in
        self?.directions = directions
        self?.gestureImage = gestureImage
      }
      
      if let model = self.gestureEntity {
        if let name = model.name {
          self.title = name
          self.gestureName.text = name
        }
        
        if let type = model.itemType {
          _ = self.setupGestureType(GestureType(rawValue: type.intValue)!)
        }
        
        if let imgData = model.image {
          if let image = UIImage(data: imgData, scale: 1.0) {
            canvas.setupWithImage(image)
          }
        }
      }
      else {
        self.title = NSLocalizedString("New gesture", comment: "New gesture")
      }
    }
    
    
    

  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.gestureName.resignFirstResponder()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.gestureName.resignFirstResponder()
    return true
  }
  
  @IBAction func saveAction(sender: AnyObject) {
    print("gestureImage: \(self.gestureImage)");
    if saveItem() {
      self.navigationController?.popViewControllerAnimated(true)
    }
    else {
      let alert: UIAlertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("Error, please try again", comment: "Error, please try again"), preferredStyle: .Alert)
      let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
      alert.addAction(cancelAction)
      self.navigationController?.presentViewController(alert, animated: true, completion: nil)
    }
  }
  
  func saveItem() -> Bool {
    guard let img = self.gestureImage else {
      return false
    }
    
    guard let imgData = UIImagePNGRepresentation(img) else {
      return false
    }
    
    if let _ = Gestures.create(self.gestureName.text!, itemType: NSNumber(int: self.gestureType.rawValue), image: imgData, directions: self.directions) {
      return true
    }
    
    return false
  }
  
  @IBAction func chooseGestureType(sender: AnyObject) {
    let actionController: UIAlertController = UIAlertController(title: NSLocalizedString("Choose action type", comment: "Choose action type"), message: nil, preferredStyle: .ActionSheet)
    let googleAction: UIAlertAction = UIAlertAction(title: self.getTypeName(.OpenGooglePage), style: .Default, handler: { [weak self](UIAlertAction) -> Void in
      self?.setupGestureType(.OpenGooglePage)
    })
    
    let cameraAction: UIAlertAction = UIAlertAction(title: self.getTypeName(.OpenCamera), style: .Default, handler: { [weak self](UIAlertAction) -> Void in
      self?.setupGestureType(.OpenCamera)
    })
    let appleAction: UIAlertAction = UIAlertAction(title: self.getTypeName(.OpenApplePage), style: .Default, handler: { [weak self](UIAlertAction) -> Void in
      self?.setupGestureType(.OpenApplePage)
    })
    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    
    actionController.addAction(googleAction)
    actionController.addAction(cameraAction)
    actionController.addAction(appleAction)
    actionController.addAction(cancelAction)
    
    self.navigationController?.presentViewController(actionController, animated: true, completion: nil)
  }
  
  func setupGestureType(gestureType: GestureType) {
    self.gestureType = gestureType
    self.gestureTypeButton .setTitle(self.getTypeName(self.gestureType), forState: .Normal)
  }
  
  func getTypeName(type: GestureType) -> String {
    switch type {
      case .OpenGooglePage:
        return NSLocalizedString("Open Google page", comment: "Open Google page")
      case .OpenCamera:
        return NSLocalizedString("Open Camera", comment: "Open Camera")
      case .OpenApplePage:
        return NSLocalizedString("Open Apple page", comment: "Open Apple page")
      default:
        return ""
    }
  }

}
