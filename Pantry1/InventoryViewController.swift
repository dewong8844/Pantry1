//
//  InventoryViewController.swift
//  Pantry1
//
//  Created by Dennis Wong on 12/6/16.
//  Copyright © 2016 Dennis Wong. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    /*
     This value is either passed by `InventoryTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new inventory item.
     */
    var item: Inventory?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field's user input thru delegate callbacks
        brandTextField.delegate = self
        nameTextField.delegate = self
        amountTextField.delegate = self
        locationTextField.delegate = self
        quantityTextField.delegate = self
        expirationDateTextField.delegate = self
        
        // Setup view if editing existing product
        if let item = item {
            navigationItem.title = item.brand + " " + item.name
            brandTextField.text = item.brand
            nameTextField.text = item.name
            amountTextField.text = String(item.amount)
            locationTextField.text = item.location
            quantityTextField.text = String(item.quantity)
        }

        // Enable save button only if mandatory product fields are set
        checkValidInventoryMandatoryFields()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the save button while editing
        saveButton.isEnabled = false
    }
    
    func checkValidInventoryMandatoryFields() {
        let brand = brandTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let amount = amountTextField.text ?? ""
        let quantity = quantityTextField.text ?? ""
        let location = locationTextField.text ?? ""

        saveButton.isEnabled = !brand.isEmpty && !name.isEmpty && !amount.isEmpty && !location.isEmpty && !quantity.isEmpty
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidInventoryMandatoryFields()
        if navigationItem.title != nil {
            navigationItem.title = brandTextField.text! + " " + nameTextField.text!
        }
    }

    
    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if saveButton === sender as? UIBarButtonItem {
            let brand = brandTextField.text ?? ""
            let name = nameTextField.text ?? ""
            let amount = amountTextField.text ?? ""
            let location = locationTextField.text ?? ""
            let quantity = quantityTextField.text ?? ""
            
            // set the product to be passed to ProductTableViewController after unwind the segue
            item = Inventory(brand: brand, name: name, amount: Float(amount)!, location: location, quantity: Int(quantity)!)
        }
    }
}
