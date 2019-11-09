//
//  ViewController.swift
//  TicketSwap
//
//  Created by Apple on 2017. 11. 30..
//  Copyright © 2017년 Apple. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class HomeViewController: BaseViewController, UIScrollViewDelegate {
    
    var currentPage : Int?
    var page_num : Int?
    var dicTrendCard : NSDictionary?
    var scrollIndicator = UIView()
    var indicator = UIView()
    
    @IBOutlet weak var pcCardType: UIPageControl!
    @IBOutlet weak var ivIndicator: UIView!
    
    @IBOutlet weak var tfSearch: UITextField!
    
    @IBOutlet weak var ivCard: UIImageView!
    @IBOutlet weak var ivCardShadow: UIImageView!
    
    @IBOutlet weak var lbCardTitle: UILabel!
    @IBOutlet weak var lbCardType: UILabel!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainVIew: UIView!
    var yPos : CGFloat = 0
    
    
    // Toolbar
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBrief: UIButton!
    @IBOutlet weak var btnPerson: UIButton!
    
    @IBAction func onSearchEditChanged(_ sender: Any) {
        let strSearch = tfSearch.text
        _ = NSPredicate(format: "description contains[c] %@",strSearch!);
        
        //_ = ary.filtered(using: subPredicate)
    }
    
    
    @IBAction func scrollViewTapped(_ sender: Any) {
        let pageWidth = scrollView.frame.size.width
        currentPage = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
        print("Current Page = ", String(describing: currentPage!))
        
        pcCardType.currentPage = currentPage!

        
        let arytrendCards = dicTrendCard?.value(forKey: Const.KEY_RES_TRENDCARD) as! NSArray
        
        let selCard = arytrendCards[currentPage!] as! NSDictionary
        BaseViewController.gSelectCardType = Int.init(selCard.value(forKey: Const.KEY_CARDTYPE) as! String)
        BaseViewController.gSearchKey = selCard.value(forKey: Const.KEY_VALUE) as? String
        BaseViewController.gSelCardInfo = selCard
        BaseViewController.gSelCardID = (selCard.value(forKey: Const.KEY_CARDID) as? String)!
        BaseViewController.gSelCardType = selCard.value(forKey: Const.KEY_CARDTYPE) as! String
        if (BaseViewController.gUserToken != "")
        {
            self.modalViewController(id: Const.VC_SELLERINFO_ID, baseController: self)
        }
        else {
            BaseViewController.gPrevVCID = Const.VC_HOME_ID
            self.modalViewController(id: Const.VC_ACCOUNT_ID, baseController: self)
        }
//        briefVC.tabBarController.selectIndex = 1
       // self.present(briefVC, animated: true, completion: nil)
        
    }
    
    @IBAction func toolbarTapped(_ sender: Any) {
        let btn = sender as! UIButton
        btnHome.isHighlighted = true
        btnBrief.isHighlighted = true
        btnPerson.isHighlighted = true
        switch btn.tag {
        case 0:
//            btnHome.isHighlighted = false
//            self.modalViewController(id: Const.VC_HOME_ID, baseController: self)
            break
        case 1:
            btnBrief.isHighlighted = false
            
            self.modalViewController(id: Const.VC_CHOOSE_ID, baseController: self)
            break
        case 2:
            btnPerson.isHighlighted = false
            BaseViewController.gPrevVCID = Const.VC_HOME_ID
            self.modalViewController(id: Const.VC_ACCOUNT_ID, baseController: self)
            break
        default:
            btnHome.isHighlighted = false
            break
        }
    }
    
    @IBAction func onSearchTapped(_ sender: Any) {
        BaseViewController.gSearchKey = tfSearch.text
        BaseViewController.gSelectCardType = 0
        if (BaseViewController.gUserToken != "")
        {
            self.modalViewController(id: Const.VC_MARKET_ID, baseController: self)
        }
        else
        {
            BaseViewController.gPrevVCID = Const.VC_HOME_ID
            self.modalViewController(id: Const.VC_ACCOUNT_ID, baseController: self)
            
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let dic = getDataArray() as NSDictionary
//        let a = dic.value(forKey: "Standard") as! NSDictionary
//        _ = a.value(forKey: "step2Question") as! String
        // Do any additional setup after loading the view, typically from a nib.
        
        // Custom Tab Controller
        
        //Scroll Images
        
        //self.layoutSrollImages()
        mainVIew.isHidden = true
        btnHome.isHighlighted = false
        btnBrief.isHighlighted = true
        btnBrief.isHighlighted = true
        initGloval()
        mainScrollView.contentSize = CGSize.init(width: 320, height: 800)
        mainScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.showsHorizontalScrollIndicator = false
//        self.scrollView.delegate = self
        //self.tfSearch.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView  = false
        self.view.addGestureRecognizer(tapGesture)
        fetchGetTrendCardsFromServer()
    }
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    func initGloval()
    {
        BaseViewController.gCartInfo = nil
        BaseViewController.gPrevVCID = ""
        BaseViewController.gCardTypes = nil
        BaseViewController.gPayHomeNo = ""
        BaseViewController.gSearchKey = ""
        BaseViewController.gSellCardNo = ""
        BaseViewController.gPayPostCode = ""
        BaseViewController.gSelCardInfo = nil
        BaseViewController.gSellerInfos = nil
        BaseViewController.gAryCardInfos = nil
        BaseViewController.gSellCardType = ""
        BaseViewController.gSellCardBrand = ""
        BaseViewController.gSellCardValue = ""
        BaseViewController.gSelectCardType = 0
        BaseViewController.gSellCardExpire = ""
        BaseViewController.gSellCardSellCost = ""
        BaseViewController.gSelCardID = ""
        BaseViewController.gSelCardType = ""
    }

    func fetchGetTrendCardsFromServer() {
        
        let url = Const.SERVER_REMOTE_URL + Const.SERVER_GETTRENCARD_URL
        SVProgressHUD.show()
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                SVProgressHUD.dismiss()
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let dic = response.result.value as? NSDictionary {
                            BaseViewController.gCardTypes = dic.value(forKey: Const.KEY_RES_CARDTYPES) as? NSArray
                            
                            self.dicTrendCard = dic.copy() as? NSDictionary
                            self.layoutSrollImages()
                        }
                        print("state success \(url)")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                
        }
        
    }
    func layoutSrollImages(){
        mainVIew.isHidden = false
        var _ : UIImageView? = nil
        let subViews = scrollView.subviews
        
        let aryCard = dicTrendCard?.value(forKey: Const.KEY_RES_TRENDCARD) as! NSArray
        page_num = aryCard.count - 1;
        BaseViewController.gSelCardInfo = aryCard.firstObject as? NSDictionary
        scrollView.contentSize = CGSize.init(width: scrollView.frame.width * CGFloat(page_num!), height: scrollView.frame.height)
        
        var curXLoc : Float = 0
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        let pagingViewHeight = self.scrollView.frame.height
        let pagingViewWidth = self.scrollView.frame.width
       
        self.scrollIndicator = UIView(frame: CGRect(x: 0, y: 0, width: pagingViewWidth, height: 3))
        self.indicator = UIView(frame: CGRect(x: 0, y: 0, width: pagingViewWidth / CGFloat(page_num! + 1), height: 3))
       
        self.scrollIndicator.backgroundColor = UIColor.white
        self.indicator.backgroundColor = UIColor(red: 51.0/255, green: 113.0/255, blue: 255.0/255, alpha: 0)
        
        ivIndicator.addSubview(scrollIndicator)
        ivIndicator.addSubview(indicator)
        scrollView.scrollIndicatorInsets.top = 0.1
        scrollView.delegate = self as? UIScrollViewDelegate
        
        
        var txtView : [UILabel] = []
        lbCardTitle.isHidden = true
        ivCard.isHidden = true
        
        
        for i in 0 ... page_num! {
            
            let cardInfo = aryCard[i] as! NSDictionary
            //let ivShadow : UIImageView = UIImageView.init()
            let ivShadow = UIImageView.init(image: ivCardShadow.image)
            var rect : CGRect = ivCardShadow.frame.offsetBy(dx: scrollView.frame.width * CGFloat(i), dy: 0)
            rect.size.height = CGFloat(ivCardShadow.frame.height)
            rect.size.width = CGFloat(ivCardShadow.frame.width)
            ivShadow.contentMode = UIViewContentMode(rawValue: 1)!
            ivShadow.frame = rect;
            
            let uiImage : UIImageView = UIImageView.init()
            
            uiImage.sd_setShowActivityIndicatorView(true)
            uiImage.sd_setIndicatorStyle(.gray)
            uiImage.sd_setImage(with: URL(string: cardInfo.value(forKey: Const.KEY_CARDIMAGE) as! String), placeholderImage: UIImage(named: "Card_Toolber"))

            rect = ivCard.frame.offsetBy(dx: scrollView.frame.width * CGFloat(i), dy: 0)
            rect.size.height = CGFloat(ivCard.frame.height)
            rect.size.width = CGFloat(ivCard.frame.width)
            uiImage.frame = rect;
            uiImage.contentMode = UIViewContentMode(rawValue: 1)!
            
            rect = lbCardTitle.frame.offsetBy(dx: scrollView.frame.width * CGFloat(i), dy: 0)		
            rect.size.height = CGFloat(lbCardTitle.frame.height)
            rect.size.width = CGFloat(lbCardTitle.frame.width)
            txtView.append(UILabel(frame: rect))
            
            txtView[i].textColor = lbCardTitle.textColor
            txtView[i].backgroundColor = lbCardTitle.backgroundColor
            
            // display card info format
            let str = cardInfo.value(forKey: Const.KEY_BRAND) as! String
            txtView[i].text = str.appending(" - € ").appending(cardInfo.value(forKey: Const.KEY_VALUE) as! String).appending(" - voor € ").appending(cardInfo.value(forKey: Const.KEY_TOTALPRICE) as! String)
            let atrStr = createAttributedString(fullString: txtView[i].text!, fullStringColor: UIColor.init(red: 85.0 / 255, green: 85.0 / 255, blue: 85.0 / 255, alpha: 1), subString1: cardInfo.value(forKey: Const.KEY_VALUE) as! String, subString2: cardInfo.value(forKey: Const.KEY_TOTALPRICE) as! String, subStringColor: UIColor.init(red: 51.0 / 255, green: 113.0 / 255, blue: 255.0 / 255, alpha: 1))
            
            txtView[i].attributedText = atrStr
            txtView[i].textAlignment = lbCardTitle.textAlignment
            txtView[i].autoresizingMask = lbCardTitle.autoresizingMask
            txtView[i].font = lbCardTitle.font
            txtView[i].numberOfLines = 0
            txtView[i].adjustsFontSizeToFitWidth = true
            txtView[i].minimumScaleFactor = 0.1
            txtView[i].backgroundColor = .white
            scrollView.addSubview(ivShadow)
            scrollView.addSubview(uiImage)
            scrollView.addSubview(txtView[i])
            

        }
        // scrolling
        for layoutview in subViews {
            if (layoutview.isKind(of: UIImageView.classForCoder()
                ) && layoutview.tag > 0) {
                var frame = layoutview.frame
                frame = layoutview.frame
                frame.origin = CGPoint(x: Int(curXLoc), y: 0)
                layoutview.frame = frame
                curXLoc = curXLoc + Float(scrollView.frame.width)
                
                
            }
        }
        scrollView.contentSize = CGSize(width: CGFloat(page_num! + 1) * CGFloat(scrollView.frame.width), height: scrollView.frame.height)
        
        
    }
    func createAttributedString(fullString: String, fullStringColor: UIColor, subString1: String, subString2: String,subStringColor: UIColor) -> NSMutableAttributedString
    {
        let range1 = (fullString as NSString).range(of: "€ ".appending(subString1))
        let range2 = (fullString as NSString).range(of: "€ ".appending(subString2))
        
        let attributedString = NSMutableAttributedString(string:fullString)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: fullStringColor, range: NSRange(location: 0, length: fullString.characters.count))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: subStringColor, range: range1)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: subStringColor, range: range2)
        attributedString.addAttributes([NSFontAttributeName: UIFont.init(name: "Tamil Sangam MN", size: 19.0)!], range: NSRange(location: 0, length: fullString.characters.count))
        
        return attributedString
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == self.scrollView){
            
            let pageWidth = scrollView.frame.size.width
            currentPage = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
            print("Current Page = ", String(describing: currentPage!))
            
            pcCardType.currentPage = currentPage!
            self.indicator.frame = CGRect.init(x: self.scrollView.contentOffset.x / CGFloat(page_num! + 1), y: yPos, width: self.scrollView.frame.width / 4, height: 3);
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.showHideTransitionViews, animations: {
            self.indicator.backgroundColor = UIColor(red: 51.0/255, green: 113.0/255, blue: 255.0/255, alpha: 0.9)
        }
            , completion: nil)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.showHideTransitionViews, animations: {
            self.indicator.backgroundColor = UIColor(red: 51.0/255, green: 113.0/255, blue: 255.0/255, alpha: 0)
        }
            , completion: nil)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getDataArray() -> NSDictionary {
        
        var myArray: NSDictionary?
        if let path = Bundle.main.path(forResource: "DataTransition", ofType: "plist") {
            myArray = NSDictionary(contentsOfFile: path)
        }
        
        return myArray!
    }

}
