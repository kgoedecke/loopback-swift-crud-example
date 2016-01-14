//
//  WidgetViewController.swift
//  loopback-swift-crud-example
//
//  Created by Kevin Goedecke on 12/23/15.
//  Copyright © 2015 kevingoedecke. All rights reserved.
//

import UIKit
import RealmSwift

class WidgetViewController: UIViewController   {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberValueSlider: UISlider!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        navigationController!.popViewControllerAnimated(true)
    }
    
    var widget: WidgetLocal?
    let realm = try! Realm()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            if let _ = widget {
                try! realm.write {
                    widget!.name = nameTextField.text ?? ""
                    widget!.bars = Int(numberValueSlider.value)
                }
                widget?.widgetRemote?.saveWithSuccess({ () -> Void in
                    NSLog("Successfully updated Widget")
                    }, failure: { (error: NSError!) -> Void in
                        NSLog(error.description)
                })
            }
            else    {
                if let name = nameTextField.text where name != "" {
                    let widgetRemote = AppDelegate.widgetRepository.modelWithDictionary(nil) as! Widget
                    widgetRemote.name = name
                    widgetRemote.bars = Int(self.numberValueSlider.value)
                    widgetRemote.saveWithSuccess({ () -> Void in
                        self.widget = WidgetLocal(widget: widgetRemote)
                        try! self.realm.write {
                            self.realm.add(self.widget!, update: true)
                        }
                        }, failure: { (error: NSError!) -> Void in
                            NSLog(error.description)
                    })
                    // TODO: Solve issues when remote not reachable (Primary Key, Sync after Backend is back online)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let widget = widget  {
            nameTextField.text = widget.name
            numberValueSlider.value = Float(widget.bars)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
