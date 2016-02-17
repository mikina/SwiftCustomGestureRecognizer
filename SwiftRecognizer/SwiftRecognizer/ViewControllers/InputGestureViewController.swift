//
//  InputGestureViewController.swift
//  SwiftRecognizer
//
//  Created by Mike Mikina on 2/14/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import UIKit

class InputGestureViewController: UIViewController {

  var gestureRecognizer: CustomGestureRecognizer?
  var drawCanvas: DrawCanvas?
  
  @IBOutlet weak var gestureDrawSpace: DrawCanvas!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = NSLocalizedString("Input gesture", comment: "Input gesture")
    setupView()
  }
  
  override func viewDidAppear(animated: Bool) {
    setupGesture()
  }

  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  func setupView() {
    self.drawCanvas = NSBundle.mainBundle().loadNibNamed("DrawCanvas", owner: self, options: nil)[0] as? DrawCanvas
    if let canvas = self.drawCanvas {
      self.gestureDrawSpace.addSubview(canvas)
    }
  }
  
  func setupGesture() {
    let finder = PathFinder()
    let gesturesModel = Gestures.getAllElementsAsGestureModel()
    for item in gesturesModel {
      finder.addModel(item)
    }
    
    self.gestureRecognizer = CustomGestureRecognizer(target: self, action: "recognized:")
    self.gestureRecognizer?.pathFinder = finder
    self.view.addGestureRecognizer(self.gestureRecognizer!)
  }
  
  func recognized(item: CustomGestureRecognizer) {
    if item.state == .Ended {
      if let recognized = item.recognizedShape {
        let handler = GestureActionHanlder()
        handler.openCamera = { [weak self] (picker: UIImagePickerController) in
          self?.presentViewController(picker, animated: true, completion: nil)
        }
        handler.handleAction(recognized.gestureType)
      }
    }
  }
}
