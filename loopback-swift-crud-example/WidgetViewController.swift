//
//  WidgetViewController.swift
//  loopback-swift-crud-example
//
//  Created by Kevin Goedecke on 12/23/15.
//  Copyright © 2015 kevingoedecke. All rights reserved.
//

import UIKit

class WidgetViewController: UIViewController   {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberValueSlider: UISlider!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        navigationController!.popViewControllerAnimated(true)
    }
    
    var widget: Widget?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            if let _ = widget {
                widget!.name = nameTextField.text ?? ""
                widget!.bars = Int(numberValueSlider.value)
                widget?.saveWithSuccess({ () -> Void in
                    NSLog("Successfully updated Widget")
                    }, failure: { (error: NSError!) -> Void in
                        NSLog(error.description)
                })
            }
            else    {
                if let name = nameTextField.text where name != "" {
                    widget = AppDelegate.widgetRepository.modelWithDictionary(nil) as? Widget
                    widget!.name = name
                    widget!.bars = Int(self.numberValueSlider.value)
                    widget?.saveWithSuccess({ () -> Void in
                        NSLog("Successfully created new Widget")
                        }, failure: { (error: NSError!) -> Void in
                            NSLog(error.description)
                    })
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let widget = widget  {
            nameTextField.text = widget.name
            numberValueSlider.value = widget.bars as Float
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
