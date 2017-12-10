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
    func saveCategoryData(dictCategoryData: [String:Any]) {
        var categoryObject: [NSManagedObject] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "CategoryTrivia", in: managedContext)!
        
        let categoryEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        categoryEntity.setValue(dictCategoryData["categoryIcon"], forKeyPath: "categoryIcon")
        categoryEntity.setValue(dictCategoryData["categoryImage"], forKeyPath: "categoryImage")
        categoryEntity.setValue(dictCategoryData["categoryText"], forKeyPath: "categoryText")
        categoryEntity.setValue(dictCategoryData["categoryID"], forKeyPath: "categoryID")
        
        // 4
        do {
            try managedContext.save()
            categoryObject.append(categoryEntity)
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
        var categoryObject: [NSManagedObject] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return categoryObject
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CategoryTrivia")
        
        //3
        do {
            categoryObject = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return categoryObject
        }
        return categoryObject
    }
}
