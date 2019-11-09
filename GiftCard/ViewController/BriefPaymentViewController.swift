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
import SafariServices

class BriefPaymentViewController : BaseViewController, UITextFieldDelegate {
    
    var aryCart : NSArray?
    var price : Float = 0
    var expandIndex : Int = 0
    
    @IBOutlet weak var tfPostCode: UITextField!
    @IBOutlet weak var tfHouseNo: UITextField!
    
    var postCode : String?
    var houseNo : String?
    var transID : String?
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBrief: UIButton!
    @IBOutlet weak var btnPerson: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var tfEmail: UITextField!

    @IBOutlet weak var tblPayment: UITableView!
    
    @IBOutlet weak var btnPayNow: UIButton!
    @IBOutlet weak var lblConfirmEmail: UILabel!
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBAction func onPopViewTapped(_ sender: Any) {
        popView.isHidden = true
    }
    @IBAction func onOKTapped(_ sender: Any) {
        if (self.isValidEmail(email: tfEmail.text!) && (tfEmail.text != "")) {
            popView.isHidden = true
            BaseViewController.gUserChagneEmail = tfEmail.text!
            lblConfirmEmail.text = "Na de betling sturen we een bevestiging naar ".appending(BaseViewController.gUserChagneEmail)
        }
        else {
            SVProgressHUD.showInfo(withStatus: "Please input Email address.")
        }
    }
    
    @IBAction func onChangeEmailTapped(_ sender: Any) {
        popView.isHidden = false
        tfEmail.placeholder = BaseViewController.gUserEmail
    }

    @IBAction func onPaynowTapped(_ sender: Any) {
        if price > 0 {
            if tfHouseNo.text != ""
            {
                if (tfPostCode.text != "")
                {
                    houseNo = tfHouseNo.text
                    postCode = tfPostCode.text
                    fetchSendPaymentInfosToServer()
                 //   btnPayNow.isEnabled = false
                    
                }
                else {
                    SVProgressHUD.showInfo(withStatus: "Please input postcode.")
                }
            }
            else {
                SVProgressHUD.showInfo(withStatus: "Please input house number")
            }
        }
        else {
            SVProgressHUD.showInfo(withStatus: "You are not seleted card.")
        }
    }

