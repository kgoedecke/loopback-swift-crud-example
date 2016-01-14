//
//  MyTableViewController.swift
//  loopback-swift-crud-example
//
//  Created by Kevin Goedecke on 12/22/15.
//  Copyright © 2015 kevingoedecke. All rights reserved.
//

import UIKit
import RealmSwift

class MyTableViewController: UITableViewController  {
    
    let realm = try! Realm()
    var widgetsLocal = [WidgetLocal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // We now load all data from the backend and override the realm data
        // In case the backend is not reachable we still have access to our local realm data
        AppDelegate.widgetRepository.allWithSuccess({ (fetchedWidgets: [AnyObject]!) -> Void in
            for widget in fetchedWidgets as! [Widget] {
                try! self.realm.write {
                    let newWidget = WidgetLocal(widget: widget)
                    self.realm.add(newWidget, update: true)
                    self.widgetsLocal.append(newWidget)
                }
            }
            self.tableView.reloadData()
            }, failure: { (error: NSError!) -> Void in
                NSLog(error.description)
                // In case backend is down refresh for realm data
                self.widgetsLocal = Array(self.realm.objects(WidgetLocal))
                self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            widgetsLocal[indexPath.row].widgetRemote.destroyWithSuccess({ () -> Void in
                try! self.realm.write {
                    self.realm.delete(self.widgetsLocal[indexPath.row])
                }
                self.widgetsLocal.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }, failure: { (error: NSError!) -> Void in
                    NSLog(error.description)
            })
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return widgetsLocal.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as! WidgetTableViewCell
        cell.nameLabel.text = widgetsLocal[indexPath.row].name
        cell.valueLabel.text = String(widgetsLocal[indexPath.row].bars)
        return cell
    }
    
    // MARK: - Edit and Add Widget Segue operations
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let widgetDetailViewController = segue.destinationViewController as! WidgetViewController
            if let selectedWidgetCell = sender as? WidgetTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedWidgetCell)!
                let selectedWidget = widgetsLocal[indexPath.row]
                widgetDetailViewController.widget = selectedWidget
            }
        }
        else if segue.identifier == "AddItem" {
            NSLog("Adding new widget")
        }
        
    }
    
    @IBAction func unwindToWidgetList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? WidgetViewController, widget = sourceViewController.widget {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                widgetsLocal[selectedIndexPath.row] = widget
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else    {
                let newIndexPath = NSIndexPath(forRow: widgetsLocal.count, inSection: 0)
                self.widgetsLocal.append(widget)
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
    }
}
