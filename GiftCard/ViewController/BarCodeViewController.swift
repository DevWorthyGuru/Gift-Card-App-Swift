import UIKit
import AVFoundation


class BarCodeViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    
    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    @IBOutlet weak var highlightView: UIView!
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBrief: UIButton!
    @IBOutlet weak var btnPerson: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
//        btnBrief.isHighlighted = false
//        self.modalViewController(id: Const.VC_SCANCARD_ID, baseController: self)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.layer.add(transition, forKey: "rightToLeftTransition")
        self.modalViewController(id: Const.VC_SCANCARD_ID, baseController: self)
        
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
            BaseViewController.gPrevVCID = Const.VC_BARCORD_ID
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
        // Allow the view to resize freely
        //        self.highlightView.autoresizingMask =   UIViewAutoresizing.FlexibleTopMargin |
        //            UIViewAutoresizing.FlexibleBottomMargin |
        //            UIViewAutoresizing.FlexibleLeftMargin |
        //            UIViewAutoresizing.FlexibleRightMargin
        //
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.black.cgColor
        self.highlightView.layer.borderWidth = 1
        
        // Add it to our controller's view as a subview.
        self.view.addSubview(self.highlightView)
        
        let inputDevice : AVCaptureDeviceInput
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error : NSError?
        do {
            inputDevice = try AVCaptureDeviceInput(device: captureDevice)
        }
        catch {
            return
        }
        
        if session.canAddInput(inputDevice) {
            session.addInput(inputDevice)
        }
        else {
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
        } else {
           
            return
        }
       
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.frame = highlightView.layer.bounds
        highlightView.layer.addSublayer(previewLayer)
        
        
        session.startRunning()

        
    }
    
  
 func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        session.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            SVProgressHUD.showInfo(withStatus: stringValue)
            BaseViewController.gSellCardNo = stringValue
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.layer.add(transition, forKey: "rightToLeftTransition")
            self.modalViewController(id: Const.VC_SCANCARD_ID, baseController: self)
        }
        
//        dismiss(animated: true)
    }
    func translatePoints(points : [AnyObject], fromView : UIView, toView: UIView) -> [CGPoint] {
        var translatedPoints : [CGPoint] = []
        for point in points {
            let dict = point as! NSDictionary
            let x = CGFloat((dict.object(forKey: "X") as! NSNumber).floatValue)
            let y = CGFloat((dict.object(forKey: "Y") as! NSNumber).floatValue)
            let curr = CGPoint(x: x, y: y)
            let currFinal = fromView.convert(curr, to: toView)
            translatedPoints.append(currFinal)
        }
        return translatedPoints
    }
    
//    func alert(Code: String){
//        let actionSheet:UIAlertController = UIAlertController(title: "Barcode", message: "\(Code)", preferredStyle: UIAlertControllerStyle.alert)
//        
//        // for alert add .Alert instead of .Action Sheet
//        
//        
//        // start copy
//        
//        let firstAlertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:
//            
//            
//            {
//                (alertAction:UIAlertAction!) in
//                
//                
//                // action when pressed
//                
//                self.session.startRunning()
//                
//                
//                
//                
//        })
//        
//        actionSheet.addAction(firstAlertAction)
//        
//        // end copy
//        
//        
//        
//        
//        
//        
//        self.present(actionSheet, animated: true, completion: nil)
//        
//    }
}
