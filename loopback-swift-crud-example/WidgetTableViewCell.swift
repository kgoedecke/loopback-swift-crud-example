//
//  WidgetTableViewCell.swift
//  loopback-swift-crud-example
//
//  Created by Kevin Goedecke on 12/23/15.
//  Copyright © 2015 kevingoedecke. All rights reserved.
//

import UIKit

class WidgetTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
