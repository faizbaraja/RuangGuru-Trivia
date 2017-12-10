//
//  UIColorData.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 10/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit

class UIColorData: NSObject {
    
    class func getColorCorrectGreen()->UIColor{
        return UIColor(displayP3Red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    }
    
    class func getColorInCorrectRed()->UIColor{
        return UIColor(displayP3Red: 251.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
    }

}
