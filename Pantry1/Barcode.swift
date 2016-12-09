//
//  Barcode.swift
//  Pantry1
//
//  Created by Dennis Wong on 12/8/16.
//  Copyright © 2016 Dennis Wong. All rights reserved.
//

import UIKit

class Barcode {
    // MARK: Properties
    var barcode: String = ""
    var type: String = ""
    var productId: Int = 0
    
    // MARK: Initialization
    
    init(barcode: String, type: String, productId: Int) {
        self.barcode = barcode
        self.type = type
        self.productId = productId
        
        // if barcode.isEmpty || productId == 0 {
        //    return nil
        //}
    }
    
}
