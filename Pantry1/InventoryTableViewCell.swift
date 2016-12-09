//
//  InventoryTableViewCell.swift
//  Pantry1
//
//  Created by Dennis Wong on 12/6/16.
//  Copyright © 2016 Dennis Wong. All rights reserved.
//

import UIKit

class InventoryTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
