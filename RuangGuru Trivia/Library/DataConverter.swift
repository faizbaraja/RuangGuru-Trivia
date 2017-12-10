//
//  DataConverter.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 09/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit
import CoreData

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

class DataConverter: NSObject {

    func convertCategoryFromCoreDataManagedObjectToSwiftArray(coreDataObject : [NSManagedObject])->[[String:Any]]{
        var arrayData = [[String:Any]]()
        for managedObject in coreDataObject {
            let indexData:Int = coreDataObject.index(of: managedObject)!
            var dictData:[String:Any] = [:]
            dictData["categoryImage"] = coreDataObject[indexData].value(forKey: "categoryImage")
            dictData["categoryIcon"] = coreDataObject[indexData].value(forKey: "categoryIcon")
            dictData["categoryText"] = coreDataObject[indexData].value(forKey: "categoryText")
            dictData["categoryID"] = coreDataObject[indexData].value(forKey: "categoryID")
            arrayData.append(dictData)
        }
        return arrayData
    }
    
    func convertQuestionFromCoreDataManagedObjectToSwiftArray(coreDataObject : [NSManagedObject])->[[String:Any]]{
        var arrayData = [[String:Any]]()
        for managedObject in coreDataObject {
            let indexData:Int = coreDataObject.index(of: managedObject)!
            var dictData:[String:Any] = [:]
            dictData["categoryTriviaID"] = coreDataObject[indexData].value(forKey: "categoryTriviaID")
            dictData["triviaQuestionCorrectAnswer"] = coreDataObject[indexData].value(forKey: "triviaQuestionCorrectAnswer")
            dictData["triviaQuestionID"] = coreDataObject[indexData].value(forKey: "triviaQuestionID")
            dictData["triviaQuestionText"] = coreDataObject[indexData].value(forKey: "triviaQuestionText")
            arrayData.append(dictData)
        }
        return arrayData
    }
    
    func convertAnswersFromCoreDataManagedObjectToSwiftArray(coreDataObject : [NSManagedObject])->[[String:Any]]{
        var arrayData = [[String:Any]]()
        for managedObject in coreDataObject {
            let indexData:Int = coreDataObject.index(of: managedObject)!
            var dictData:[String:Any] = [:]
            dictData["answersTriviaCorrectness"] = coreDataObject[indexData].value(forKey: "answersTriviaCorrectness")
            dictData["answersTriviaText"] = coreDataObject[indexData].value(forKey: "answersTriviaText")
            dictData["questionTriviaID"] = coreDataObject[indexData].value(forKey: "questionTriviaID")
            arrayData.append(dictData)
        }
        return arrayData
    }
    
    func decodeHTMLString(stringHTML:String)->String{
        return stringHTML.html2String
    }
}
