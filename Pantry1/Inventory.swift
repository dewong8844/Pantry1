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
    
    init(brand: String, name: String, amount: Float, location: String, quantity: Int) {
        self.brand = brand
        self.name = name
        self.amount = amount
        self.location = location
        self.quantity = quantity
        
        // if brand.isEmpty || name.isEmpty {
        //    return nil
        //}
    }

    // MARK: Database Operations
    
    func saveToDB() {
        let productId = Product.findProductIdByName(brand: brand, name: name, amount: amount)
        let pantryDB = FMDatabase(path: Pantry.databasePath as String)
        if (pantryDB?.open())! {
            let querySQL = "SELECT * FROM inventory WHERE product_id = \(productId)"
            let results:FMResultSet? = pantryDB?.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                let updateSQL = "UPDATE inventory SET quantity='\(self.quantity)', location='\(self.location)' WHERE product_id = '\(productId)'"
                let result = pantryDB?.executeUpdate(updateSQL, withArgumentsIn: nil)
                if !result! {
                    //print(Failed to update contact"),
                    print ("Error in update, \(pantryDB?.lastErrorMessage())")
                }
                else {
                    print("Inventory Updated")
                }
            }
            else {
                let insertSQL = "INSERT INTO inventory (product_id, quantity, location) VALUES (\(productId), '\(self.quantity)', '\(self.location)')"
                let result = pantryDB?.executeUpdate(insertSQL, withArgumentsIn: nil)
                if !result! {
                    print ("Error in insert, \(pantryDB?.lastErrorMessage())")
                }
                else {
                    print("Inventory entry added")
                }
            }
            pantryDB?.close()
        }
        else {
            print("Error in saveToDB, open inventory DB failed")
        }
    }
    
        
    func removeFromDB() {
        let productId = Product.findProductIdByName(brand: brand, name: name, amount: amount)
        let pantryDB = FMDatabase(path: Pantry.databasePath as String)
        if (pantryDB?.open())! {
            let deleteSQL = "DELETE FROM inventory WHERE product_id = \(productId)"
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
    
    
    static func loadInventoryFromDB() -> [Inventory]? {
        let pantryDB = FMDatabase(path: Pantry.databasePath as String)
        var inventoryList = [Inventory]()
        
        if (pantryDB?.open())! {
            let querySQL = "SELECT * FROM inventory"
            let results:FMResultSet? = pantryDB?.executeQuery(querySQL, withArgumentsIn: nil)
            if results != nil {
                print("Record found")
                while results?.next() == true {
                    print(results?.resultDictionary() as Any)
                    let productId = (results?.string(forColumn: "product_id"))!
                    let product = Product.findProductById(id: Int(productId)!)
                    if product != nil {
                        let brand = product?.brand
                        let name = product?.name
                        let amount = product?.amount
                        let location = (results?.string(forColumn: "location"))!
                        let quantity = (results?.string(forColumn: "quantity"))!
                        let inventory = Inventory(brand: brand!, name: name!, amount: Float(amount!), location: location, quantity: Int(quantity)!)
                        inventoryList += [inventory]

                    }
                    else {
                        print("Record not found")
                        // inventoryList = nil
                    }
                }
            }
            else {
                print("Record not found")
                // inventoryList = nil
            }
            pantryDB?.close()
        }
        else {
            print ("Error \(pantryDB?.lastErrorMessage())")
        }
        
        return inventoryList
    }
    
    // TODO: cannot create just products table,
    //       need to create ingredients and categories first, how to do this?
    static func createInventoryDB() {
        let pantryDB = FMDatabase(path: Pantry.databasePath as String)
        if (pantryDB?.open())! {
            let sql_stmt = "CREATE TABLE IF NOT EXISTS Inventory (inventory_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,  product_id INTEGER REFERENCES Product(product_id), location NVARCHAR(100) REFERENCES Location(location_id), quantity INTEGER NOT NULL, expiration_date TEXT"
            if !(pantryDB?.executeStatements(sql_stmt))! {
                print ("Error \(pantryDB?.lastErrorMessage())")
                // status.text = "Create products table failed"
            }
            pantryDB?.close()
        }
        else {
            print ("Error \(pantryDB?.lastErrorMessage())")
        }
    }    
}
