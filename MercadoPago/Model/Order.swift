//
//  Order.swift
//  MercadoPago
//
//  Created by Gaston Mazzeo on 10/26/17.
//  Copyright © 2017 Gmazzeo. All rights reserved.
//

import Foundation

class Order {
    var amount: Int?
    var paymentMethod: PaymentMethod?
    var cardIssuer: CardIssuer?
    var installment: Installment?
    
    init() {
    }
    

}
