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

class AccountViewController : BaseViewController {
    
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBrief: UIButton!
    @IBOutlet weak var btnPerson: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    
    
    let titlesHelp = ["Contact", "Veelgestelde vragen", "Over ons", "Algemene Voorwaarden", "Privacy"]
    let titlesAccount = ["Mijn advertenties", "Mijn uitbetalingen", "Profiel", "Uitloggen"]
    
    @IBOutlet weak var tblAccount: UITableView!
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
//        btnBrief.isHighlighted = false
//        self.modalViewController(id: Const.VC_HOME_ID, baseController: self)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.layer.add(transition, forKey: "rightToLeftTransition")
        self.modalViewController(id: BaseViewController.gPrevVCID, baseController: self)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Toolbar
        btnHome.isHighlighted = true
        btnBrief.isHighlighted = true
        btnPerson.isHighlighted = false
        
        //        lblConfirmEmail.text = "After payment has ben made. we'll send the confirmation and the gift to ".appending("")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchUserInfoToServer() {
        let url = Const.SERVER_REMOTE_URL +  Const.SERVER_POSTLOGIN_URL
        SVProgressHUD.show()
        let param = ["userinfo" :
            [   Const.KEY_FIRSTNAME : BaseViewController.gUserFirstName,
                Const.KEY_LASTNAME : BaseViewController.gUserLastName,
                Const.KEY_EMAIL: BaseViewController.gUserEmail,
                Const.KEY_FBID : BaseViewController.gUserFBID,
                Const.KEY_USRPICURL : BaseViewController.gUserPicURL
            ]
        ]
        print(param)
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { response in
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let dic = response.result.value as? NSDictionary {
                            let dict = dic.copy() as! NSDictionary
                            if (dict.count != 0)
                            {
                               print("success")
                               
                                BaseViewController.gUserToken = dict.value(forKey: "token") as! String
                                 SVProgressHUD.showSuccess(withStatus: "Success!")
                                self.tblAccount.reloadData()
                            }
                            
                        }
                        print("state success \(url)")
                        break
                    default:
                        print("error with response status: \(status)")
                        SVProgressHUD.dismiss()
                        break
                    }
                }
                
                
        }
    }

    func getFacebookUserInfo() {
        
        if((FBSDKAccessToken.current()) != nil){
            
            SVProgressHUD.show()
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                
                SVProgressHUD.dismiss()
                
                if (error == nil){
                    //                    print(result)
                    
                    let data = result as! NSDictionary
                    
                    let fbID = data.value(forKey: "id") as? String
                    let email = data.value(forKey: "email") as? String
                    
                    let firstName = data.value(forKey: "first_name") as? String
                    let lastName = data.value(forKey: "last_name") as? String
                    let picture = data.value(forKey: "picture") as? NSDictionary
                    let picdata = picture?.value(forKey: "data") as? NSDictionary
                    let urlPic = (picdata?.value(forKey: "url"))! as? String
                    BaseViewController.gUserFBID = fbID!
                    BaseViewController.gUserLastName = lastName!
                    BaseViewController.gUserFirstName = firstName!
                    if email != nil
                    {
                        BaseViewController.gUserEmail = email!
                    }
                    BaseViewController.gUserPicURL = urlPic!
                    
                   
                    self.fetchUserInfoToServer()

//
//                    let param = ["User" :
//                        ["first_name" : firstName!,
//                         "last_name" : lastName!,
//                         "email" : email,
//                         "password" : "KindWorker",
//                         "contact_no" : "",
//                         "social_id" : fbID!,
//                         "social_type" : "facebook",
//                         "device_token" : deviceToken,
//                         "device_type" : 0]
                    
//                    ]
                }
                else{
                    /// for test
                    BaseViewController.gUserFBID = "18236724098093248"
                    BaseViewController.gUserFirstName = "John"
                    BaseViewController.gUserLastName = "Smith"
                    BaseViewController.gUserEmail = "John@hotmail.com"
                    BaseViewController.gUserPicURL = "https://scontent.xx.fbcdn.net/v/t1.0-1/c59.0.200.200/p200x200/10354686_10150004552801856_220367501106153455_n.jpg?oh=f621f9474a63f5b27b0514adda5db42b&oe=5B0F8625"
                    self.fetchUserInfoToServer()
                }
            })
        }
        else{
            // for test
            BaseViewController.gUserFBID = "18236724098093248"
            BaseViewController.gUserFirstName = "John"
            BaseViewController.gUserLastName = "Smith"
            BaseViewController.gUserEmail = "John@hotmail.com"
            BaseViewController.gUserPicURL = "https://scontent.xx.fbcdn.net/v/t1.0-1/c59.0.200.200/p200x200/10354686_10150004552801856_220367501106153455_n.jpg?oh=f621f9474a63f5b27b0514adda5db42b&oe=5B0F8625"
            fetchUserInfoToServer()
        }
    }
}

extension AccountViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        }
        else{
            return 65
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Account"
        }
        else {
            return "Hulp"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if (BaseViewController.gUserToken != "")
            {
                return 4
            }
            else
            {
                return 1
            }
            
        }
        else {
            return 5
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "myCell")
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        if indexPath.section == 0 {
            if (BaseViewController.gUserToken != "")
            {
                cell.textLabel?.text = titlesAccount[indexPath.row]
            }
            else {
                cell.textLabel?.text = "loggen"
            }
            
        }
        else {
            cell.textLabel?.text = titlesHelp[indexPath.row]
        }
        
        return cell
    }

}

extension AccountViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //Login
            
            if (BaseViewController.gUserToken != "")
            {
                switch indexPath.row {
                case 0:// Mijn cadeaukaarten
                    
                    break
                case 1:// Mijn uibetalingen
                    break
                case 2:// Profiel
                    self.modalViewController(id: Const.VC_PROFILE_ID, baseController: self)
                    break
                case 3:// Uitloggen
                    BaseViewController.gUserToken = ""
                    BaseViewController.gPrevVCID = Const.VC_HOME_ID
                    self.tblAccount.reloadData()
                    break
                default:// Uitloggen
                    BaseViewController.gUserToken = ""
                    BaseViewController.gPrevVCID = Const.VC_HOME_ID
                    self.tblAccount.reloadData()
                    break
                    
                }
            }
            else {
                let permission = ["public_profile", "email", "user_friends"]
                
                if (FBSDKAccessToken.current() != nil) {
                    getFacebookUserInfo()
                }else {
                    let fbLoginManager = FBSDKLoginManager.init()
                    fbLoginManager.logIn(withReadPermissions: permission, from: self, handler: { (result, error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        }else {
                            self.getFacebookUserInfo()
                        }
                    })
                }
            }
            
            //for test
            
            
        }
        else {
            switch indexPath.row {
            case 0:
                // Contact
                self.modalViewController(id: Const.VC_CONTACT_ID, baseController: self)
                break
            case 1:
                // FAQ
                self.modalViewController(id: Const.VC_FAQ_ID, baseController: self)
                break
            case 2:
                // About us
                self.modalViewController(id: Const.VC_ABOUT_ID, baseController: self)
                break
            case 3:
                // Terms and Conditions
                //BaseViewController.gPrevVCID = Const.VC_ACCOUNT_ID
                self.modalViewController(id: Const.VC_TERMCOND_ID, baseController: self)
                break
            case 4:
                // Privacy
                self.modalViewController(id: Const.VC_PRIVACY_ID, baseController: self)
                //self.modalViewController(id: Const.VC_PAYMENTWEB_ID, baseController: self)
                break
            default:
                break
            }
        }
        
        
        print(indexPath)
    }
}
