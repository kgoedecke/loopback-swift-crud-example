//
//  LBController.swift
//  loopback-swift-crud-example
//
//  Created by Kevin Goedecke on 12/22/15.
//  Copyright © 2015 kevingoedecke. All rights reserved.
//

import Foundation

class LBRepositoryController  {
    var adapter: LBRESTAdapter
    var repository: LBPersistedModelRepository

    /**
     Initializes for a given Repository type
     - Parameters:
     - repositoryType: The Repository type that the model needs to be created for
     */
    init<T: LBPersistedModelRepository>(repositoryType: T.Type)  {
        self.adapter = (UIApplication.sharedApplication().delegate as! AppDelegate!).adapter
        self.repository = adapter.repositoryWithClass(repositoryType) as! LBPersistedModelRepository
    }
    
    /**
     Gets the models for a given repository and calls the didReceiveResultsFromRemote delegate method
     - Parameters:
     - success: A block to be executed upon success
     */
    func getModels(success succeed: [LBPersistedModel] -> ())   {
        self.repository.allWithSuccess({ (models: [AnyObject]!) -> Void in
            NSLog("Successfully received all Models for Repository Type")
            succeed(models as! [LBPersistedModel])
            }) { (error: NSError!) -> Void in
                NSLog("Error retrieving Models for Repository Type.")
                NSLog(error.description)
        }
    }
    
    /**
     Gets the models for a given repository and calls the didReceiveResultsFromRemote delegate method
     - Parameters:
     - filter: A filter dictionary to apply when getting the models from the repository ["where": ["name" : "Foo"]]
     - success: A block to be executed upon success
     */
    func getModels(filter: Dictionary<String, Dictionary<String, String>>, success succeed: [LBPersistedModel] -> ())    {
        self.repository.findWithFilter(filter, success: { (models: [AnyObject]!) -> Void in
            NSLog("Successfully received all filtered Models for Repository Type")
            succeed(models as! [LBPersistedModel])
            }) { (error: NSError!) -> Void in
                NSLog("Error retrieving Models with given Filter for Repository Type.")
                NSLog(error.description)
        }
    }
    
    /**
     Creates a LBPersistedModel for a given Repository type that is attached to an LBRESTAdapter
     - Parameters:
     - dictionary: A dictionary that will be used as the parameters for the model
     - success: A block to be executed upon success
     - Returns: The model that is connected to the backend
     */
    func createModel(dictionary: [NSObject : AnyObject], success succeed: LBPersistedModel -> () = { model in })   {
        let model = self.repository.modelWithDictionary(dictionary) as! LBPersistedModel
        model.saveWithSuccess({ () -> Void in
            NSLog("Successfully created new Model.")
            succeed(model)
            }) { (error: NSError!) -> Void in
                NSLog("Error saving new Model with given dictionary.")
                NSLog(error.description)
        }
    }
    
    /**
     Update a model
     - Parameters:
     - model: The model that was changed and needs to updated remotely
     - success: A block to be executed upon success
     */
    func updateModel<ModelType: LBPersistedModel>(model: ModelType, success succeed: LBPersistedModel -> () = { model in })  {
        self.repository.findById(model._id, success: { (existingModel) -> Void in
            existingModel.setValuesForKeysWithDictionary(model.toDictionary() as! Dictionary<String,AnyObject>)
            existingModel.saveWithSuccess({ () -> Void in
                NSLog("Successfully updated Model.")
                succeed(existingModel)
                }, failure: { (error: NSError!) -> Void in
                    NSLog("Error updating Model.")
                    NSLog(error.description)
            })
            }) { (error: NSError!) -> Void in
                NSLog("Error finding Model with ID.")
                NSLog(error.description)
        }
    }
    
    /**
     Removes a given Model from its repository
     - Parameters:
     - model: The model that needs to be deleted
     - success: A block to be executed upon success
     */
    func deleteModel<ModelType: LBPersistedModel>(model: ModelType, success succeed: () -> () = {})  {
        self.repository.findById(model._id, success: { (existingModel) -> Void in
            model.destroyWithSuccess({ () -> Void in
                NSLog("Successfully deleted Model.")
                succeed()
                }, failure: { (error: NSError!) -> Void in
                    NSLog("Error deleting Model.")
                    NSLog(error.description)
            })
            }) { (error: NSError!) -> Void in
                NSLog("Error finding Model with ID.")
                NSLog(error.description)
        }
    }
}
