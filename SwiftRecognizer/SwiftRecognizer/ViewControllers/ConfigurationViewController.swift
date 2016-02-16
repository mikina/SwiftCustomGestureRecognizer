//
//  ConfigurationViewController.swift
//  SwiftRecognizer
//
//  Created by Mike Mikina on 2/14/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var items: [Gestures]?
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = NSLocalizedString("Configuration", comment: "Configuration")
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.setupData()
    self.tableView.reloadData()
  }
  
  func setupData() {
    if let data = Gestures.MR_findAll() as? [Gestures] {
      self.items = data
    }
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
    if let item = self.items {
      let gestureItem = item[indexPath.row]
      cell.textLabel?.text = gestureItem.name
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let items = self.items {
        return items.count
    }
    else {
        return 0
    }
  }
    
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    return .Delete
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      if var items = self.items {
        let gestureItem = items[indexPath.row]
        Gestures.deleteGesture(gestureItem)
        self.items!.removeAtIndex(indexPath.row)
        
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()
      }
    }    
  }
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "edit" {
      let destination = segue.destinationViewController as! ConfigurationDetailsViewController
      if let item = self.items {
        let senderA = sender as! UITableViewCell
        let index = self.tableView.indexPathForCell(senderA)
        let entity = item[(index?.row)!]
        destination.gestureEntity = entity
      }

    }
  }


}
