//
//  ControllerQuestions.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 10/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit

class ControllerQuestions: NSObject,WebServiceReturnDelegate{
    var modelCategoryDataState:ModelCategoryDataState!
    let modelWebServiceCall:ModelWebServiceCall = ModelWebServiceCall()
    let modelEntityQuestions:ModelEntityQuestion = ModelEntityQuestion()
    let modelEntityAnswers:ModelEntityAnswer = ModelEntityAnswer()
    
    let stringTriviaAmount = "20"
    let stringTriviaType = "multiple"
    let stringTriviaDifficulity = "easy"
    
    let stringBaseURL = "https://opentdb.com/api.php?"
    
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
        
            let intMaxQuestionID:Int = self.modelEntityQuestions.fetchMaxQuestionID()
            for (index, _) in arrayDataResult.enumerated(){
                var dictDataQuestions:[String:Any] = [:]
                var dictDataAnswer:[String:Any] = [:]
                let stringQuestion = arrayDataResult[index]["question"] as! String
                let stringCorrectAnswer = arrayDataResult[index]["correct_answer"] as! String
                let arrayDataIncorrectAnswer:[Any] = arrayDataResult[index]["incorrect_answers"] as! [Any]
                
                dictDataQuestions["categoryTriviaID"] = stringCategoryID
                dictDataQuestions["triviaQuestionText"] = stringQuestion
                dictDataQuestions["triviaQuestionCorrectAnswer"] = stringCorrectAnswer
                dictDataQuestions["triviaQuestionID"] = intMaxQuestionID
                //save question
                //print(stringQuestion)
                self.modelEntityQuestions.saveQuestionData(dictquestionData: dictDataQuestions)
                
                dictDataAnswer["answersTriviaText"] = stringCorrectAnswer
                dictDataAnswer["answersTriviaCorrectness"] = "Correct Answer"
                dictDataAnswer["questionTriviaID"] = intMaxQuestionID
                //savethecorrectanswer
                self.modelEntityAnswers.saveAnswerData(dictanswerData: dictDataAnswer)
                
                for (index, _) in arrayDataIncorrectAnswer.enumerated(){
                    let stringInCorrectAnswer = arrayDataIncorrectAnswer[index]
                    dictDataAnswer["answersTriviaText"] = stringInCorrectAnswer
                    dictDataAnswer["answersTriviaCorrectness"] = "Incorrect Answer"
                    dictDataAnswer["questionTriviaID"] = intMaxQuestionID
                    //save incorrect answer
                }
            }
        
    }
    
    func jsonData(_ dataFromServer:Any){
        let dictionaryData:[String:Any] = dataFromServer as! [String:Any]
        if (dictionaryData["response_code"] as! Int == 0){
            self.saveQuestionAndAnswersTriviaToDatabase(dictDataQuestionAnswer: dictionaryData)
        }
    }
}
