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

class SellCardViewController : BaseViewController {
    
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBrief: UIButton!
    @IBOutlet weak var btnPerson: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var lblConfirmEmail: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var btnSellCard: UIButton!
   
    //let cardTitles = ["Brand", "Value", "Selling Price", "Service Cost(2.5%)", "The Buyer Saves"]
    let cardTitles = ["Saldo op de kaart", "Jouw Verkoopprijs", "Korting Voor de Koper", "Servicekosten STACKK(7%)"]
    
    var sellCardInfo : NSArray?
    
    @IBAction func onPopViewTapped(_ sender: Any) {
        popView.isHidden = true
    }
    
    @IBAction func onOKTapped(_ sender: Any) {
        if (self.isValidEmail(email: tfEmail.text!) && (tfEmail.text != "")) {
            popView.isHidden = true
            BaseViewController.gUserChagneEmail = tfEmail.text!
            lblConfirmEmail.text = "Na de acceptatie sturen we een bevestiging naar".appending(BaseViewController.gUserChagneEmail)
        }
        else {
            SVProgressHUD.showInfo(withStatus: "Please input Email address.")
        }
        
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
//        btnBrief.isHighlighted = false

        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.layer.add(transition, forKey: "rightToLeftTransition")
        self.modalViewController(id: Const.VC_SCANCARD_ID, baseController: self)
    }
    @IBAction func onChaneEmailTapped(_ sender: Any) {
        popView.isHidden = false
        tfEmail.placeholder = BaseViewController.gUserEmail
    }
    
    @IBAction func onSellCardTapped(_ sender: Any) {
        fetchSendSellCardInfosToServer()
        btnSellCard.isEnabled = false
    }
    
    @IBAction func onTermsTapped(_ sender: Any) {
        BaseViewController.gPrevVCID = Const.VC_SELLCARD_ID
        self.modalViewController(id: Const.VC_TERMCOND_ID, baseController: self)
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
            BaseViewController.gPrevVCID = Const.VC_SELLCARD_ID
            self.modalViewController(id: Const.VC_ACCOUNT_ID, baseController: self)
            break
        default:
            btnHome.isHighlighted = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Toolbar
        btnHome.isHighlighted = true
        btnBrief.isHighlighted = false
        btnPerson.isHighlighted = true
        let sellCardInfos = NSMutableArray.init()
        sellCardInfos.add(BaseViewController.gSellCardBrand)
        
        let value = Float.init(BaseViewController.gSellCardValue)!
        let sellCost = Float.init(BaseViewController.gSellCardSellCost)!
        let serviceCost = sellCost / 40
        let save = Int.init((value - sellCost) / value * 100)
        btnSellCard.isEnabled = true
        popView.isHidden = true
        lblConfirmEmail.text = "Na de acceptatie sturen we een bevestiging naar ".appending(BaseViewController.gUserEmail)
        sellCardInfos.add("€ ".appending(String.init(format: "%.2f", value)))
        sellCardInfos.add("€ ".appending(String.init(format: "%.2f",sellCost)))
        sellCardInfos.add(String.init(save).appending("%"))
        sellCardInfos.add("€ ".appending(String.init(format: "%.2f",serviceCost)))
        
        sellCardInfo = sellCardInfos.copy() as? NSArray
        //        lblConfirmEmail.text = "After payment has ben made. we'll send the confirmation and the gift to ".appending("")
        mainScrollView.contentSize = CGSize.init(width: 320, height: 700)
        mainScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView  = false
        self.view.addGestureRecognizer(tapGesture)
       
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tfEmail{
            return !(textField.text?.characters.count == 20 && string != "")
        }
        return true
    }// this is return the maximum characters in textfield
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchSendSellCardInfosToServer() {
    
        let url = Const.SERVER_REMOTE_URL + Const.SERVER_POSTCARD_URL
        var email = ""
        if BaseViewController.gUserChagneEmail != "" {
            email = BaseViewController.gUserChagneEmail
        }
        else
        {
            email = BaseViewController.gUserEmail
        }
        
        
        let param = [
            "sellcardinfo" :
                [
                    Const.KEY_CARDTYPE: BaseViewController.gSellCardType,
                    Const.KEY_VALUE: BaseViewController.gSellCardValue,
                    Const.KEY_SELLCOST: BaseViewController.gSellCardSellCost,
                    Const.KEY_SELLCARDNO: BaseViewController.gSellCardNo,
                    Const.KEY_EXPIRES : BaseViewController.gSellCardExpire,
                    Const.KEY_EMAIL : email,
                    Const.KEY_FBID : BaseViewController.gUserFBID,
                    Const.KEY_FIRSTNAME : BaseViewController.gUserFirstName,
                    Const.KEY_LASTNAME : BaseViewController.gUserLastName,
                    Const.KEY_USRPICURL : BaseViewController.gUserPicURL,
                    Const.KEY_TOKEN : BaseViewController.gUserToken
            ]
        ]
        print(param)
        SVProgressHUD.show()
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { response in
               
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let dic = response.result.value as? NSDictionary {
                            if let dict = dic.value(forKey: Const.KEY_RES_CARDRESULT) as? NSDictionary
                            {
                                if (dict.count != 0)
                                {
                                    if ((dict.value(forKey: Const.KEY_RES_STATUS) as? String) == Const.KEY_RES_SUCCESS)
                                    {
                                        // Success
                                        SVProgressHUD.showSuccess(withStatus: "Sucess!")
                                        self.modalViewController(id: Const.VC_HOME_ID, baseController: self)
                                        
                                    }
                                }

                            }
                            
                        }
                        print("state success \(url)")
                        break
                    default:
                        print("error with response status: \(status)")
                        SVProgressHUD.showError(withStatus: "fail!")
                        break
                        
                    }
                }
                else {
                    SVProgressHUD.dismiss()
                }
                
                self.uiRefresh()
                
        }
        
    }
    func uiRefresh()
    {
        btnSellCard.isEnabled = true
    }

}

extension SellCardViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "myHeaderCell")
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = sellCardInfo?[0] as? String
        cell.textLabel?.font = UIFont(name: "Tamil Sangam MN", size: 21.0)
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.textAlignment = .center
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return CGFloat(50);
//    }
//    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "cardInfoCell")
        cell.textLabel?.text = cardTitles[indexPath.row]
        
        cell.detailTextLabel?.text = sellCardInfo?[indexPath.row + 1] as? String
        cell.detailTextLabel?.isUserInteractionEnabled = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}


