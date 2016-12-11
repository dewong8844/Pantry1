//
//  AddProductViewController.swift
//  Pantry1
//
//  Created by Dennis Wong on 12/10/16.
//  Copyright © 2016 Dennis Wong. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    @IBOutlet weak var barcodeValue: UILabel!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var moreDescriptionTextField: UITextField!

    @IBOutlet weak var saveButton: UIButton!
    
    /* stored barcode passed in from scan view controller */
    var barcode: Barcode?
    var product: Product? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        if barcode != nil {
            barcodeValue.text = barcode?.barcode
        }
        
        // Handle the text field's user input thru delegate callbacks
        brandTextField.delegate = self
        modelTextField.delegate = self
        amountTextField.delegate = self
        unitTextField.delegate = self
        categoryTextField.delegate = self
        descriptionTextField.delegate = self
        moreDescriptionTextField.delegate = self
        
        // Setup view if editing existing product
        if let product = product {
            navigationItem.title = product.ingredient
            brandTextField.text = product.brand
            modelTextField.text = product.name
            amountTextField.text = String(product.amount)
            unitTextField.text = product.unit
            ingredientTextField.text = product.ingredient
            categoryTextField.text = product.category
            descriptionTextField.text = product.desc
            moreDescriptionTextField.text = product.desc2
        }
        
        // Enable save button only if mandatory product fields are set
        checkValidProductMandatoryFields()
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
    
    func checkValidProductMandatoryFields() {
        let brand = brandTextField.text ?? ""
        let name = modelTextField.text ?? ""
        let amount = amountTextField.text ?? ""
        let unit = unitTextField.text ?? ""
        let ingredient = ingredientTextField.text ?? ""
        let category = categoryTextField.text ?? ""
        saveButton.isEnabled = !brand.isEmpty && !name.isEmpty && !amount.isEmpty && !unit.isEmpty && !ingredient.isEmpty && !category.isEmpty
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidProductMandatoryFields()
        if navigationItem.title != nil {
            navigationItem.title = ingredientTextField.text
        }
    }
    

    @IBAction func cancel(_ sender: UIButton) {
        guard navigationController?.popViewController(animated: true) != nil
            else {
                print("No navigation controller")
                return;
        }
    }

    @IBAction func save(_ sender: UIButton) {
        let brand = brandTextField.text ?? ""
        let name = modelTextField.text ?? ""
        let amount = amountTextField.text ?? ""
        let unit = unitTextField.text ?? ""
        let ingredient = ingredientTextField.text ?? ""
        let category = categoryTextField.text ?? ""
        
        // set the product to be saved to the DB
        product = Product(brand: brand, name: name, amount: Float(amount)!, unit: unit, ingredient: ingredient, category: category)
        product?.saveToDB()
        
        // save the barcode
        barcode?.productId = Product.findProductIdByName(brand: brand, name: name, amount: Float(amount)!)
        barcode?.saveToDB()
        
        // proceed to add a new item to the home inventory
        // TODO: investigate why it crashes, move call to storyboard for now
        // self.performSegue(withIdentifier: "ScanAddItem", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ScanAddProductAddItem" {
            let nextViewController = segue.destination as! AddItemViewController
            nextViewController.barcode = barcode
        }
    }
    

}
