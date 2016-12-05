//
//  Inventory.swift
//  Pantry1
//
//  Created by Dennis Wong on 12/4/16.
//  Copyright © 2016 Dennis Wong. All rights reserved.
//

import UIKit

class Inventory {
    // MARK: Properties
    
    var brand: String = ""
    var name: String = ""
    var amount: Float = 0.0
    var location: String = ""
    var quantity: Int
    
    // MARK: Initialization
    
    init?(brand: String, name: String, amount: Float, location: String, quantity: Int) {
        self.brand = brand
        self.name = name
        self.amount = amount
        self.location = location
        self.quantity = quantity
        
        if brand.isEmpty || name.isEmpty {
            return nil
        }
    }
    
}
