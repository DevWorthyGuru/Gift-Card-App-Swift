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
import DeviceCheck

class  ProfileViewController : BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBrief: UIButton!
    @IBOutlet weak var btnPerson: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
  
    
    @IBOutlet weak var lvName: UILabel!
    
    @IBOutlet weak var tfNumber: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        //        btnBrief.isHighlighted = false
        
        
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
        lvName.text = BaseViewController.gUserFirstName.appending(" ") .appending(BaseViewController.gUserLastName)
        tfEmail.placeholder = BaseViewController.gUserEmail
        tfName.placeholder = BaseViewController.gUserFirstName.appending(" ") .appending(BaseViewController.gUserLastName)
        tfName.delegate = self
        tfEmail.delegate = self
        tfNumber.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        tapGesture.cancelsTouchesInView  = false
        self.view.addGestureRecognizer(tapGesture)
//        pvNumber.placeholder = BaseViewController.
       // fetchGetContactFromServer()
        
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if(UIDevice.current.systemVersion >= "7.0") {
//            self.automaticallyAdjustsScrollViewInsets = false; // Avoid the top UITextView space, iOS7 (~bug?)
//        }
//        pvNumber.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if(UIDevice.current.systemVersion >= "7.0") {
//            self.automaticallyAdjustsScrollViewInsets = true; // Avoid the top UITextView space, iOS7 (~bug?)
//        }
//        pvNumber.removeObserver(self, forKeyPath: "contentSize")
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        let textView = object as! UITextView
//        var topCorrect = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale) / 2
//        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
//        textView.contentInset.top = topCorrect
//    }

    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         return !(textField.text?.characters.count == 30 && string != "")
    }
    func uiRefresh() {
        
    }
    func fetchGetContactFromServer() {
        
        let url = Const.SERVER_REMOTE_URL + Const.SERVER_TERMS_URL
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                SVProgressHUD.dismiss()
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let dic = response.result.value as? NSDictionary {
                            if let report = dic.value(forKey: Const.KEY_RES_CONTENT) as? String
                            {
                                self.pageHtml = report
                                self.uiRefresh()
                            }
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

