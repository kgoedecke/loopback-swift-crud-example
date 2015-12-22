//
//  LBController.swift
//  loopback-swift-crud-example
//
//  Created by Kevin Goedecke on 12/22/15.
//  Copyright © 2015 kevingoedecke. All rights reserved.
//

import Foundation

protocol LBControllerProtocol    {
    func didReceiveResultsFromRemote(results: [LBPersistedModel])
}

class LBController  {
    var delegate: LBControllerProtocol
    var adapter: LBRESTAdapter
    
    init (delegate: LBControllerProtocol) {
        self.delegate = delegate
        self.adapter = (UIApplication.sharedApplication().delegate as! AppDelegate!).adapter
    }
    
    /*!
    * @discussion Gets the models for a given repository and calls the didReceiveResultsFromRemote delegate method
    * @param The repository to get the models from
    * @warning Must be a subclass of LBPersistedModelRepository
    * @return
    */
    func getModelsForRepository(repository: LBPersistedModelRepository)   {
        let repository = adapter.repositoryWithClass(repository.dynamicType) as! LBPersistedModelRepository
        repository.allWithSuccess({ (models: [AnyObject]!) -> Void in
            NSLog("succ")
            self.delegate.didReceiveResultsFromRemote(models as! [LBPersistedModel])
            }) { (error: NSError!) -> Void in
                NSLog("error")
        }
    }
    /*!
    * @discussion Gets the models for a given repository and calls the didReceiveResultsFromRemote delegate method
    * @param The repository to get the models from
    * @param A filter dictionary to apply when getting the models from the repository
    * @return
    */
    func getModelsForRepository(repository: LBPersistedModelRepository, filter: Dictionary<String, Dictionary<String, String>>)    {
        let repository = adapter.repositoryWithClass(repository.dynamicType) as! LBPersistedModelRepository
        repository.findWithFilter(filter, success: { (models: [AnyObject]!) -> Void in
            NSLog("succ")
            self.delegate.didReceiveResultsFromRemote(models as! [LBPersistedModel])
            }) { (error: NSError!) -> Void in
                NSLog("error")
        }
    }
}
