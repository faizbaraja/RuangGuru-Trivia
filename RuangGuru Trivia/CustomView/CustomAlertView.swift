//
//  CustomAlertView.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 10/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit

class CustomAlertView: NSObject {

    func createAlertViewWithoutButton(stringTitle:String,stringMessage:String)->UIAlertController{
        let alertController = UIAlertController(title: stringTitle, message: stringMessage, preferredStyle: .alert)
        return alertController
    }
    
    func createAlertWithDismissButton(stringTitle:String,stringMessage:String,stringButtonTitle:String)->UIAlertController{
        let alertController = UIAlertController(title: stringTitle, message: stringMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: stringButtonTitle, style: .cancel, handler:{(alert: UIAlertAction!) in alertController.dismiss(animated: true, completion: nil)})
        alertController.addAction(alertAction)
        return alertController
    }
}
