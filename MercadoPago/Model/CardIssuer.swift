//
//  CardIssuer
//  MercadoPago
//
//  Created by Gaston Mazzeo on 10/26/17.
//  Copyright © 2017 Gmazzeo. All rights reserved.
//

import Foundation

class CardIssuer {
    public private(set) var id: String?
    public private(set) var name: String?
    public private(set) var image: String?
    
    init(id: String, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
}
