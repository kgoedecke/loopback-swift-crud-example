//
//  LBController.swift
//  loopback-swift-crud-example
//
//  Created by Kevin Goedecke on 12/22/15.
//  Copyright © 2015 kevingoedecke. All rights reserved.
//

import Foundation


/// LoopBack Backend Delegate protocol. Defines methods that will be called when all results are retrieved from a remote LoopBack Backend
protocol LBControllerDelegate   {
    func didReceiveResultsFromRemote(results: [LBPersistedModel])
}

class LBController  {
    var delegate: LBControllerDelegate?
    var adapter: LBRESTAdapter
    
    init(delegate: LBControllerDelegate) {
        self.delegate = delegate
        self.adapter = (UIApplication.sharedApplication().delegate as! AppDelegate!).adapter
    }
    init()  {
        self.adapter = (UIApplication.sharedApplication().delegate as! AppDelegate!).adapter
    }
    
    /**
     Gets the models for a given repository and calls the didReceiveResultsFromRemote delegate method
     - Parameters:
        - repository: The repository to get the models from
    */
    func getModelsForRepository(repository: LBPersistedModelRepository)   {
        let repository = adapter.repositoryWithClass(repository.dynamicType) as! LBPersistedModelRepository
        repository.allWithSuccess({ (models: [AnyObject]!) -> Void in
            NSLog("Successfully received all Models for Repository Type")
            self.delegate!.didReceiveResultsFromRemote(models as! [LBPersistedModel])
            }) { (error: NSError!) -> Void in
                NSLog("Error retrieving Models for Repository Type.")
                NSLog(error.description)
        }
    }
    
    /**
     Gets the models for a given repository and calls the didReceiveResultsFromRemote delegate method
     - Parameters:
        - repository: The repository to get the models from
        - filter: A filter dictionary to apply when getting the models from the repository
    */
    func getModelsForRepository(repository: LBPersistedModelRepository, filter: Dictionary<String, Dictionary<String, String>>)    {
        let repository = adapter.repositoryWithClass(repository.dynamicType) as! LBPersistedModelRepository
        repository.findWithFilter(filter, success: { (models: [AnyObject]!) -> Void in
            NSLog("Successfully received all filtered Models for Repository Type")
            self.delegate!.didReceiveResultsFromRemote(models as! [LBPersistedModel])
            }) { (error: NSError!) -> Void in
                NSLog("Error retrieving Models with given Filter for Repository Type.")
                NSLog(error.description)
        }
    }
    
    /**
     Creates a LBPersistedModel for a given Repository type that is attached to an LBRESTAdapter
     - Parameters:
        - repositoryType: The Repository type that the model needs to be created for
        - dictionary: A dictionary that will be used as the parameters for the model
     - Returns: The model that is connected to the backend
    */
    func createModelForRepositoryType(repositoryType: LBPersistedModelRepository, dictionary: [NSObject : AnyObject]) -> LBPersistedModel   {
        let repository = adapter.repositoryWithClass(repositoryType.dynamicType) as! LBPersistedModelRepository
        let model = repository.modelWithDictionary(dictionary) as! LBPersistedModel
        model.saveWithSuccess({ () -> Void in
            NSLog("Successfully created new Model.")
            }) { (error: NSError!) -> Void in
                NSLog("Error saving new Model with given dictionary.")
                NSLog(error.description)
        }
        return model
    }

    /**
     Update a model with a given Repository Type
     - Parameters: 
        - model: The model that was changed and needs to updated remotely
        - repositoryType: The Repository Type of the Model that needs to be updated
    */
    func updateModelForRepositoryType(model: LBPersistedModel, repositoryType: LBPersistedModelRepository)  {
        let repository = adapter.repositoryWithClass(repositoryType.dynamicType) as! LBPersistedModelRepository
        repository.findById(model._id, success: { (existingModel: LBPersistedModel!) -> Void in
            existingModel.setValuesForKeysWithDictionary(model.toDictionary() as! Dictionary<String,AnyObject>)
            existingModel.saveWithSuccess({ () -> Void in
                NSLog("Successfully updated Model.")
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
     Removes a given Model for a Repository type
     - Parameters: 
        - model: The model that needs to be deleted
        - repositoryType: The Repository type belonging to the passed Model
    */
    func deleteModelForRepositoryType(model: LBPersistedModel, repositoryType: LBPersistedModelRepository)  {
        let repository = adapter.repositoryWithClass(repositoryType.dynamicType) as! LBPersistedModelRepository
        repository.findById(model._id, success: { (existingModel: LBPersistedModel!) -> Void in
            model.destroyWithSuccess({ () -> Void in
                NSLog("Successfully deleted Model.")
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
