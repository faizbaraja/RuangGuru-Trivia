//
//  ModelEntityQuestion.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 10/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit
import CoreData
class ModelEntityQuestion: NSObject {
    let stringTableConstant = "QuestionsTrivia"
    func saveQuestionData(dictquestionData: [String:Any]) {
        var questionObject: [NSManagedObject] = []
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: stringTableConstant, in: managedContext)!
        
        let questionEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        questionEntity.setValue(dictquestionData["categoryTriviaID"], forKeyPath: "categoryTriviaID")
        questionEntity.setValue(dictquestionData["triviaQuestionCorrectAnswer"], forKeyPath: "triviaQuestionCorrectAnswer")
        questionEntity.setValue(dictquestionData["triviaQuestionID"], forKeyPath: "triviaQuestionID")
        questionEntity.setValue(dictquestionData["triviaQuestionText"], forKeyPath: "triviaQuestionText")
        
        // 4
        do {
            try managedContext.save()
            questionObject.append(questionEntity)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchMaxQuestionID()->Int {
        var intMaxQuestionID = 1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return intMaxQuestionID
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: stringTableConstant)
        
        fetchRequest.fetchLimit = 1
        let sortDescriptor = NSSortDescriptor(key: "triviaQuestionID", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let questions = try managedContext.fetch(fetchRequest)
            if (questions.count > 0) {
                let questionsResult = questions[0] as! NSManagedObject
                intMaxQuestionID = questionsResult.value(forKey: "triviaQuestionID") as! Int + 1
            }
        }
        catch _ {
        }
        return intMaxQuestionID
    }
    
    func deleteAllQuestionTriviaRecords() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: stringTableConstant)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch {
            print ("There was an error")
        }
    }

}
