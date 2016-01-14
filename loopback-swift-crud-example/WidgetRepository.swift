//
//  WidgetRepository.swift
//  loopback-swift-crud-example
//
//  Created by Kevin Goedecke on 12/22/15.
//  Copyright © 2015 kevingoedecke. All rights reserved.
//

import Foundation
import LoopBack

class WidgetRepository : LBPersistedModelRepository     {
    override init() {
        super.init(className: "widgets")
    }
    class func repository() -> WidgetRepository {
        return WidgetRepository()
    }
    
}

