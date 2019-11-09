//
//  BriefViewController.swift
//  Stakk
//
//  Created by Apple on 1/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//
import UIKit
import Foundation


class BriefViewController : BaseViewController {
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBrief: UIButton!
    @IBOutlet weak var btnPerson: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func btnBackTapped(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.layer.add(transition, forKey: "rightToLeftTransition")
        self.modalViewController(id: Const.VC_HOME_ID, baseController: self)
    }
    
    @IBAction func toolbarTapped(_ sender: Any) {
        let btn = sender as! UIButton
        btnHome.isHighlighted = true
        btnBrief.isHighlighted = true
        btnPerson.isHighlighted = true
        switch btn.tag {
        case 0:
            btnHome.isHighlighted = false
            self.modalViewController(id: Const.VC_HOME_ID, baseController: self)
            break
        case 1:
           
            break
        case 2:
            BaseViewController.gPrevVCID = Const.VC_CHOOSE_ID
           self.modalViewController(id: Const.VC_ACCOUNT_ID, baseController: self)
            break
        default:
            btnHome.isHighlighted = false
        }
    }
    @IBAction func onBuyingTapped(_ sender: Any) {
        
        if (BaseViewController.gUserToken != "")
        {
            self.modalViewController(id: Const.VC_MARKET_ID, baseController: self)
        }
        else
        {
             BaseViewController.gPrevVCID = Const.VC_CHOOSE_ID
            self.modalViewController(id: Const.VC_ACCOUNT_ID, baseController: self)
        }
        
    }
    
    @IBAction func onSellingTapped(_ sender: Any) {
        if (BaseViewController.gUserToken != "")
        {
            self.modalViewController(id: Const.VC_SCANCARD_ID, baseController: self)
        }
        else
        {
            BaseViewController.gPrevVCID = Const.VC_CHOOSE_ID
            self.modalViewController(id: Const.VC_ACCOUNT_ID, baseController: self)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Toolbar 
        btnHome.isHighlighted = true
        btnBrief.isHighlighted = false
        btnPerson.isHighlighted = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnHome.isHighlighted = true
        btnBrief.isHighlighted = false
        btnPerson.isHighlighted = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension String {
    func height(constrainedBy width: CGFloat, with font: UIFont) -> CGFloat {
        let constraintSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(constrainedBy height: CGFloat, with font: UIFont) -> CGFloat {
        let constrainedSize = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
}
