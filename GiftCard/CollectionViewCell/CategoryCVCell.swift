//
//  CategoryCVCell.swift
//  KindWorker
//
//  Created by NaSalRyo on 14/10/2017.
//  Copyright © 2017 NaSalRyo. All rights reserved.
//

import UIKit

class CategoryCVCell: UICollectionViewCell {

    @IBOutlet weak var ivCategory: UIImageView!
    
    @IBOutlet weak var lblCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.clipsToBounds = true
    }

}
