//
//  MyCustomCell.swift
//  krediHesaplama
//
//  Created by MacBook on 10/12/15.
//  Copyright © 2015 befree. All rights reserved.
//

import UIKit

class MyCustomCell: UITableViewCell {

    
    @IBOutlet weak var krediT: UILabel!
    @IBOutlet weak var vadeL: UILabel!
    
    @IBOutlet weak var faizF: UILabel!
    @IBOutlet weak var toplamGeriO: UILabel!
    @IBOutlet weak var aylıkT: UILabel!
    @IBOutlet weak var oran: UILabel!
    
    @IBOutlet weak var kB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
