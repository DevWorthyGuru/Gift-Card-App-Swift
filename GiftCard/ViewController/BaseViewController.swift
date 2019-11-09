//
//  BaseViewController.swift
//  GiftCard
//
//  Created by Apple on 2/2/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit
class BaseViewController: UIViewController {

    static var gAryCardInfos : NSDictionary?
    static var gUserType : Int?
    static var gSelectCardType : Int? = 0
    static var gSellerInfos : NSArray?
    static var gCartInfo : NSArray? = []
    static var gSelectSellerIndex : Int?
    static var gSelCardInfo: NSDictionary?
    static var gSearchKey : String? = ""
    static var gSelCardID = ""
    static var gSelCardType = ""
    static var gCardTypes : NSArray?
    static var gPayPostCode = ""
    static var gPayHomeNo = ""
    
    static var gSellCardNo = ""
    static var gSellCardPinCode = ""
    static var gSellCardBrand = ""
    static var gSellCardValue = ""
    static var gSellCardExpire = ""
    static var gSellCardSellCost = ""
    static var gSellCardType = ""
    
    static var gUserFBID = ""
    static var gUserToken = ""
    static var gUserFirstName = ""
    static var gUserLastName = ""
    static var gUserPicURL = ""
    static var gUserEmail = ""
    static var gUserChagneEmail = ""
    
    
    static var gPrevVCID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func initUserInfo()
    {
        BaseViewController.gUserEmail = ""
        BaseViewController.gUserChagneEmail = ""
        BaseViewController.gUserToken = ""
        BaseViewController.gUserFBID = ""
        BaseViewController.gUserLastName = ""
        BaseViewController.gUserFirstName = ""
        BaseViewController.gUserPicURL = ""
    }
    public func isInCart(cardId: String) -> Bool {
        if BaseViewController.gCartInfo != nil {
        for cartInfoItem in BaseViewController.gCartInfo! {
            let dic = cartInfoItem as! NSDictionary
            if (dic.value(forKey: Const.KEY_CARDID) as! String) == cardId {
                return true
            }
          }
        }
        return false
    }
    public func addInCart(cardInfo : NSDictionary) {
        var cartInfo = NSMutableArray.init()
        if BaseViewController.gCartInfo != nil{
            cartInfo = BaseViewController.gCartInfo?.mutableCopy() as! NSMutableArray
            if (!isInCart(cardId: cardInfo.value(forKey: Const.KEY_CARDID) as! String))
            {
                cartInfo.add(cardInfo)
                BaseViewController.gCartInfo = cartInfo.copy() as? NSArray
            }
        }
        else{
            cartInfo.add(cardInfo)
            BaseViewController.gCartInfo = cartInfo.copy() as? NSArray
        }
        
    }
    public func removeInCart(cardId : String) {
        let cartInfo = BaseViewController.gCartInfo?.mutableCopy() as! NSMutableArray
        var i : Int = 0
        for cartInfoItem in cartInfo {
            let dic = cartInfoItem as! NSDictionary
            if (dic.value(forKey: Const.KEY_CARDID) as! String) == cardId {
               cartInfo.removeObject(at: i)
                BaseViewController.gCartInfo = cartInfo.copy() as? NSArray
                return
            }
            i = i + 1
        }
        
    }
    public func isValidEmail(email:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailCheck.evaluate(with: email)
    }
    public func modalViewController(id : String, baseController : BaseViewController){
       
        switch id {
        case Const.VC_HOME_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: Const.VC_HOME_ID) as! HomeViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            
            break
        case Const.VC_CHOOSE_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: Const.VC_CHOOSE_ID) as! BriefViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromTop
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
           UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            
            break
        case Const.VC_MARKET_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: id) as! BriefMainViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
           
            break
        case Const.VC_SELLERINFO_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: id) as! BriefDetailViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransition
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            //present(VC, animated: false, completion: nil)
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            break
        case Const.VC_PAY_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: id) as! BriefPaymentViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            
            break
        case Const.VC_ACCOUNT_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: id) as! AccountViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            
            break
        case Const.VC_SCANCARD_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: id) as! SellCardInfoViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            break
        case Const.VC_SELLCARD_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: id) as! SellCardViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            break
        case Const.VC_FAQ_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: id) as! FaqViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            break
        case Const.VC_TERMCOND_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: id) as! TermsAndConditionViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            break
        case Const.VC_CONTACT_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: id) as! ContactViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            break
        case Const.VC_PRIVACY_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: id) as! PrivacyViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            break
        
        case Const.VC_ABOUT_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: id) as! AboutUsViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            break
        case Const.VC_BARCORD_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: id) as! BarCodeViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            break
        case Const.VC_PAYMENTWEB_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: id) as! PaymentViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            break
        case Const.VC_PROFILE_ID:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: id) as! ProfileViewController
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            break
        default:
            dismiss(animated: false, completion: nil)
            let VC = baseController.storyboard?.instantiateViewController(withIdentifier: Const.VC_HOME_ID) as! HomeViewController
            VC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            UIApplication.shared.keyWindow?.rootViewController?.present(VC, animated: false, completion: nil)
            break
        }
        
        
    }
    
    public func setSellerInfo(val : String, key : String, index : Int){
        var ary = NSMutableArray.init()
        ary = BaseViewController.gSellerInfos?.mutableCopy() as! NSMutableArray
        let dic = ary[index] as! NSDictionary
        var newdic = NSMutableDictionary.init()
        newdic = dic.mutableCopy() as! NSMutableDictionary
        newdic.setValue(val, forKey: key)
        ary.removeObject(at: index)
        ary.insert(newdic.copy() as! NSDictionary, at: index)
        BaseViewController.gSellerInfos = ary.copy() as? NSArray
    }
    func insertFieldSellerInfo(initval : String, key : String, arry : NSArray){
        let ary = NSMutableArray.init()
        for aryitem  in arry {
            let dic = aryitem as! NSDictionary
            var newDic = NSMutableDictionary.init()
            newDic = dic.mutableCopy() as! NSMutableDictionary
            newDic.setValue(initval, forKey: key)
            let dicitem = newDic.copy() as! NSDictionary
            ary.add(dicitem)
        }
        BaseViewController.gSellerInfos = ary.copy() as? NSArray
    }
}
