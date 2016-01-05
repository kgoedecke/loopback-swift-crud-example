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
    lazy var repositoryController = LBRepositoryController(repositoryType: WidgetRepository.self)
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            if let existingWidget = widget {
                existingWidget.name = nameTextField.text ?? ""
                existingWidget.bars = Int(numberValueSlider.value)
                repositoryController.updateModel(existingWidget)
            }
            else    {
                if let name = nameTextField.text where name != "" {
                    let newWidget = Widget()
                    newWidget.name = name
                    newWidget.bars = Int(numberValueSlider.value)
                    self.widget = newWidget
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
