//
//  ControllerQuestions.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 10/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit
import CoreData

protocol ControllerQuestionsDelegate {
    func dataLoadAndSaveCompleted()
    func showAlertEmptyData()
    func showAlertTimeOut()
    func showAlertNotConnectedToInternet()
}

class ControllerQuestions: NSObject,WebServiceReturnDelegate{
    let dataConverter:DataConverter = DataConverter()
    var delegate:ControllerQuestionsDelegate?
    
    var modelCategoryDataState:ModelCategoryDataState!
    let modelWebServiceCall:ModelWebServiceCall = ModelWebServiceCall()
    let modelEntityQuestions:ModelEntityQuestion = ModelEntityQuestion()
    let modelEntityAnswers:ModelEntityAnswer = ModelEntityAnswer()
    
    let stringTriviaAmount = "20"
    let stringTriviaType = "multiple"
    let stringTriviaDifficulity = "easy"
    
    let stringBaseURL = "https://opentdb.com/api.php?"
    
    var arrayQuestionsData:[[String:Any]]=[[:]]
    func constructDataQuestions(){
        if (self.getQuestionsDataByCategoryID().count <= 0){
            self.getQuestionsDataFromServer()
        }
        else{
            delegate?.dataLoadAndSaveCompleted()
        }
    }
    
    func getQuestionsDataByCategoryID()->[[String:Any]]{
        arrayQuestionsData = dataConverter.convertQuestionFromCoreDataManagedObjectToSwiftArray(coreDataObject: modelEntityQuestions.getQuestionDataByCategory(categoryID: self.getDataState()["categoryID"] as! Int))
        return arrayQuestionsData
    }
    
    func getAnswersDataByCategoryID(questionSelectedID:Int)->[[String:Any]]{
        return dataConverter.convertAnswersFromCoreDataManagedObjectToSwiftArray(coreDataObject: modelEntityAnswers.getAnswersDataByQuestion(questionID:questionSelectedID))
    }
    
    func getQuestionsDataFromServer (){
        let stringTriviaCategoryID = self.getDataState()["categoryID"]
        let stringURLAPI = "\(stringBaseURL)amount=\(stringTriviaAmount)&category=\(stringTriviaCategoryID ?? "")&difficulty=\(stringTriviaDifficulity)&type=\(stringTriviaType)"
        modelWebServiceCall.delegate = self
        modelWebServiceCall.callRESTAPI(stringAPIURL: stringURLAPI, stringHTTPMethod: modelWebServiceCall.httpGET)
    }
    
    func setDataStateModel(dataStateModel:ModelCategoryDataState){
        modelCategoryDataState = dataStateModel
    }
    
    func getDataState()->[String:Any]{
        return modelCategoryDataState.getDataState()
    }
    
    func saveQuestionAndAnswersTriviaToDatabase(dictDataQuestionAnswer:[String:Any]){
        let dictionaryData:[String:Any] = dictDataQuestionAnswer
        let stringCategoryID:Int = self.getDataState()["categoryID"] as! Int
        let arrayDataResult:[[String:Any]] = dictionaryData["results"] as! [[String:Any]]
    
        for (index, _) in arrayDataResult.enumerated(){
            let intMaxQuestionID:Int = self.modelEntityQuestions.fetchMaxQuestionID()
            var dictDataQuestions:[String:Any] = [:]
            var dictDataAnswer:[String:Any] = [:]
            let stringQuestion = arrayDataResult[index]["question"] as! String
            let stringCorrectAnswer = arrayDataResult[index]["correct_answer"] as! String
            let arrayDataIncorrectAnswer:[Any] = arrayDataResult[index]["incorrect_answers"] as! [Any]
            
            dictDataQuestions["categoryTriviaID"] = stringCategoryID
            dictDataQuestions["triviaQuestionText"] = dataConverter.decodeHTMLString(stringHTML: stringQuestion)
            dictDataQuestions["triviaQuestionCorrectAnswer"] = stringCorrectAnswer
            dictDataQuestions["triviaQuestionID"] = intMaxQuestionID
            //save question
            //print(stringQuestion)
            self.modelEntityQuestions.saveQuestionData(dictquestionData: dictDataQuestions)
            
            dictDataAnswer["answersTriviaText"] = dataConverter.decodeHTMLString(stringHTML: stringCorrectAnswer)
            dictDataAnswer["answersTriviaCorrectness"] = "Correct Answer"
            dictDataAnswer["questionTriviaID"] = intMaxQuestionID
            //savethecorrectanswer
            self.modelEntityAnswers.saveAnswerData(dictanswerData: dictDataAnswer)
            
            for (index, _) in arrayDataIncorrectAnswer.enumerated(){
                let stringInCorrectAnswer = arrayDataIncorrectAnswer[index]
                dictDataAnswer["answersTriviaText"] = dataConverter.decodeHTMLString(stringHTML: stringInCorrectAnswer as! String)
                dictDataAnswer["answersTriviaCorrectness"] = "Incorrect Answer"
                dictDataAnswer["questionTriviaID"] = intMaxQuestionID
                //save incorrect answer
                self.modelEntityAnswers.saveAnswerData(dictanswerData: dictDataAnswer)
            }
        }
        delegate?.dataLoadAndSaveCompleted()
    }
    
    func jsonData(_ dataFromServer:Any){
        let dictionaryData:[String:Any] = dataFromServer as! [String:Any]
        if (dictionaryData["response_code"] as! Int == 0){
            //implement cache invalidation
            modelEntityQuestions.deleteAllQuestionTriviaRecords()
            modelEntityAnswers.deleteAllAnswerTriviaRecords()
            
            self.saveQuestionAndAnswersTriviaToDatabase(dictDataQuestionAnswer: dictionaryData)
        }
        else{
            delegate?.showAlertEmptyData()
        }
    }
    
    func serverReachedTimeOut(){
        delegate?.showAlertTimeOut()
    }
    
    func deviceNotConnectedToInternet(){
        delegate?.showAlertNotConnectedToInternet()
    }
}
