//
//  PaymentTblCell.swift
//  GiftCard
//
//  Created by apple on 07/02/2018.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class PaymentTblCell: UITableViewCell {

    
    @IBOutlet weak var ivDown: UIImageView!
    
    @IBOutlet weak var ivUp: UIImageView!
    
    @IBOutlet weak var lblBrand: UILabel!
    
    
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    @IBOutlet weak var lblExpires: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
