//
//  ProductViewController.swift
//  Pantry1
//
//  Created by Dennis Wong on 12/4/16.
//  Copyright © 2016 Dennis Wong. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    // MARK: Properties
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var moreDescriptionTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `ProductTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new product.
     */
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddProductMode = presentingViewController is UINavigationController
        if isPresentingInAddProductMode {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if saveButton === sender as? UIBarButtonItem {
            let brand = brandTextField.text ?? ""
            let name = modelTextField.text ?? ""
            let amount = amountTextField.text ?? ""
            let unit = unitTextField.text ?? ""
            let ingredient = ingredientTextField.text ?? ""
            let category = categoryTextField.text ?? ""
            
            // set the product to be passed to ProductTableViewController after unwind the segue
            product = Product(brand: brand, name: name, amount: Float(amount)!, unit: unit, ingredient: ingredient, category: category)
        }
    }
}
