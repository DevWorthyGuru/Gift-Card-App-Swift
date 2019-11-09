//
//  ChatTblCell.swift
//  KindWorker
//
//  Created by NaSalRyo on 18/10/2017.
//  Copyright © 2017 NaSalRyo. All rights reserved.
//

import UIKit
protocol PersonTblDelegate: class {
    func didViewTapped(indexPath : IndexPath)
    
}
class PersonTblCell: UITableViewCell {

    weak var delegate : PersonTblDelegate?
    var tblIndexPath : IndexPath?
    @IBOutlet weak var ivProfile: UIImageView!
    
    @IBOutlet weak var lblBrand: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    @IBOutlet weak var btnCart: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        ivProfile.layer.borderWidth = 1.0
        ivProfile.layer.masksToBounds = false
        ivProfile.layer.borderColor = UIColor.white.cgColor
        ivProfile.layer.cornerRadius = ivProfile.frame.size.width/2
        ivProfile.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onViewTapped(_ sender: Any) {
        delegate?.didViewTapped(indexPath: tblIndexPath!)
    }
    
}
