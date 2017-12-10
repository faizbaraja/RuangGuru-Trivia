//
//  ModelEntityAnswer.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 10/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit
import CoreData
class ModelEntityAnswer: NSObject {
    func saveAnswerData(dictanswerData: [String:Any]) {
        var answerObject: [NSManagedObject] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "AnswersTrivia", in: managedContext)!
        
        let answerEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        answerEntity.setValue(dictanswerData["answersTriviaCorrectness"], forKeyPath: "answersTriviaCorrectness")
        answerEntity.setValue(dictanswerData["answersTriviaText"], forKeyPath: "answersTriviaText")
        answerEntity.setValue(dictanswerData["questionTriviaID"], forKeyPath: "questionTriviaID")
        
        // 4
        do {
            try managedContext.save()
            answerObject.append(answerEntity)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllAnswerTriviaRecords() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AnswersTrivia")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch {
            print ("There was an error")
        }
    }

}
