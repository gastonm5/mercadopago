//
//  PaymentMethod.swift
//  MercadoPago
//
//  Created by Gaston Mazzeo on 10/26/17.
//  Copyright © 2017 Gmazzeo. All rights reserved.
//

import Foundation

class PaymentMethod {
    public private(set) var id: String?
    public private(set) var name: String?
    public private(set) var image: String?
    public private(set) var paymentTypeId: String?
    public private(set) var maxAllowedAmount: Int?
    
    init(id: String, name: String, image: String, paymentTypeId: String, maxAllowedAmount: Int) {
        self.id = id
        self.name = name
        self.image = image
        self.paymentTypeId = paymentTypeId
        self.maxAllowedAmount = maxAllowedAmount
    }
    
    
}
