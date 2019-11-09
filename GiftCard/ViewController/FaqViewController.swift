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

class  FaqViewController : BaseViewController {

    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBrief: UIButton!
    @IBOutlet weak var btnPerson: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tblFaq: UITableView!
    
    
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

    @IBAction func onSearchTapped(_ sender: Any) {
        searchKey = tfSearch.text!
        fetchSendSellCardInfosToServer()
    }
    var aryFaq : NSArray?
    var searchKey = ""
    var expandIndex : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Toolbar
        btnHome.isHighlighted = true
        btnBrief.isHighlighted = true
        btnPerson.isHighlighted = false
        expandIndex = 0
        
        tblFaq.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblFaq.frame.size.width, height: 1))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView  = false
        self.view.addGestureRecognizer(tapGesture)
        fetchSendSellCardInfosToServer()
    }
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    func uiRefresh()
    {
        tblFaq.reloadData()
    }
    func fetchSendSellCardInfosToServer() {
        
        let url = Const.SERVER_REMOTE_URL + Const.SERVER_GETFAQ_URL
        let param = ["searchinfo" : ["searchkey" : searchKey]]
        print(param)
        SVProgressHUD.show()
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseJSON { response in
                SVProgressHUD.dismiss()
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let dic = response.result.value as? NSDictionary {
                            if let dict = dic.value(forKey: Const.KEY_RES_FAQ) as? NSArray
                            {
                                self.aryFaq = dict
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
                
        }
        
    }
}
extension FaqViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (expandIndex > 0)
        {
            expandIndex = 0
        }
        else{
            expandIndex = indexPath.row + 1
        }
        tblFaq.reloadData()
        print(indexPath)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Veelgestelde vragen"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cnt = aryFaq?.count {
            if expandIndex > 0 {
                return cnt + 1
            }
            return cnt
            
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((expandIndex != 0) && (expandIndex == indexPath.row))
        {
            
            return 101
        }
        else{
            return 74
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ((expandIndex != 0) && (expandIndex == indexPath.row))
        {
            tblFaq.register(UINib.init(nibName: "FaqSubTblCell", bundle: nil), forCellReuseIdentifier: "FaqSubTblCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "FaqSubTblCell") as! FaqSubTblCell
            let dic = aryFaq?[indexPath.row - 1] as! NSDictionary
            cell.lblAnswer.text = dic.value(forKey: Const.KEY_RES_ANSWER) as? String
            return cell
        }
        else
        {
            tblFaq.register(UINib.init(nibName: "FaqTblCell", bundle: nil), forCellReuseIdentifier: "FaqTblCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "FaqTblCell") as! FaqTblCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            var dic : NSDictionary = NSDictionary.init()
            if ((indexPath.row < expandIndex) || (expandIndex == 0))
            {
                dic = aryFaq?[indexPath.row] as! NSDictionary
            }
            else {
                dic = aryFaq?[indexPath.row - 1] as! NSDictionary
            }
            
                cell.lblQuestion.text = dic.value(forKey: Const.KEY_RES_QUESTION) as? String
            
            return cell
        }
        
        

    }
}
