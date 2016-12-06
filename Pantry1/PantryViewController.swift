//
//  ViewController.swift
//  Pantry1
//
//  Created by Dennis Wong on 11/26/16.
//  Copyright © 2016 Dennis Wong. All rights reserved.
//

import UIKit

class PantryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the pantry DB
        Pantry.initDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

