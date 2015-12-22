//
//  MyTableViewController.swift
//  loopback-swift-crud-example
//
//  Created by Kevin Goedecke on 12/22/15.
//  Copyright © 2015 kevingoedecke. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController, LBControllerProtocol {
    lazy var lbController : LBController = LBController(delegate: self)
    
    func didReceiveResultsFromRemote(results: [LBPersistedModel])  {
        let testWidget = results[1] as! Widget
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let widgetRepo: WidgetRepository = WidgetRepository()
        lbController.getModelsForRepository(widgetRepo)
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        return cell
    }
}
