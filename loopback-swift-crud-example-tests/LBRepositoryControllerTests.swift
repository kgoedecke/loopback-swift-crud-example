//
//  LBControllerTests.swift
//  loopback-swift-crud-example
//
//  Created by Kevin Goedecke on 12/25/15.
//  Copyright © 2015 kevingoedecke. All rights reserved.
//

import XCTest
@testable import loopback_swift_crud_example

class LBRepositoryControllerTests: XCTestCase {
    lazy var testController : LBRepositoryController = LBRepositoryController(repositoryType: WidgetRepository.self)
    
    var widgets = [Widget]()
    
    var createDelgateExpectation:XCTestExpectation?
    var deleteDelgateExpectation:XCTestExpectation?
    var getAllDelgateExpectation:XCTestExpectation?
    var getAllWithFilterDelgateExpectation:XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateModelToRepositoryType() {
        self.widgets = [Widget]()
        
        createDelgateExpectation = expectationWithDescription("Create Model Callback Expectation")
        let timestamp = String(NSDate().timeIntervalSince1970)
        
        var testWidget: Widget = Widget()
        testController.createModel(["name": timestamp], success: { model in
            testWidget = model as! Widget
            self.testController.getModels(["where" : ["name" : timestamp]], success: {models in
                self.widgets = models as! [Widget]
                self.createDelgateExpectation?.fulfill()
            })
        })
        
        waitForExpectationsWithTimeout(500, handler: { error in XCTAssertNil(error, "Callback method not called")})
        
        XCTAssertEqual(widgets.count, 1)
    }
    
    func testGetAllModelsFromRemote()   {
        self.widgets = [Widget]()
        
        getAllDelgateExpectation = expectationWithDescription("Get All Models Callback Expectation")
        
        testController.getModels(success: {models in
            self.widgets = models as! [Widget]
            self.getAllDelgateExpectation?.fulfill()
        })
        
        waitForExpectationsWithTimeout(500, handler: { error in XCTAssertNil(error, "Callback method not called")
        })
        
        XCTAssertNotNil(self.widgets)
        XCTAssertGreaterThan(self.widgets.count, 0)
        XCTAssertEqual("Foo", self.widgets[0].name)
        XCTAssertEqual(0, self.widgets[0].bars)
        XCTAssertNotNil(self.widgets[0]._id)
    }
    
    func testGetAllModelsWithFilter()   {
        self.widgets = [Widget]()
        
        getAllWithFilterDelgateExpectation = expectationWithDescription("Get All Models With Filter Callback Expectation")
        
        testController.getModels(["where": ["name": "Foo"]], success: {models in
            self.widgets = models as! [Widget]
            self.getAllWithFilterDelgateExpectation?.fulfill()
        })
        
        waitForExpectationsWithTimeout(500, handler: { error in XCTAssertNil(error, "Callback method not called")
        })
        
        XCTAssertNotNil(self.widgets)
        XCTAssertEqual(self.widgets.count, 1)
        XCTAssertEqual("Foo", self.widgets[0].name)
        XCTAssertEqual(0, self.widgets[0].bars)
    }
    
    func testDeleteModelForRepositoryType() {
        self.widgets = [Widget]()
        
        deleteDelgateExpectation = expectationWithDescription("Delete Model Callback Expectation")
        
        let timestamp = String(NSDate().timeIntervalSince1970)
        testController.createModel(["name": timestamp], success: {model in
            self.testController.deleteModel(model as! Widget, success: {
                self.testController.getModels(["where" : ["name" : timestamp]], success: {models in
                    self.widgets = models as! [Widget]
                    self.deleteDelgateExpectation?.fulfill()
                })
            })
        })
        
        waitForExpectationsWithTimeout(500, handler: { error in XCTAssertNil(error, "Callback method not called")})
        
        XCTAssertEqual(widgets.count, 0)
    }
}