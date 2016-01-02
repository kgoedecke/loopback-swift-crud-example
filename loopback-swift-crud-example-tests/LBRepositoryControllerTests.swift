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
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateModelToRepositoryType() {
        var widgets = [Widget]()
        let createDelgateExpectation = expectationWithDescription("Create Model Callback Expectation")
        let timestamp = String(NSDate().timeIntervalSince1970)

        testController.createModel(["name": timestamp]) { model in
            self.testController.getModels(["where" : ["name" : timestamp]]) { models in
                widgets = models as! [Widget]
                createDelgateExpectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(500) { error in XCTAssertNil(error, "Callback method not called") }
        
        XCTAssertEqual(widgets.count, 1)
    }
    
    func testGetAllModelsFromRemote()   {
        var widgets = [Widget]()
        let getAllDelgateExpectation = expectationWithDescription("Get All Models Callback Expectation")
        
        testController.getModels(success: {models in
            widgets = models as! [Widget]
            getAllDelgateExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(500) { error in XCTAssertNil(error, "Callback method not called") }
        
        XCTAssertNotNil(widgets)
        XCTAssertGreaterThan(widgets.count, 0)
        XCTAssertEqual("Foo", widgets[0].name)
        XCTAssertEqual(0, widgets[0].bars)
        XCTAssertNotNil(widgets[0]._id)
    }
    
    func testGetAllModelsWithFilter()   {
        var widgets = [Widget]()
        let getAllWithFilterDelgateExpectation = expectationWithDescription("Get All Models With Filter Callback Expectation")
        
        testController.getModels(["where": ["name": "Foo"]]) { models in
            widgets = models as! [Widget]
            getAllWithFilterDelgateExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(500) { error in XCTAssertNil(error, "Callback method not called") }
        
        XCTAssertNotNil(widgets)
        XCTAssertEqual(widgets.count, 1)
        XCTAssertEqual("Foo", widgets[0].name)
        XCTAssertEqual(0, widgets[0].bars)
    }
    
    func testDeleteModelForRepositoryType() {
        var widgets = [Widget]()
        let deleteDelgateExpectation = expectationWithDescription("Delete Model Callback Expectation")
        
        let timestamp = String(NSDate().timeIntervalSince1970)
        testController.createModel(["name": timestamp]) { model in
            self.testController.deleteModel(model as! Widget) {
                self.testController.getModels(["where" : ["name" : timestamp]]) { models in
                    widgets = models as! [Widget]
                    deleteDelgateExpectation.fulfill()
                }
            }
        }
        
        waitForExpectationsWithTimeout(500) { error in XCTAssertNil(error, "Callback method not called") }
        
        XCTAssertEqual(widgets.count, 0)
    }
}