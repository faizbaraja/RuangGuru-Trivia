//
//  ModelEntityCategory.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 09/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit
import CoreData

class ModelEntityCategoryTrivia: NSObject {
    func saveCategoryData(dictContactData: [String:Any]) {
        var contactObject: [NSManagedObject] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "CategoryTrivia", in: managedContext)!
        
        let contactEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        contactEntity.setValue(dictContactData["categoryIcon"], forKeyPath: "categoryIcon")
        contactEntity.setValue(dictContactData["categoryImage"], forKeyPath: "categoryImage")
        contactEntity.setValue(dictContactData["categoryText"], forKeyPath: "categoryText")
        contactEntity.setValue(dictContactData["categoryID"], forKeyPath: "categoryID")
        
        // 4
        do {
            try managedContext.save()
            contactObject.append(contactEntity)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllCategoryTriviaRecords() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryTrivia")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func getAllCategoryTriviaData() -> [NSManagedObject]{
        var contactObject: [NSManagedObject] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return contactObject
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CategoryTrivia")
        
        //3
        do {
            contactObject = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return contactObject
        }
        return contactObject
    }
}
