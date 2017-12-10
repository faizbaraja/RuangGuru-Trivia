//
//  ModelCategoryDataState.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 10/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit

class ModelCategoryDataState: NSObject {
    var dictionaryDataState:[String:Any] = [:]
    func setCategoryDataState(dictionaryData:[String:Any]){
        dictionaryDataState = dictionaryData
    }
    
    func getDataState()->[String:Any]{
        return dictionaryDataState
    }

}
