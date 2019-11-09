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

class SellCardInfoViewController : BaseViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBrief: UIButton!
    @IBOutlet weak var btnPerson: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblScanCard: UITableView!
    @IBOutlet weak var IvPopUp: UIView!
    @IBOutlet weak var datePick: UIDatePicker!
    @IBOutlet weak var tfCardNumber: UITextField!
    @IBOutlet weak var tfPinCode: UITextField!
    @IBOutlet weak var pinCodeView: UIView!
    
    @IBOutlet weak var lvPlaceholder: UILabel!
    
    
    @IBAction func onCheckTapped(_ sender: Any) {
        if (tfCardNumber.text! != "")
        {
            BaseViewController.gSellCardNo = tfCardNumber.text!
            BaseViewController.gSellCardPinCode = tfPinCode.text!
            fetchGetCardInfosFromServer()
        }
        else
        {
            SVProgressHUD.showInfo(withStatus: "Input card number.")
        }
    }
    
    @IBAction func onPopUpTapped(_ sender: Any) {
        IvPopUp.isHidden = true

        let formatter = DateFormatter.init()
        formatter.dateFormat = "dd-MM-yyyy"
        BaseViewController.gSellCardExpire = formatter.string(from: datePick.date)
        var cell = tblScanCard.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! ScanCardInfoTblCell
        BaseViewController.gSellCardValue = cell.tfDetail.text!
        cell = tblScanCard.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! ScanCardInfoTblCell
        BaseViewController.gSellCardSellCost = cell.tfDetail.text!
        tblScanCard.reloadData()
    }

    let cardInfoTitle = ["Brand", "Value", "Expires on", "Your Selling Price"]
    let cardTypes = ["Bol.com", "H & M", "Douglas", "Media Markt"]
    
    @IBAction func btnBackTapped(_ sender: Any) {
//        btnBrief.isHighlighted = false
      
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.layer.add(transition, forKey: "rightToLeftTransition")
         self.modalViewController(id: Const.VC_CHOOSE_ID, baseController: self)
    }
    
    @IBAction func btnNextStepTapped(_ sender: Any) {
        var cell = tblScanCard.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! ScanCardInfoTblCell
        BaseViewController.gSellCardValue = cell.tfDetail.text!
        cell = tblScanCard.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! ScanCardInfoTblCell
        BaseViewController.gSellCardExpire = cell.tfDetail.text!
        cell = tblScanCard.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! ScanCardInfoTblCell
        BaseViewController.gSellCardSellCost = cell.tfDetail.text!
        
       
        if tfCardNumber.text != "" {
            BaseViewController.gSellCardNo = tfCardNumber.text!
            if let value = Float.init(BaseViewController.gSellCardValue) {
                if (value > 0)
                {
                    if BaseViewController.gSellCardExpire != "" {
                        if let sellCost = Float.init(BaseViewController.gSellCardSellCost) {
                            if (sellCost > 0)
                            {
                                if (sellCost > value)
                                {
                                    SVProgressHUD.showInfo(withStatus: "Selling price must be less than value.")
                                }
                                else {
                                 self.modalViewController(id: Const.VC_SELLCARD_ID, baseController: self)
                                }
                            }
                            else
                            {
                                SVProgressHUD.showInfo(withStatus: "Please input sellcost")
                            }
                        }
                        else {
                            SVProgressHUD.showInfo(withStatus: "Please input sellcost")
                        }
                    }
                    else
                    {
                        SVProgressHUD.showInfo(withStatus: "Please input expires day")
                    }
                }
                else
                {
                    SVProgressHUD.showInfo(withStatus: "Please click check.")
                }
            }
            else
            {
                SVProgressHUD.showInfo(withStatus: "Please click check.")
            }
            
           
        }
        else {
             SVProgressHUD.showInfo(withStatus: "Please input card Number.")
        }
        
        
    }
    @IBAction func btnCameraTapped(_ sender: Any) {
        BaseViewController.gSellCardNo = ""
        var cell = tblScanCard.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! ScanCardInfoTblCell
        BaseViewController.gSellCardValue = cell.tfDetail.text!
        cell = tblScanCard.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! ScanCardInfoTblCell
        BaseViewController.gSellCardExpire = cell.tfDetail.text!
        cell = tblScanCard.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! ScanCardInfoTblCell
        BaseViewController.gSellCardSellCost = cell.tfDetail.text!
        BaseViewController.gSellCardPinCode = tfPinCode.text!
        self.modalViewController(id: Const.VC_BARCORD_ID, baseController: self)
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
            BaseViewController.gPrevVCID = Const.VC_SCANCARD_ID
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
        
        tblScanCard.backgroundColor = UIColor.clear
        tfPinCode.delegate = self
        tfPinCode.keyboardType = .numberPad
        tfPinCode.text = BaseViewController.gSellCardPinCode
        IvPopUp.isHidden = true
        datePick.backgroundColor = UIColor.white
        //remove last lines from table
        tblScanCard.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblScanCard.frame.size.width, height: 1))
        if (BaseViewController.gCardTypes != nil)
        {
            BaseViewController.gSellCardBrand =  (BaseViewController.gCardTypes?[0] as! NSDictionary).value(forKey: Const.KEY_BRAND) as! String
            BaseViewController.gSellCardType = (BaseViewController.gCardTypes?[0] as! NSDictionary).value(forKey: Const.KEY_CARDTYPE) as! String
            pinCodeView.isHidden = true
        }
        if BaseViewController.gSellCardNo != "" {
            lvPlaceholder.isHidden = true
        }
        else {
            lvPlaceholder.isHidden = false
        }
                tfCardNumber.text = BaseViewController.gSellCardNo
        
        tfCardNumber.keyboardType = .numberPad
        tfCardNumber.delegate = self
        
        //        lblConfirmEmail.text = "After payment has ben made. we'll send the confirmation and the gift to ".appending("")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView  = false
        self.view.addGestureRecognizer(tapGesture)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfCardNumber {
            lvPlaceholder.isHidden = true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text == "")
        {
            lvPlaceholder.isHidden = false
        }
        else
        {
            lvPlaceholder.isHidden = true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            if textField == tfPinCode{
               return !(textField.text?.characters.count == 10 && string != "")
            }
        else if textField == tfCardNumber {
            return !(textField.text?.characters.count == 25 && string != "")
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
    func fetchGetCardInfosFromServer() {
        
        let url = Const.SERVER_REMOTE_URL + Const.SERVER_GETBALANCE_URL
        
        let param = [
                    Const.KEY_SELLCARDNO: BaseViewController.gSellCardNo,
                    Const.KEY_PINCODE: BaseViewController.gSellCardPinCode,
                    Const.KEY_FBID : BaseViewController.gUserFBID,
                    Const.KEY_TOKEN : BaseViewController.gUserToken,
                    Const.KEY_CARDTYPE : BaseViewController.gSellCardType
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
                            if let dict = dic.value(forKey: Const.KEY_RES_CHECKRSULT) as? NSDictionary
                            {
                                if (dict.count != 0)
                                {
                                    if ((dict.value(forKey: Const.KEY_RES_STATUS) as? String) == Const.KEY_RES_SUCCESS)
                                    {
                                        // Success
                                        if let value = dict.value(forKey: Const.KEY_VALUE) as? String
                                        {
                                            BaseViewController.gSellCardValue = value
                                        }
                                        if let expire = dict.value(forKey: Const.KEY_EXPIRES) as? String
                                        {
                                            BaseViewController.gSellCardExpire = expire
                                        }
                                        self.tblScanCard.reloadData()
                                    }
                                    else
                                    {
                                        SVProgressHUD.showError(withStatus: "card check failed")
                                    }
                                }
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

extension SellCardInfoViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Card Information"
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0)
        {
            tblScanCard.register(UINib.init(nibName: "ScanCardBrandTblCell", bundle: nil), forCellReuseIdentifier: "ScanCardBrandTblCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScanCardBrandTblCell") as! ScanCardBrandTblCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.lblTitle?.text = cardInfoTitle[indexPath.row]
            cell.pickBrand.delegate = self
            cell.pickBrand.dataSource = self
            
            return cell
        }
        else{
            tblScanCard.register(UINib.init(nibName: "ScanCardInfoTblCell", bundle: nil), forCellReuseIdentifier: "ScanCardInfoTblCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScanCardInfoTblCell") as! ScanCardInfoTblCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.lblTitle?.text = cardInfoTitle[indexPath.row]
            
            cell.tfDetail.keyboardType = .asciiCapableNumberPad
            
            if (indexPath.row == 2) {
                cell.tfDetail.isEnabled = false
                cell.tfDetail.isEnabled = false
                cell.tfDetail.text = BaseViewController.gSellCardExpire
            }
            else if(indexPath.row == 1)
            {
                cell.tfDetail.isEnabled = false
                cell.tfDetail.text = BaseViewController.gSellCardValue
            }
            else if(indexPath.row == 3)
            {
                cell.tfDetail.text = BaseViewController.gSellCardSellCost
            }
            
            return cell
        }
       
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == 2) {
            IvPopUp.isHidden = false
        }
        print(indexPath)
        
    }
}
extension SellCardInfoViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.textColor = UIColor.black
        label.textAlignment = .right
        label.font = UIFont(name: "System", size: 21.0)
        if ( BaseViewController.gCardTypes != nil)
        {
            label.text =  (BaseViewController.gCardTypes?[row] as! NSDictionary).value(forKey: Const.KEY_BRAND) as? String
        }
        else  {
            label.text =  ""
        }
        
        
        return label
    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return cardTypes[row]
//    }
//    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        BaseViewController.gSellCardBrand =  (BaseViewController.gCardTypes?[row] as! NSDictionary).value(forKey: Const.KEY_BRAND) as! String
        BaseViewController.gSellCardType = (BaseViewController.gCardTypes?[row] as! NSDictionary).value(forKey: Const.KEY_CARDTYPE) as! String
        if ((BaseViewController.gSellCardType == "2") || (BaseViewController.gSellCardType == "4")){
            pinCodeView.isHidden = false
        }
        else
        {
            pinCodeView.isHidden = true
            tfPinCode.text = ""
        }
        BaseViewController.gSellCardValue = ""
        BaseViewController.gSellCardExpire = ""
        tblScanCard.reloadData()
        print(row)
    }
}
