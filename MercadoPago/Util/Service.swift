//
//  Service.swift
//  MercadoPago
//
//  Created by Gaston Mazzeo on 10/27/17.
//  Copyright © 2017 Gmazzeo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Service {
    
    static func executeGetRequest(baseURL: String, Uri: String,  parameters: [String : String], callback: @escaping (DataResponse<Any>) -> Void){
        DispatchQueue.global(qos: .background).async {
            Alamofire.request("\(baseURL)\(Uri)", method: .get, parameters: parameters).responseJSON(completionHandler: callback)
        }
    }
}
