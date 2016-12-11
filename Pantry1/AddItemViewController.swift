//
//  AddItemViewController.swift
//  Pantry1
//
//  Created by Dennis Wong on 12/10/16.
//  Copyright © 2016 Dennis Wong. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: Properties
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var quantityPicker: UIPickerView!
    
    let quantityPickerData = ["-3", "-2", "-1", "+1", "+2", "+3"]
    var quantityPicked = 0
    
    
    /* stored barcode passed in from scan view controller */
    var barcode: Barcode?
    var item: Inventory? = nil
    var product: Product? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set delegates for the quantity picker
        pickerInit()
        
        // Handle the text field's user input thru delegate callbacks
        if barcode?.productId != 0 {
            //load the product, it should exist at this point
            product = Product.findProductById(id: (barcode?.productId)!)
            if let product = product {
                brandLabel.text = product.brand
                modelLabel.text = product.name
                amountLabel.text = String(product.amount)
            }
            
            item = Inventory.findItemByProductId(productId: (barcode?.productId)!)
        }
    }
    
    func pickerInit() {
        // Set delegates for the quantity picker
        quantityPicker.dataSource = self
        quantityPicker.delegate = self
        
        // force default to +1
        let initialRow = 3
        quantityPicker.selectRow(initialRow, inComponent: 0, animated: false)
        quantityPicked = Int(quantityPickerData[initialRow])!
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancel(_ sender: UIButton) {
        guard navigationController?.popToRootViewController(animated: true) != nil
            else {
                print("No navigation controller")
                return;
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        if item == nil {
            let brand = product?.brand
            let name = product?.name
            let amount = product?.amount
            let location = ""
            var quantity = quantityPicked
            if quantity < 0 {
                quantity = 0
            }
            item = Inventory(brand: brand!, name: name!, amount: amount!, location: location, quantity: quantity)
        }
        else {
            item?.quantity += quantityPicked
            if ((item?.quantity)! < 0) {
                item?.quantity = 0
            }
        }
        
        item?.saveToDB()
        guard navigationController?.popToRootViewController(animated: true) != nil
            else {
                print("No navigation controller")
                return;
        }
    }

    // MARK: Picker delegates and data sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quantityPickerData.count
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return quantityPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        quantityPicked = Int(quantityPickerData[row])!
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