    @IBAction func btnBackTapped(_ sender: Any) {
        btnBrief.isHighlighted = false
        
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.layer.add(transition, forKey: "rightToLeftTransition")
        self.modalViewController(id: Const.VC_MARKET_ID, baseController: self)
       
    }
    @IBAction func onTermsTapped(_ sender: Any) {
        BaseViewController.gPayHomeNo = tfHouseNo.text!
        BaseViewController.gPayPostCode = tfPostCode.text!
        BaseViewController.gPrevVCID = Const.VC_PAY_ID
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
            BaseViewController.gPrevVCID = Const.VC_PAY_ID
            self.modalViewController(id: Const.VC_ACCOUNT_ID, baseController: self)
            break
        default:
            btnHome.isHighlighted = false
        }
    }
    
    let reuseIdentifier = "PaymentTblCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Toolbar
        btnHome.isHighlighted = true
        btnBrief.isHighlighted = false
        btnPerson.isHighlighted = true
        btnPayNow.isEnabled = true
        expandIndex = 0
        
        if BaseViewController.gCartInfo?.count == 0 || BaseViewController.gCartInfo?.count == nil {
            emptyView.isHidden = false
        }
        else
        {
            emptyView.isHidden = true
        }
        
        lblTotalPrice.text = "€ 0.00"
        tfHouseNo.text = BaseViewController.gPayHomeNo
        tfPostCode.text = BaseViewController.gPayPostCode
        lblConfirmEmail.text = "Na de betaling sturen we een bevestinging naar  ".appending(BaseViewController.gUserEmail)
        tblPayment.register(UINib.init(nibName: "PaymentTblCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tblPayment.backgroundColor = UIColor.clear
        //remove last lines from table
        tblPayment.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblPayment.frame.size.width, height: 1))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView  = false
        self.view.addGestureRecognizer(tapGesture)
        mainScrollView.contentSize = CGSize.init(width: 320, height: 900)
        mainScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        popView.isHidden = true
        tfPostCode.delegate = self
        tfHouseNo.delegate = self

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tfPostCode {
            return !(textField.text?.characters.count == 6 && string != "")
        }
        else if textField == tfHouseNo {
            return !(textField.text?.characters.count == 2 && string != "")
        }
        return true
    }
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
//        tfHouseNo.endEditing(true)
//        tfPostCode.endEditing(true)
//        tfEmail.endEditing(true)
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchSendPaymentInfosToServer() {
        
        let url = Const.SERVER_REMOTE_URL + Const.SERVER_POSTORDER_URL
        var cartInfoIds : [String] = []
        for cartitem in BaseViewController.gCartInfo! {
            let dic = cartitem as! NSDictionary
         
            cartInfoIds.append(dic.value(forKey: Const.KEY_CARDID) as! String)
        }
        var email = ""
        if BaseViewController.gUserChagneEmail != "" {
            email = BaseViewController.gUserChagneEmail
        }
        else {
            email = BaseViewController.gUserEmail
        }
        let param = [
            Const.KEY_PAYINFOS : cartInfoIds,
            Const.KEY_POSTCODE : postCode!,
            Const.KEY_HOUSENO : houseNo!,
            Const.KEY_EMAIL : email,
            Const.KEY_FBID : BaseViewController.gUserFBID,
            Const.KEY_FIRSTNAME : BaseViewController.gUserFirstName,
            Const.KEY_LASTNAME : BaseViewController.gUserLastName,
            Const.KEY_USRPICURL : BaseViewController.gUserPicURL,
            Const.KEY_TOKEN : BaseViewController.gUserToken,
            Const.KEY_TOTALPRICE : String.init(format: "%.2f", price)
        ] as [String : Any]
        print(param)
        SVProgressHUD.show()
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let dic = response.result.value as? NSDictionary {
                            if let dict = dic.value(forKey: Const.KEY_RES_ORDERRESULT) as? NSDictionary
                            {
                                if (dict.value(forKey: Const.KEY_RES_STATUS)as! String) == Const.KEY_RES_SUCCESS
                                {
                                     SVProgressHUD.showSuccess(withStatus: "Success.")
                                    self.transID = dict.value(forKey: Const.KEY_RES_TRANSID) as? String
                                    self.success(transID: self.transID!)
                                }
                            }
                            print(dic)
                        }
                        print("state success \(url)")
                        break
                    default:
                        print("error with response status: \(status)")
                        SVProgressHUD.showError(withStatus: "Failed.")
                        break
                    }
                }
                else
                {
                    SVProgressHUD.dismiss()
                }
                
                self.uiRefresh()
        }
        
    }
    func fetchGetPaymentStatefromServer() {
        
        let url = Const.SERVER_REMOTE_URL + Const.SERVER_GETTRANSSTATUS
        var cartInfoIds : [String] = []
        for cartitem in BaseViewController.gCartInfo! {
            let dic = cartitem as! NSDictionary
            
            cartInfoIds.append(dic.value(forKey: Const.KEY_CARDID) as! String)
        }
        var email = ""
        if BaseViewController.gUserChagneEmail != "" {
            email = BaseViewController.gUserChagneEmail
        }
        else {
            email = BaseViewController.gUserEmail
        }
        let param = [
            Const.KEY_TRANSID : self.transID!,
            Const.KEY_TOKEN : BaseViewController.gUserToken
            ] as [String : Any]
        print(param)
        SVProgressHUD.show()
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let dic = response.result.value as? NSDictionary {
                            if let dict = dic.value(forKey: Const.KEY_RES_TRANSINFO) as? NSDictionary
                            {
                                if (dict.value(forKey: Const.KEY_RES_STATUS)as! String) == Const.KEY_RES_SUCCESS
                                {
                                    SVProgressHUD.showSuccess(withStatus: "Success.")
                                    
                                    self.paymentSuccess()
                                }
                                else
                                {
                                    SVProgressHUD.dismiss()
                                    self.uiRefresh()
                                }
                            }
                            print(dic)
                        }
                        print("state success \(url)")
                        break
                    default:
                        print("error with response status: \(status)")
                        SVProgressHUD.showError(withStatus: "Failed.")
                        break
                    }
                }
                else
                {
                    SVProgressHUD.dismiss()
                }
                
                self.uiRefresh()
        }
        
    }
    func success(transID : String){
      
        let url = URL(string: Const.SERVER_REMOTE_URL + "payment/" + transID)!
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
        controller.delegate = self
    }
    func paymentSuccess(){
          BaseViewController.gCartInfo = nil
          lblTotalPrice.text = "€ 0.0"
         self.modalViewController(id: Const.VC_MARKET_ID, baseController: self)
         BaseViewController.gPayHomeNo = ""
         BaseViewController.gPayPostCode = ""
        BaseViewController.gSearchKey = ""
    }
    func uiRefresh()
    {
        btnPayNow.isEnabled = true
    }
}
extension BriefPaymentViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if BaseViewController.gCartInfo != nil {
            aryCart = BaseViewController.gCartInfo?.copy() as? NSArray
            if let cnt = aryCart?.count
            {
                var count = cnt
                if expandIndex > 0 {
                    count = count + 1
                }
                return count
            }else {
                return 0
            }
        }
        return 0
    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "myHeaderCell")
