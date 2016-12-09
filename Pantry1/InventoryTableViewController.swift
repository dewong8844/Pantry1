//
//  InventoryTableViewController.swift
//  Pantry1
//
//  Created by Dennis Wong on 12/6/16.
//  Copyright © 2016 Dennis Wong. All rights reserved.
//

import UIKit

class InventoryTableViewController: UITableViewController {
    //MARK: Properties
    var inventoryList = [Inventory]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // load the sample data
        if let savedInventory = Inventory.loadInventoryFromDB() {
            inventoryList += savedInventory
        }
        else {
            loadSampleInventory()
        }
    }
    
    func loadSampleInventory() {
        let item1 = Inventory(brand: "Advil", name: "Ibuprofen 200mg", amount: 360, location: "medicine cabinet", quantity: 1)
        let item2 = Inventory(brand: "Kong Yen", name: "rice vinegar", amount: 20.2, location: "kitchen counter", quantity: 8)
        inventoryList += [item1, item2]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return inventoryList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "InventoryTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! InventoryTableViewCell

        // Fetches the appropriate inventory for the data source layout
        let item = inventoryList[indexPath.row]
        
        cell.brandLabel.text = item.brand
        cell.modelLabel.text = item.name
        cell.quantityLabel.text = String(item.quantity)

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
            let item = inventoryList[indexPath.row]
            item.removeFromDB()
            inventoryList.remove(at: indexPath.row)
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
        dismiss(animated:true, completion:nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let inventoryDetailViewController = segue.destination as! InventoryViewController
            if let selectedInventoryCell = sender as? InventoryTableViewCell {
                let indexPath = tableView.indexPath(for: selectedInventoryCell)!
                let selectedItem = inventoryList[(indexPath as NSIndexPath).row]
                inventoryDetailViewController.item = selectedItem
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new inventory item.")
        }

    }
    
    @IBAction func unwindToInventoryList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? InventoryViewController, let item = sourceViewController.item {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing product
                inventoryList[(selectedIndexPath as NSIndexPath).row] = item
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // add a new inventory item
                let newIndexPath = IndexPath(row: inventoryList.count, section: 0)
                inventoryList.append(item)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
            
            // Save the inventory item
            item.saveToDB()
        }
    }


}
