//
//  ProductTableViewController.swift
//  Pantry1
//
//  Created by Dennis Wong on 12/2/16.
//  Copyright © 2016 Dennis Wong. All rights reserved.
//

import UIKit

class ProductTableViewController: UITableViewController {
    // MARK: Properties
    var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Load the sample data.
        if let savedProducts = Product.loadProductsFromDB() {
            products += savedProducts
        }
        else {
            loadSampleProducts()
        }
    }

    func loadSampleProducts() {
        let product1 = Product(brand: "Advil", name: "Ibuprofen Tablets 200mg", amount: 360, unit: "tablet", ingredient: "ibuprofen", category: "medicine")
        let product2 = Product(brand: "McNeil", name: "Benadryl Allergy", amount: 24, unit: "tablet", ingredient: "benadryl", category: "medicine")
        let product3 = Product(brand: "Motrin IB", name: "Ibuprofen Tablets 200mg", amount: 100, unit: "tablets", ingredient: "ibuprofen", category: "medicine")
        
        products += [product1, product2, product3]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cless are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ProductTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ProductTableViewCell

        // Fetch the appropriate meal for the data source layout.
        let product = products[indexPath.row]

        // Configure the cell...
        cell.brandLabel.text = product.brand
        cell.modelLabel.text = product.name

        return cell
    }



    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let product = products[indexPath.row]
            product.removeFromDB()
            products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let productDetailViewController = segue.destination as! ProductViewController
            if let selectedProductCell = sender as? ProductTableViewCell {
                let indexPath = tableView.indexPath(for: selectedProductCell)!
                let selectedProduct = products[(indexPath as NSIndexPath).row]
                productDetailViewController.product = selectedProduct
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new product.")
        }
    }

    
    @IBAction func unwindToProductList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ProductViewController, let product = sourceViewController.product {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing product
                products[(selectedIndexPath as NSIndexPath).row] = product
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // add a new product
                let newIndexPath = IndexPath(row: products.count, section: 0)
                products.append(product)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
            
            // Save the product
            product.saveToDB()
        }
    }

}
