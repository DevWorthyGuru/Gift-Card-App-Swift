//
//  ScanCardBrandTblCell.swift
//  GiftCard
//
//  Created by Apple on 2/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class ScanCardBrandTblCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var pickBrand: UIPickerView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
