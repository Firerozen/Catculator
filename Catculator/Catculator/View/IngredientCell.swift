//
//  IngredientCell.swift
//  Catculator
//
//  Created by shawn on 18/01/2020.
//  Copyright © 2020 firerozen. All rights reserved.
//

import UIKit

class IngredientCell: UITableViewCell {

    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UITextField!
    
    @IBAction func quantityModified(_ sender: UITextField) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
