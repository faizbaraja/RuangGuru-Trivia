//
//  ControllerMainMenu.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 09/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit
import CoreData

class ControllerMainMenu: NSObject {
    let modelEntityCategoryTrivia:ModelEntityCategoryTrivia = ModelEntityCategoryTrivia()
    let modelCategoryDataState:ModelCategoryDataState = ModelCategoryDataState()
    let dataConverter:DataConverter = DataConverter()
    
    func createCategoryAndSaveToDB(){
        if (self.getAllCategoryData().count <= 0){
            let categoryImage:[String] = ["GeneralKnowledgeMask","EntertainmentBooksMask","EntertainmentFilmMask","EntertainmentMusicMask","EntertainmentGamesMask","EntertainmentTVMask","ScienceComputersMask","CelebritiesMask","HistoryMask","AnimalMask"]
            let categoryIcon:[String] = ["GeneralKnowledgeIcon","EntertainmentBooksIcon","EntertainmentFilmIcon","EntertainmentMusicIcon","EntertainmentGamesIcon","EntertainmentTVIcon","ScienceComputersIcon","CelebritiesIcon","HistoryIcon","AnimalIcon"]
            let categoryText:[String] = ["General Knowledge","Entertainment: Books","Entertainment: Film","Entertainment: Music","Entertainment: Games","Entertainment: TV","Science: Computers","Celebrities","History","Animal"]
            let categoryID:[Int] = [9,10,11,12,15,14,18,26,23,27]
            for stringCategoryText in categoryText{
                let indexPosition:Int  = categoryText.index(of: stringCategoryText)!
                var dictDataCategory:[String:Any] = [:]
                print(categoryImage[indexPosition])
                dictDataCategory["categoryImage"] = categoryImage[indexPosition] as String
                dictDataCategory["categoryIcon"] = categoryIcon[indexPosition] as String
                dictDataCategory["categoryText"] = categoryText[indexPosition] as String
                dictDataCategory["categoryID"] = categoryID[indexPosition] as Int
                
                modelEntityCategoryTrivia.saveCategoryData(dictCategoryData: dictDataCategory)
            }            
        }
    }
    
    func getAllCategoryData() -> [NSManagedObject] {
        return modelEntityCategoryTrivia.getAllCategoryTriviaData()
    }
    
    func getAllCategoryDataAsArray() -> [[String:Any]] {
        return dataConverter.convertCategoryFromCoreDataManagedObjectToSwiftArray(coreDataObject: modelEntityCategoryTrivia.getAllCategoryTriviaData())
    }
    
    func setCategoryDataState(dictionaryData:[String:Any]){
        modelCategoryDataState.setCategoryDataState(dictionaryData: dictionaryData)
    }
    
    func getDataState()->[String:Any]{
        return modelCategoryDataState.getDataState()
    }
    
    func getDataStateModel()->ModelCategoryDataState{
        return modelCategoryDataState
    }
    
}
