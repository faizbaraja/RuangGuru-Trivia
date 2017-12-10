//
//  ModelWebServiceCall.swift
//  RuangGuru Trivia
//
//  Created by Faiz Umar Baraja on 10/12/2017.
//  Copyright © 2017 FaizBarajaApps. All rights reserved.
//

import UIKit
protocol WebServiceReturnDelegate {
    func jsonData(_ dataFromServer:Any)
    func serverReachedTimeOut()
}

class ModelWebServiceCall: NSObject,URLSessionDelegate {
    let httpGET = "GET"
    let httpPOST = "POST"
    
    var delegate:WebServiceReturnDelegate?
    func callRESTAPI(stringAPIURL:String, stringHTTPMethod:String){
        let urlAPI = URL(string:stringAPIURL)
        if let usableUrl = urlAPI {
            var request = URLRequest(url: usableUrl)
            request.httpMethod = stringHTTPMethod
            let urlConfig = URLSessionConfiguration.default
            urlConfig.timeoutIntervalForRequest = 10
            urlConfig.timeoutIntervalForResource = 10
            let sessionAPI = URLSession(configuration: urlConfig, delegate: self, delegateQueue: nil)
            _ = sessionAPI.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    DispatchQueue.main.async{
                        self.delegate?.serverReachedTimeOut()
                    }
                }
                else{
                    if let dataReturn = data {
                        if String(data: dataReturn, encoding: String.Encoding.utf8) != nil{
                            if let httpRes = response as? HTTPURLResponse {
                                //let stringResponseMessage = httpRes.description
                                if (httpRes.statusCode == 200){
                                    do {
                                        let jsonReturn = try JSONSerialization.jsonObject(with: dataReturn, options: [])
                                        DispatchQueue.main.async{
                                            self.delegate?.jsonData(jsonReturn as Any)
                                        }
                                    } catch {
                                        print("error")
                                    }
                                }
                                else{
                                    //error
                                    //parse the error message
                                }
                            }
                        }
                    }
                }
                }.resume()
        }
    }
}
