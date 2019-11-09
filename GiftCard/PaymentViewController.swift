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
import WebKit

class  PaymentViewController : BaseViewController {
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBrief: UIButton!
    @IBOutlet weak var btnPerson: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var wvReport: WKWebView!
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        //        btnBrief.isHighlighted = false
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.layer.add(transition, forKey: "rightToLeftTransition")
        BaseViewController.gPrevVCID = Const.VC_HOME_ID
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
    var pageHtml = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Toolbar
        btnHome.isHighlighted = true
        btnBrief.isHighlighted = true
        btnPerson.isHighlighted = false
        let url = NSURL(string: Const.SERVER_REMOTE_URL + Const.SERVER_PAYMENT_URL)
        let req = NSURLRequest.init(url: url! as URL)
        self.wvReport!.load(req as URLRequest)
        
       // fetchGetPrivacyFromServer()
    }
    
    func uiRefresh() {
        wvReport.loadHTMLString(pageHtml,
                                baseURL: nil)
    }
//    func  fetchGetPrivacyFromServer() {
//
//        let url = "http://192.168.12.177/GiftCard/public/api/privacy"
//        SVProgressHUD.show()
//        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
//            .responseJSON { response in
//                SVProgressHUD.dismiss()
//                if let status = response.response?.statusCode {
//                    switch(status){
//                    case 200:
//                        if let dic = response.result.value as? NSDictionary {
//                            if let report = dic.value(forKey: Const.KEY_RES_CONTENT) as? String
//                            {
//                                self.pageHtml = report
//                                self.uiRefresh()
    /*
     TaxiApp is communication system between passengers and taxi driver. Passenger simply press a button in a web based app and app as well, georeferencing him and showing that coordinate as a spot  in the drivers map (app based).
     I looked your Spec and I have some questions
     
     What do you want map shows detail inforamtion?
     For instance car track 
     
     Do you want detail map information
     
     1- When passenger press the “ask for taxi” button a spot, shows up all login drivers with in 1km?
     
     2- what means countdown?
     */
//                            }
//                            print(dic)
//
//                        }
//                        print("state success \(url)")
//                        break
//                    default:
//                        print("error with response status: \(status)")
//                        break
//                    }
//                }
//
//        }
//
//    }
}

