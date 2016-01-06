//
//  MyTableViewController.swift
//  loopback-swift-crud-example
//
//  Created by Kevin Goedecke on 12/22/15.
//  Copyright © 2015 kevingoedecke. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController  {
    
    var widgets = [Widget]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        AppDelegate.widgetRepository.allWithSuccess({ (fetchedWidgets: [AnyObject]!) -> Void in
            self.widgets = fetchedWidgets as! [Widget]
            self.tableView.reloadData()
            }) { (error: NSError!) -> Void in
                NSLog(error.description)
        }
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
            widgets[indexPath.row].destroyWithSuccess({ () -> Void in
                self.widgets.removeAtIndex(indexPath.row)
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
        return widgets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as! WidgetTableViewCell
        cell.nameLabel.text = widgets[indexPath.row].name
        cell.valueLabel.text = String(widgets[indexPath.row].bars)
        return cell
    }
    
    // MARK: - Edit and Add Widget Segue operations
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let widgetDetailViewController = segue.destinationViewController as! WidgetViewController
            if let selectedWidgetCell = sender as? WidgetTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedWidgetCell)!
                let selectedWidget = widgets[indexPath.row]
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
                widgets[selectedIndexPath.row] = widget
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else    {
                let newIndexPath = NSIndexPath(forRow: widgets.count, inSection: 0)
                self.widgets.append(widget)
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
    }
}
