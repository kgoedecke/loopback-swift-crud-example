//
//  WidgetLocal.swift
//  loopback-swift-crud-example
//
//  Created by Kevin Goedecke on 1/12/16.
//  Copyright © 2016 kevingoedecke. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class WidgetLocal: Object {
    
    var widgetRemote: Widget!
    
    dynamic var id = 0
    
    private dynamic var widgetName = ""
    private dynamic var widgetBars = 0
    private dynamic var widgetUpdated = NSDate.init()
    
    var name: String {
        get {
            return self.widgetName
        }
        set(newValue) {
            self.widgetName = newValue
            self.widgetRemote?.name = newValue
            self.updated = NSDate.init()
        }
    }
    var bars: Int {
        get {
            return self.widgetBars
        }
        set(newValue) {
            self.widgetBars = newValue
            self.widgetRemote?.bars = newValue
            self.updated = NSDate.init()
        }
    }
    
    private var updated: NSDate {
        get {
            return self.widgetUpdated
        }
        set(newValue) {
            self.widgetUpdated = newValue
            self.widgetRemote?.updated = newValue
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return ["widgetRemote", "name", "bars", "updated"]
    }
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required init() {
        super.init()
    }
    
    required override init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    init(widget: Widget) {
        super.init()
        self.widgetRemote = widget
        self.id = widget._id.integerValue
        self.name = widget.name
        self.bars = widget.bars.integerValue
    }
    
}
