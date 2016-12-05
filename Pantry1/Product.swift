//
//  Product.swift
//  Pantry1
//
//  Created by Dennis Wong on 12/2/16.
//  Copyright © 2016 Dennis Wong. All rights reserved.
//

import UIKit

class Product {
    // MARK: Properties
    
    var brand: String = ""
    var name: String = ""
    var amount: Float = 0.0
    var unit: String = ""
    var ingredient: String = ""
    var category: String = ""
    var desc: String = ""
    var desc2: String = ""
    
    // MARK: Initialization
    
    init(brand: String, name: String, amount: Float, unit: String, ingredient: String, category: String) {
        self.brand = brand
        self.name = name
        self.amount = amount
        self.unit = unit
        self.ingredient = ingredient
        self.category = category
        
        //if brand.isEmpty || name.isEmpty {
        //    return nil
        //}
    }
}
