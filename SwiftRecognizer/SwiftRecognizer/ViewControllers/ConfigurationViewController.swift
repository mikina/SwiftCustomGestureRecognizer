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
    return (items?.count)!
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
