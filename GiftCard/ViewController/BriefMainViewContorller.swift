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

class BriefMainViewController : BaseViewController {
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBrief: UIButton!
    @IBOutlet weak var btnPerson: UIButton!
    
    @IBOutlet weak var tblPerson: UITableView!
    @IBOutlet weak var tfSearch: UITextField!

    var arySellerInfos : NSArray?
    var aryCardInfo : NSDictionary!
    @IBAction func btnBackTapped(_ sender: Any) {
        btnBrief.isHighlighted = false
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.layer.add(transition, forKey: "rightToLeftTransition")
        self.modalViewController(id: Const.VC_HOME_ID, baseController: self)
    }
    @IBAction func onSearchTapped(_ sender: Any) {
        BaseViewController.gSearchKey = tfSearch.text
        BaseViewController.gSelectCardType = 0
        fetchGetSellerInfosFromServer()
    }
    @IBAction func onCartTapped(_ sender: Any) {
        BaseViewController.gPrevVCID = Const.VC_MARKET_ID
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
            
            break
        case 2:
            BaseViewController.gPrevVCID = Const.VC_MARKET_ID
            self.modalViewController(id: Const.VC_ACCOUNT_ID, baseController: self)
            break
        default:
            btnHome.isHighlighted = false
        }
    }
    
    let reuseIdentifier = "PersonTblCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Toolbar
        btnHome.isHighlighted = true
        btnBrief.isHighlighted = false
        btnPerson.isHighlighted = true
        tblPerson.register(UINib.init(nibName: "PersonTblCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tblPerson.backgroundColor = UIColor.clear
   
        
        //remove last lines from table
        tblPerson.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblPerson.frame.size.width, height: 1))
        fetchGetSellerInfosFromServer()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView  = false
        self.view.addGestureRecognizer(tapGesture)
        
        
    }
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        //tfSearch.resignFirstResponder()
        view.endEditing(true)
    }
    func uiRefresh() {
        
            insertFieldSellerInfo(initval: "1", key: Const.KEY_ISCART, arry: BaseViewController.gSellerInfos!)
            tblPerson.reloadData()
        
    }
    func fetchGetSellerInfosFromServer() {
        
        let url = Const.SERVER_REMOTE_URL +  Const.SERVER_GETSELLERINFO_URL
        let param = [
            "searchinfo" :
                [
                    "searchkey": BaseViewController.gSearchKey!,
                    "cardtype": BaseViewController.gSelectCardType!,
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
                            let dict = dic.copy() as! NSDictionary
                            if (dict.count != 0)
                            {
                            BaseViewController.gSellerInfos = dict.value(forKey: Const.KEY_SELLERINFOS) as? NSArray
                            //self.insertFieldSellerInfo(initval: "1", key: Const.KEY_ISCART, arry: BaseViewController.gSellerInfos!)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension BriefMainViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cnt = BaseViewController.gSellerInfos?.count
        {
            return cnt
        }else {
           return 0
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        print(indexPath)
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print(sourceIndexPath)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTblCell") as! PersonTblCell
               cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.clear
        let dic = BaseViewController.gSellerInfos?[indexPath.row] as! NSDictionary
        
        cell.ivProfile.sd_setShowActivityIndicatorView(true)
        cell.ivProfile.sd_setIndicatorStyle(.gray)
        cell.ivProfile.sd_setImage(with: URL(string: dic.value(forKey: Const.KEY_AVATAR) as! String), placeholderImage: UIImage(named: "Userpic"))

        cell.lblName.text = dic.value(forKey: Const.KEY_NAME)  as? String
        cell.lblTime.text = "Expires ".appending((dic.value(forKey: Const.KEY_EXPIRES) as? String)!)
        cell.lblTotalPrice.text = "€ ".appending((dic.value(forKey: Const.KEY_TOTALPRICE) as? String)!)
        cell.lblPrice.text = "€ ".appending((dic.value(forKey: Const.KEY_VALUE) as? String)!)
        cell.lblBrand.text = (dic.value(forKey: Const.KEY_BRAND) as? String)?.appending(" Gift Card")
        cell.delegate = self
        cell.tblIndexPath = indexPath
        
       // let isCart = NSNumber.init(value: Int.init(dic.value(forKey: Const.KEY_CARDID) as! String)!)
        
        cell.btnCart.isHidden = Bool.init(!self.isInCart(cardId: dic.value(forKey: Const.KEY_CARDID) as! String))//0 show 1 hide
        
        return cell
    }
    
}


extension BriefMainViewController : PersonTblDelegate {

    func didViewTapped(indexPath: IndexPath) {
        BaseViewController.gSelectSellerIndex = indexPath.row
        self.modalViewController(id: Const.VC_SELLERINFO_ID, baseController: self)
    }
}

