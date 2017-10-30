//
//  Installment.swift
//  MercadoPago
//
//  Created by Gaston Mazzeo on 10/26/17.
//  Copyright © 2017 Gmazzeo. All rights reserved.
//

import Foundation

class Installment {
    public private(set) var quantity: Int?
    public private(set) var message: String?
    
    init(quantity: Int, message: String) {
        self.quantity = quantity
        self.message = message
    }
}

