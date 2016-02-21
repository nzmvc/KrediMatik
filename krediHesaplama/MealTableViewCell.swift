//
//  MealTableViewCell.swift
//  krediHesaplama
//
//  Created by MacBook on 10/12/15.
//  Copyright © 2015 befree. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var degerVD: UILabel!
    @IBOutlet weak var degerKT: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
