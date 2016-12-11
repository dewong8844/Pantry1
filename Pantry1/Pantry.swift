//
//  Pantry.swift
//  Pantry1
//
//  Created by Dennis Wong on 12/4/16.
//  Copyright © 2016 Dennis Wong. All rights reserved.
//

import UIKit

class Pantry {
    static var databasePath = String()

    static func initDB() {
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        databasePath = dirPaths[0].appendingPathComponent("pantry.db").path
        if !filemgr.fileExists(atPath: databasePath as String) {
            
            // copy initial version of contacts.db file from main bundle
            let bundlePath = Bundle.main.path(forResource: "pantry", ofType: ".db")
            if bundlePath == nil {
                print ("Error: unable to find pantry.db in main bundle")
                return
            }
            // copy file from main bundle to Documents directory
            do {
                try filemgr.copyItem(atPath: bundlePath!, toPath: databasePath)
                print("Copy file from \(bundlePath) to \(databasePath)")
            }
            catch {
                print("\n")
                print(error)
            }
            
            let pantryDB = FMDatabase(path: databasePath as String)
            if pantryDB == nil {
                print ("Error \(pantryDB?.lastErrorMessage())")
            }
        }
        else {
            print ("pantry.db found and ready to go")
        }
        
    }
}
