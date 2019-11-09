//
//  FaqViewController.swift
//  GiftCard
//
//  Created by Apple on 2/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//
import UIKit
import Foundation
import Alamofire


class ContactViewController : BaseViewController {
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBrief: UIButton!
    @IBOutlet weak var btnPerson: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblOffice: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var lblConfirmEmail: UILabel!
    
    @IBOutlet weak var tfContact: UITextView!
    @IBOutlet weak var mainView: UIScrollView!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBAction func onChangeEmailTapped(_ sender: Any) {
        popView.isHidden = false
        tfEmail.placeholder = BaseViewController.gUserEmail
    }
    @IBAction func onPopViewTapped(_ sender: Any) {
        popView.isHidden = true
    }
    
    @IBAction func onOKTapped(_ sender: Any) {
       
        if (self.isValidEmail(email: tfEmail.text!) && (tfEmail.text != "")) {
             popView.isHidden = true
            BaseViewController.gUserChagneEmail = tfEmail.text!
            
            lblConfirmEmail.text = "After send. we'll check and send to ".appending(BaseViewController.gUserChagneEmail)
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
        //BaseViewController.gPrevVCID = Const.VC_HOME_ID
        self.modalViewController(id: Const.VC_ACCOUNT_ID, baseController: self)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView  = false
        self.view.addGestureRecognizer(tapGesture)
    }
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
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
            
            break
        default:
            btnHome.isHighlighted = false
        }
    }
 
    @IBAction func onSendTapped(_ sender: Any) {
        
        if (BaseViewController.gUserToken != "")
        {
            if(tfContact.text! != "")
            {
                fetchContactToServer()
            }
            else {
                SVProgressHUD.showInfo(withStatus: "Please input text.")
            }
            
        }
        else
        {
            SVProgressHUD.showInfo(withStatus: "You must login")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Toolbar
        btnHome.isHighlighted = true
        btnBrief.isHighlighted = true
        btnPerson.isHighlighted = false
        mainView.isHidden = true
        fetchGetContactFromServer()
        popView.isHidden = true
        lblConfirmEmail.text = "After send. we'll check and send to ".appending(BaseViewController.gUserEmail)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        tapGesture.cancelsTouchesInView  = false
        self.view.addGestureRecognizer(tapGesture)
        mainView.contentSize = CGSize.init(width: 320, height: 700)
        mainView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        mainView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    }

    func fetchContactToServer() {
        
        let url = Const.SERVER_REMOTE_URL + Const.SERVER_MESSAGE_URL
        SVProgressHUD.show()
        let param = [
            "message" :
                [
                    "contactinfo" : tfContact.text!,
                    Const.KEY_EMAIL : BaseViewController.gUserEmail,
                    Const.KEY_FBID : BaseViewController.gUserFBID,
                    Const.KEY_TOKEN : BaseViewController.gUserToken
                ]
            
        ]
        print(param)
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { response in
                SVProgressHUD.dismiss()
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let dic = response.result.value as? NSDictionary {
                            let dict = dic.copy() as! NSDictionary
                            if (dict.count != 0)
                            {
                                print("success")
                                SVProgressHUD.showSuccess(withStatus: "Success!")
                            }
                            
                        }
                        print("state success \(url)")
                        break
                    default:
                        print("error with response status: \(status)")
                        break
                    }
                }
                
                
        }
    }
    func fetchGetContactFromServer() {
        
        let url = Const.SERVER_REMOTE_URL + Const.SERVER_CONTACT_URL
        
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                SVProgressHUD.dismiss()
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let dic = response.result.value as? NSDictionary {
                            self.mainView.isHidden = false
                            self.lblEmail.text = dic.value(forKey: Const.KEY_RES_EMAIL) as? String
                            self.lblPhone.text = dic.value(forKey: Const.KEY_RES_PHONE) as? String
                            self.lblOffice.text = dic.value(forKey: Const.KEY_RES_OFFICE) as? String
                            self.lblWebsite.text = dic.value(forKey: Const.KEY_RES_WEBSITE) as? String
                            self.lblCompany.text = dic.value(forKey: Const.KEY_RES_COMPANY) as? String
                            
                            print(dic)
                            
                        }
                        print("state success \(url)")
                        break
                    default:
                        print("error with response status: \(status)")
                        break
                    }
                }
                
        }
        
    }
}
