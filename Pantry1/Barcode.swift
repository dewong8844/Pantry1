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
    
    // MARK: Database Operations

    func saveToDB() {
        let pantryDB = FMDatabase(path: Pantry.databasePath as String)
        if (pantryDB?.open())! {
            let querySQL = "SELECT * FROM barcodes WHERE product_id = \(productId)"
            let results:FMResultSet? = pantryDB?.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                let updateSQL = "UPDATE barcodes SET value='\(self.barcode)', type='\(self.type)' WHERE product_id = '\(productId)'"
                let result = pantryDB?.executeUpdate(updateSQL, withArgumentsIn: nil)
                if !result! {
                    //print(Failed to update contact"),
                    print ("Error in update, \(pantryDB?.lastErrorMessage())")
                }
                else {
                    print(" Updated")
                }
            }
            else {
                let insertSQL = "INSERT INTO barcodes (product_id, type, value) VALUES (\(productId), '\(self.type)', '\(self.barcode)')"
                let result = pantryDB?.executeUpdate(insertSQL, withArgumentsIn: nil)
                if !result! {
                    print ("Error in insert, \(pantryDB?.lastErrorMessage())")
                }
                else {
                    print("Barcodes entry added")
                }
            }
            pantryDB?.close()
        }
        else {
            print("Error in saveToDB, open inventory DB failed")
        }
    }

    
    static func findProductIdByBarcode(value:String) -> Int {
        let pantryDB = FMDatabase(path: Pantry.databasePath as String)
        var productId: Int?
        
        if (pantryDB?.open())! {
            let querySQL = "SELECT * FROM barcodes WHERE value = '\(value)'"
            let results:FMResultSet? = pantryDB?.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                print("Record found")
                print(results?.resultDictionary() as Any)
                let id = (results?.string(forColumn: "product_id"))!
                productId = Int(id)
            }
            else {
                print ("Error \(pantryDB?.lastErrorMessage())")
                productId = 0
            }
            pantryDB?.close()
        }
        else {
            print ("Error \(pantryDB?.lastErrorMessage())")
        }
        
        return productId!
    }

    
    func removeFromDB() {
        let pantryDB = FMDatabase(path: Pantry.databasePath as String)
        if (pantryDB?.open())! {
            let deleteSQL = "DELETE FROM inventory WHERE product_id = \(self.productId)"
            let result = pantryDB?.executeUpdate(deleteSQL, withArgumentsIn: nil)
            if !result! {
                print ("Error \(pantryDB?.lastErrorMessage())")
            }
            else {
                print("Entry Deleted")
            }
            pantryDB?.close()
        }
        else {
            print ("Error \(pantryDB?.lastErrorMessage())")
        }
    }
    
    
    static func loadBarcodesFromDB() -> [Barcode]? {
        let pantryDB = FMDatabase(path: Pantry.databasePath as String)
        var barcodes = [Barcode]()
        
        if (pantryDB?.open())! {
            let querySQL = "SELECT * FROM barcodes"
            let results:FMResultSet? = pantryDB?.executeQuery(querySQL, withArgumentsIn: nil)
            if results != nil {
                print("Record found")
                while results?.next() == true {
                    print(results?.resultDictionary() as Any)
                    let productId = (results?.string(forColumn: "product_id"))!
                    let type = (results?.string(forColumn: "type"))!
                    let value = (results?.string(forColumn: "value"))!
                    let barcode = Barcode(barcode: value, type: type, productId: Int(productId)!)
                    barcodes += [barcode]
                }
            }
            else {
                print("Record not found")
                // barcodes = nil
            }
            pantryDB?.close()
        }
        else {
            print ("Error \(pantryDB?.lastErrorMessage())")
        }
        
        return barcodes
    }
    
    // TODO: cannot create just barcodes table,
    //       need to create products first, how to do this?
    static func createBarcodesDB() {
        let pantryDB = FMDatabase(path: Pantry.databasePath as String)
        if (pantryDB?.open())! {
            let sql_stmt = "CREATE TABLE IF NOT EXISTS Barcodes (barcode_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, product_id INTEGER REFERENCES Products(product_id), type NVARCHAR(20), value NVARCHAR(30) NOT NULL)"
            if !(pantryDB?.executeStatements(sql_stmt))! {
                print ("Error \(pantryDB?.lastErrorMessage())")
                // status.text = "Create barcodes table failed"
            }
            pantryDB?.close()
        }
        else {
            print ("Error \(pantryDB?.lastErrorMessage())")
        }
    }    

}