//        cell.backgroundColor = UIColor.white
//        cell.textLabel?.text = ""
//        cell.textLabel?.font = lblTotalPrice.font
//        cell.textLabel?.font.withSize(22.0)
//        return cell
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Card Information"
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((expandIndex != 0) && (expandIndex == indexPath.row))
        {
            
            return 151
        }
        else{
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ((expandIndex != 0) && (expandIndex == indexPath.row))
            {
                tblPayment.register(UINib.init(nibName: "PaymentSubTblCell", bundle: nil), forCellReuseIdentifier: "PaymentSubTblCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentSubTblCell") as! PaymentSubTblCell
                let dic = aryCart?[expandIndex - 1] as! NSDictionary
                
                cell.lblBrand.text = dic.value(forKey: Const.KEY_BRAND) as? String
                cell.lblValue.text = "€ ".appending((dic.value(forKey: Const.KEY_VALUE) as? String)!)
                cell.lblTransCost.text = "€ ".appending((dic.value(forKey: Const.KEY_TRANSCOST) as? String)!)
                cell.lblPayingPrice.text = "€ ".appending((dic.value(forKey: Const.KEY_TOTALPRICE) as? String)!)
                cell.lblServiceCost.text = "€ ".appending((dic.value(forKey: Const.KEY_SERVICECOST) as? String)!)
                return cell
                
        }
        else{
            if indexPath.row == 0 {price = 0}
            tblPayment.register(UINib.init(nibName: "PaymentTblCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTblCell") as! PaymentTblCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.backgroundColor = UIColor.clear
            var dic : NSDictionary = NSDictionary.init()
            if ((indexPath.row < expandIndex) || (expandIndex == 0))
            {
                 dic = aryCart?[indexPath.row] as! NSDictionary
            }
            else {
                 dic = aryCart?[indexPath.row - 1] as! NSDictionary
            }
            
            
            cell.lblBrand.text = (dic.value(forKey: Const.KEY_BRAND) as? String)!.appending(" € ").appending((dic.value(forKey: Const.KEY_VALUE) as? String)!)
            
            price = price + Float.init(dic.value(forKey: Const.KEY_TOTALPRICE) as! String)!
            cell.lblTotalPrice.text = "€ ".appending((dic.value(forKey: Const.KEY_TOTALPRICE) as? String)!)
            cell.lblExpires.text = "Expires ".appending((dic.value(forKey: Const.KEY_EXPIRES) as? String)!)
            if indexPath.row == ((aryCart?.count)! - 1) {
            lblTotalPrice.text = "€ ".appending(String.init(price))
            
            }
            if indexPath.row == expandIndex - 1 {
                cell.ivUp.isHidden = false
                cell.ivDown.isHidden = true
            }
            else
            {
                cell.ivUp.isHidden = true
                cell.ivDown.isHidden = false
            }
            
            return cell
            }
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
           
            if ((expandIndex != 0) && (expandIndex == indexPath.row))
            {
                expandIndex = 0
            }
            else {
                let dic = aryCart?[indexPath.row] as! NSDictionary
                let cardID = dic.value(forKey: Const.KEY_CARDID) as! String
                self.removeInCart(cardId: cardID)
                lblTotalPrice.text = "€ 0.00"
                expandIndex = 0
                if BaseViewController.gCartInfo?.count == 0 || BaseViewController.gCartInfo?.count == nil {
                    emptyView.isHidden = false
                }
                else
                {
                    emptyView.isHidden = true
                }

            }
            
                        tblPayment.reloadData()
//            BaseViewController.setSellerInfo(val: "1", key : Const.KEY_ISCART, index : delindex!)
            print(indexPath)
            
        }
    }
    
    
}
extension BriefPaymentViewController : SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
        fetchGetPaymentStatefromServer()
    }
}
extension BriefPaymentViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (expandIndex > 0)
        {
            expandIndex = 0
        }
        else{
            expandIndex = indexPath.row + 1
        }
        tblPayment.reloadData()
        print(indexPath)
    }
}

