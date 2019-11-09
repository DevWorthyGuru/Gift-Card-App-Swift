//
//  Const.swift
//  KindWorker
//
//  Created by NaSalRyo on 19/10/2017.
//  Copyright © 2017 NaSalRyo. All rights reserved.
//

import UIKit


class Const: NSObject {
    
    // Sever URL
    static let SERVER_REMOTE_URL = "http://eb315stackk.eu-west-3.elasticbeanstalk.com/"
    //"http://192.168.12.177/GiftCard/public/"////
    static let SERVER_ABOUTUS_URL = "api/aboutus"
    static let SERVER_POSTLOGIN_URL = "api/postLogin"
    static let SERVER_GETSELLERINFO_URL = "api/getSellerInfo"
    static let SERVER_GETTRENCARD_URL = "api/getTrendCards"
    static let SERVER_POSTORDER_URL = "api/postOrder"
    static let SERVER_GETBALANCE_URL = "api/getBalance"
    static let SERVER_POSTCARD_URL = "api/postCard"
    static let SERVER_GETFAQ_URL = "api/getFaq"
    static let SERVER_TERMS_URL = "api/terms"
    static let SERVER_PRIVACY_URL = "api/privacy"
    static let SERVER_MESSAGE_URL = "api/message"
    static let SERVER_CONTACT_URL = "api/contact"
    static let SERVER_PAYMENT_URL = "payment/1"
    static let SERVER_SELECTCARD_URL = "api/selectCard"
    static let SERVER_GETTRANSSTATUS = "api/getTransStatus"

    // SellerInfos Dictionary Key
    static let KEY_SELLERINFOS = "sellerinfos"
    static let KEY_ISCART = "iscart"
    static let KEY_AVATAR = "avatar"
    static let KEY_NAME = "name"
    static let KEY_FIRSTNAME = "firstname"
    static let KEY_LASTNAME = "lastname"
    static let KEY_EXPIRES = "expired_on"
    static let KEY_TOTALPRICE = "totalprice"
    static let KEY_VALUE = "value"
    static let KEY_BRAND = "brand"
    static let KEY_CARDTYPE = "cardtype"
    static let KEY_SELLCOST = "sellcost"
    static let KEY_CARDIMAGE = "img"
    static let KEY_CARDID = "cardid"
    static let KEY_EMAIL = "email"
    static let KEY_SERVICECOST = "servicecost"
    static let KEY_TRANSCOST = "transcost"
    static let KEY_SELLERINDEX = "sellerindex"
    static let KEY_SELLCARDNO = "sellcardno"
    static let KEY_FBID = "fbid"
    static let KEY_USRPICURL = "imgURL"
    static let KEY_TOKEN = "token"
    static let KEY_PINCODE = "pincode"
    static let KEY_PAYINFOS = "payinfos"
    static let KEY_POSTCODE = "postcode"
    static let KEY_HOUSENO = "houseno"
    static let KEY_TRANSID = "transId"
    
    
    
    // ViewController Identifier
    static let VC_HOME_ID = "HomeID"
    static let VC_CHOOSE_ID = "ChooseID"
    static let VC_MARKET_ID = "MarketID"
    static let VC_SELLERINFO_ID = "SellerID"
    static let VC_PAY_ID = "PayID"
    static let VC_ACCOUNT_ID = "AccountID"
    static let VC_SCANCARD_ID = "ScanID"
    static let VC_SELLCARD_ID = "SellCardID"
    static let VC_FAQ_ID = "FaqID"
    static let VC_TERMCOND_ID = "TermConID"
    static let VC_ABOUT_ID = "AboutID"
    static let VC_PRIVACY_ID = "PrivacyID"
    static let VC_CONTACT_ID = "ContactID"
    static let VC_BARCORD_ID = "BarCodeID"
    static let VC_PAYMENTWEB_ID = "PaymentWebID"
    static let VC_PROFILE_ID = "ProfileID"
    
    
    // Response Key
    static let KEY_RES_CHECKRSULT = "checkresult"
    static let KEY_RES_CARDRESULT = "cardresult"
    static let KEY_RES_STATUS = "status"
    static let KEY_RES_SUCCESS = "success"
    
    static let KEY_RES_ORDERRESULT = "orderresult"
    static let KEY_RES_TRANSID = "transId"

    
    static let KEY_RES_FAQ = "faqs"
    static let KEY_RES_QUESTION = "question"
    static let KEY_RES_ANSWER = "answer"
    
    static let KEY_RES_CONTENT = "content"
    
    static let KEY_RES_TRENDCARD = "trendcards"
    static let KEY_RES_CARDTYPES = "cardtypes"
    
    static let KEY_RES_WEBSITE = "website"
    static let KEY_RES_EMAIL = "email"
    static let KEY_RES_PHONE = "phone"
    static let KEY_RES_OFFICE = "office"
    static let KEY_RES_COMPANY = "company"
    static let KEY_RES_SELECTCARDINFO = "selectcardinfo"
    static let KEY_RES_TRANSINFO = "transinfo"
    
    
    
    
    
    
    
}
