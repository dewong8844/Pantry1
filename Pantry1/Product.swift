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
    
    // MARK: Database Operations
    
    func saveToDB() {
        let pantryDB = FMDatabase(path: Pantry.databasePath as String)
        if (pantryDB?.open())! {
            let querySQL = "SELECT * FROM products WHERE brand = '\(brand)' AND name = '\(name)' AND amount = \(String(amount))"
            let results:FMResultSet? = pantryDB?.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                let updateSQL = "UPDATE products SET unit='\(self.unit)', ingredient='\(self.ingredient)', category='\(self.category)' WHERE brand = '\(self.brand)' AND name = '\(self.name)' AND amount = \(String(self.amount))"
                let result = pantryDB?.executeUpdate(updateSQL, withArgumentsIn: nil)
                if !result! {
                    //print(Failed to update contact"),
                    print ("Error in update, \(pantryDB?.lastErrorMessage())")
                }
                else {
                    print("Product Updated")
                }
            }
            else {
                let insertSQL = "INSERT INTO products (brand, name, amount, unit, ingredient, category) VALUES ('\(self.brand)', '\(self.name)', '\(Float(self.amount))', '\(self.unit)', '\(self.ingredient)', '\(self.category)')"
                let result = pantryDB?.executeUpdate(insertSQL, withArgumentsIn: nil)
                if !result! {
                    print ("Error in insert, \(pantryDB?.lastErrorMessage())")
                }
                else {
                    print("Product Added")
                }
            }
            pantryDB?.close()
        }
        else {
            print("Error in saveToDB, open products DB failed")
        }
    }
    
    
    static func findProductIdByName(brand:String, name:String, amount:Float) -> Int {
        let pantryDB = FMDatabase(path: Pantry.databasePath as String)
        var productId: Int?
        
        if (pantryDB?.open())! {
            let querySQL = "SELECT * FROM products WHERE brand = '\(brand)' AND name = '\(name)' AND amount = \(String(amount))"
            let results:FMResultSet? = pantryDB?.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                print("Record found")
                print(results?.resultDictionary() as Any)
                let id = (results?.string(forColumn: "product_id"))!
                productId = Int(id)
            }
            else {
                print("Record not found")
                productId = 0
            }
            pantryDB?.close()
        }
        else {
            print ("Error \(pantryDB?.lastErrorMessage())")
        }
        
        return productId!
    }
    
    static func findProductById(id: Int) -> Product? {
        let pantryDB = FMDatabase(path: Pantry.databasePath as String)
        var product: Product?
        
        if (pantryDB?.open())! {
            let querySQL = "SELECT * FROM products WHERE product_id = \(id)"
            let results:FMResultSet? = pantryDB?.executeQuery(querySQL, withArgumentsIn: nil)
            if results?.next() == true {
                print("Record found")
                print(results?.resultDictionary() as Any)
                let brand = (results?.string(forColumn: "brand"))!
                let name = (results?.string(forColumn: "name"))!
                let amount = (results?.string(forColumn: "amount"))!
                let unit = (results?.string(forColumn: "unit"))!
                let category = (results?.string(forColumn: "category"))!
                let ingredient = (results?.string(forColumn: "ingredient"))!
                product = Product(brand: brand, name: name, amount: Float(amount)!, unit: unit, ingredient: ingredient, category: category)

            }
            else {
                print ("Error \(pantryDB?.lastErrorMessage())")
                product = nil
            }
            pantryDB?.close()
        }
        else {
            print ("Error \(pantryDB?.lastErrorMessage())")
        }
        
        return product        
    }

    
    func removeFromDB() {
        let pantryDB = FMDatabase(path: Pantry.databasePath as String)
        if (pantryDB?.open())! {
            let deleteSQL = "DELETE FROM products WHERE brand = '\(brand)' AND name = '\(name)' AND amount = \(String(amount))"
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

    
    static func loadProductsFromDB() -> [Product]? {
        let pantryDB = FMDatabase(path: Pantry.databasePath as String)
        var products = [Product]()
        
        if (pantryDB?.open())! {
            let querySQL = "SELECT * FROM products"
            let results:FMResultSet? = pantryDB?.executeQuery(querySQL, withArgumentsIn: nil)
            if results != nil {
                print("Record found")
                while results?.next() == true {
                    print(results?.resultDictionary() as Any)
                    let brand = (results?.string(forColumn: "brand"))!
                    let name = (results?.string(forColumn: "name"))!
                    let amount = (results?.string(forColumn: "amount"))!
                    let unit = (results?.string(forColumn: "unit"))!
                    let category = (results?.string(forColumn: "category"))!
                    let ingredient = (results?.string(forColumn: "ingredient"))!
                    let product = Product(brand: brand, name: name, amount: Float(amount)!, unit: unit, ingredient: ingredient, category: category)
                    products += [product]
                }
            }
            else {
                print("Record not found")
                // product = nil
            }
            pantryDB?.close()
        }
        else {
            print ("Error \(pantryDB?.lastErrorMessage())")
        }
        
        return products
    }
    
    // TODO: cannot create just products table,
    //       need to create ingredients and categories first, how to do this?
    static func createProductDB() {
        let pantryDB = FMDatabase(path: Pantry.databasePath as String)
        if (pantryDB?.open())! {
            let sql_stmt = "CREATE TABLE IF NOT EXISTS Products (product_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,  " + "category NVARCHAR(30) NOT NULL REFERENCES Categories(name), ingredient NVARCHAR(30) NOT NULL REFERENCES"
                + "Ingredients(type), brand NVARCHAR(100) NOT NULL, name NVARCHAR(100) NOT NULL, amount REAL, "
                + "unit NVARCHAR(30), desc NVARCHAR(100), desc2 NVARCHAR(100)"
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
