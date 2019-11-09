//
//  ChatTblCell.swift
//  KindWorker
//
//  Created by NaSalRyo on 18/10/2017.
//  Copyright © 2017 NaSalRyo. All rights reserved.
//

import UIKit

class PaymentSubTblCell: UITableViewCell {

    
   
    @IBOutlet weak var lblBrand: UILabel!
    
    @IBOutlet weak var lblValue: UILabel!
    
    @IBOutlet weak var lblServiceCost: UILabel!
    
    @IBOutlet weak var lblTransCost: UILabel!
    
    @IBOutlet weak var lblPayingPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
