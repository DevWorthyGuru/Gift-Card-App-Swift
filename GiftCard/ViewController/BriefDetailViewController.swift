//
//  BriefViewController.swift
//  Stakk
//
//  Created by Apple on 1/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//
import UIKit
import Foundation
import Alamofire
class BriefDetailViewController : BaseViewController {
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBrief: UIButton!
    @IBOutlet weak var btnPerson: UIButton!
    @IBOutlet weak var lblReport: UILabel!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var btnCart: UIButton!
    var tblIndex : Int?
    var selCardInfo : NSDictionary?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblExpires: UILabel!
    
    @IBOutlet weak var imgCard: UIImageView!
    
    @IBOutlet weak var lblInfoValue: UILabel!
    @IBOutlet weak var lblInfoSellCost: UILabel!
    @IBOutlet weak var lblInfoServiceCost: UILabel!
    @IBOutlet weak var lblInfoTransCost: UILabel!
    @IBOutlet weak var lblInfoTotalCost: UILabel!
    
    
    @IBAction func onCartTapped(_ sender: Any) {
        var dic : NSDictionary?
        if BaseViewController.gSellerInfos != nil
        {
            dic = BaseViewController.gSellerInfos?[BaseViewController.gSelectSellerIndex!] as? NSDictionary
        }
        else
        {
            dic = selCardInfo
        }
        let cardID = dic?.value(forKey: Const.KEY_CARDID) as! String
        if self.isInCart(cardId: cardID) {
             btnCart.setImage(UIImage.init(named: "cart_disable"), for: UIControlState.normal)
            self.removeInCart(cardId: cardID)
        }
        else{
            btnCart.setImage(UIImage.init(named: "cart_enable"), for: UIControlState.normal)
            addInCart(cardInfo: dic!)
        }
        
//        let isCart = NSNumber.init(value: Int.init(dic.value(forKey: Const.KEY_ISCART) as! String)!)
//        
//        if Bool.init(isCart) {
//            
////                        setSellerInfo(val: "0", key: Const.KEY_ISCART, index: BaseViewController.gSelectSellerIndex!)
//            
//            
//        }
//        else{
//           
//            setSellerInfo(val: "1", key: Const.KEY_ISCART, index: BaseViewController.gSelectSellerIndex!)
//            
//        }
    }
    @IBAction func btnBackTapped(_ sender: Any) {
//        btnBrief.isHighlighted = false
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.layer.add(transition, forKey: "rightToLeftTransition")
        self.modalViewController(id: Const.VC_MARKET_ID, baseController: self)
    }
    @IBAction func onInformationTapped(_ sender: Any) {
        viewPopUp.isHidden = false
    }
    @IBAction func onPopupCloseTapped(_ sender: Any) {
        viewPopUp.isHidden = true
    }
    @IBAction func onBuynowTapped(_ sender: Any) {
        BaseViewController.gPrevVCID = Const.VC_SELLERINFO_ID
        self.modalViewController(id: Const.VC_PAY_ID, baseController: self)
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
            self.modalViewController(id: Const.VC_CHOOSE_ID, baseController: self)
            break
        case 2:
            BaseViewController.gPrevVCID = Const.VC_SELLERINFO_ID
            self.modalViewController(id: Const.VC_ACCOUNT_ID, baseController: self)
            break
        default:
            btnHome.isHighlighted = false
        }
    }
    
    func uiRefresh() {
        let dic = selCardInfo!
        lblTitle.text = (dic.value(forKey: Const.KEY_BRAND) as! String).appending(" - € ").appending(dic.value(forKey: Const.KEY_VALUE) as! String).appending(", Selling € ").appending(dic.value(forKey: Const.KEY_TOTALPRICE) as! String)
        
        lblExpires.text = "Expires ".appending((dic.value(forKey: Const.KEY_EXPIRES) as? String)!)
        
        imgAvatar.image = UIImage.init(named: dic.value(forKey: Const.KEY_AVATAR) as! String)
        
        imgAvatar.layer.borderWidth = 1.0
        imgAvatar.layer.masksToBounds = false
        imgAvatar.layer.borderColor = UIColor.white.cgColor
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width/2
        imgAvatar.clipsToBounds = true
        imgAvatar.sd_setImage(with: URL(string: dic.value(forKey: Const.KEY_AVATAR) as! String), placeholderImage: UIImage(named: "Userpic"))
        let cardInfo = BaseViewController.gCardTypes![Int.init(dic.value(forKey: "type") as! String)! - 1] as! NSDictionary
        imgCard.sd_setImage(with: URL(string: cardInfo.value(forKey: Const.KEY_CARDIMAGE) as! String), placeholderImage: UIImage(named:"Card_Toolber"))
        lblName.text = dic.value(forKey: Const.KEY_NAME) as? String
        
        
        lblTotalPrice.text = "€ ".appending((dic.value(forKey: Const.KEY_TOTALPRICE) as? String)!)
        
        lblInfoValue.text = "€ ".appending((dic.value(forKey: Const.KEY_VALUE) as? String)!)
        lblInfoSellCost.text = "€ ".appending((dic.value(forKey: Const.KEY_SELLCOST) as? String)!)
        lblInfoTotalCost.text = "€ ".appending((dic.value(forKey: Const.KEY_TOTALPRICE) as? String)!)
        lblInfoTransCost.text = "€ ".appending((dic.value(forKey: Const.KEY_TRANSCOST) as? String)!)
        lblInfoServiceCost.text = "€ ".appending((dic.value(forKey: Const.KEY_SERVICECOST) as? String)!)
        lblReport.text = "Prijs inclusief ".appending(lblInfoServiceCost.text!).appending(" servicekosten en exclusief transactiekosten (vanaf ").appending(lblInfoTransCost.text!).appending(" per transactie). Het saldo op de kaart is ").appending(lblInfoValue.text!).appending(".")
        
        
        
        if self.isInCart(cardId: dic.value(forKey: Const.KEY_CARDID) as! String) {
            btnCart.setImage(UIImage.init(named: "cart_enable"), for: UIControlState.normal)
            //0 show 1 hide
        }
        else{
            btnCart.setImage(UIImage.init(named: "cart_disable"), for: UIControlState.normal)
            //0 show 1 hide
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Toolbar
        btnHome.isHighlighted = true
        btnBrief.isHighlighted = false
        btnPerson.isHighlighted = true
        btnHome.isHighlighted = true
        btnBrief.isHighlighted = false
        btnPerson.isHighlighted = true
        viewPopUp.isHidden = true
        if BaseViewController.gSellerInfos != nil
        {
            selCardInfo = BaseViewController.gSellerInfos?[BaseViewController.gSelectSellerIndex!] as? NSDictionary
            uiRefresh()
        }
        else
        {
            fetchGetCardInfosFromServer()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchGetCardInfosFromServer() {
        
        let url = Const.SERVER_REMOTE_URL + Const.SERVER_SELECTCARD_URL
        
        let param = ["selectcard" :
            [
            Const.KEY_CARDID : BaseViewController.gSelCardID,
            Const.KEY_CARDTYPE : BaseViewController.gSelCardType
            ]
        ]
        print(param)
        SVProgressHUD.show()
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { response in
                SVProgressHUD.dismiss()
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let dic = response.result.value as? NSDictionary {
                            if (dic.value(forKey: Const.KEY_RES_SELECTCARDINFO) as? NSDictionary) != nil
                            {
                                self.selCardInfo = dic.value(forKey: Const.KEY_RES_SELECTCARDINFO) as? NSDictionary
                                self.uiRefresh()
                            }
                            
                        }
                        print("state success \(url)")
                        break
                    default:
                        print("error with response status: \(status)")
                        break
                    }
                }
                
                //self.uiRefresh()
                
        }
        
    }
}



