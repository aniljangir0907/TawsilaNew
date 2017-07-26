//
//  SettingViewController.swift
//  Tawsila
//
//  Created by vikram singh charan on 6/13/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import Alamofire
import RappleProgressHUD


class SettingViewController: UIViewController {
    var userType:String!
    // View english IBOutlet defines
    @IBOutlet weak var viewEnglish: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var actionSignOut: UIButton!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var viewbackground: UIView!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var imgEng: UIImageView!
    @IBOutlet weak var imgArbic: UIImageView!
    
    //View Arabic IBOutlet defines
    @IBOutlet weak var viewArabic: UIView!
    @IBOutlet weak var lblUserNameAr: UILabel!
    @IBOutlet weak var lblMobileNumberAr: UILabel!
    @IBOutlet weak var lblEmailAddressAr: UILabel!
    @IBOutlet weak var actionSignOutAr: UIButton!
    @IBOutlet weak var lblLanguageAr: UILabel!
    
    // tapGestureHandler defines
    var singleTap: UITapGestureRecognizer!
    var changeLanguage:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setShowAndHideViews(viewEnglish, vArb: viewArabic)
         userType = (USER_DEFAULT.object(forKey: "userType") as! String )
        viewButtons.layer.cornerRadius = 4.0
        viewButtons.layer.masksToBounds = true
        viewbackground.isHidden = true
        UIView.animate(withDuration: 0.6, animations: {
            self.viewbackground.frame = CGRect(x: self.view.frame.size.width, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }, completion: nil)
        singleTap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapGestureHandler(gesture:)))
        singleTap.numberOfTapsRequired = 1
        viewbackground.addGestureRecognizer(singleTap)
        
        imgEng.image = UIImage.init(named: "circle")
        imgArbic.image = UIImage.init(named: "circle")
        
        if  AppDelegateVariable.appDelegate.strLanguage == "en"{
            if userType == "driver" {
                self.lblUserName.text = (USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "user_name") as? String
                self.lblMobileNumber.text = (USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "phone") as? String
                self.lblEmailAddress.text = (USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "email") as? String
                lblLanguage.text = "English"
            }
            else{
                self.lblUserName.text = (USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "username") as? String
                self.lblMobileNumber.text = (USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "mobile") as? String
                self.lblEmailAddress.text = (USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "email") as? String
                lblLanguage.text = "English"
            }
        }
        else{
            if userType == "driver" {
                self.lblUserNameAr.text = (USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "user_name") as? String
                self.lblMobileNumberAr.text = (USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "phone") as? String
                self.lblEmailAddressAr.text = (USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "email") as? String
                lblLanguageAr.text = "عربى"
            }else{
                self.lblUserNameAr.text = (USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "username") as? String
                self.lblMobileNumberAr.text = (USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "mobile") as? String
                self.lblEmailAddressAr.text = (USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "email") as? String
                lblLanguageAr.text = "عربى"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIButton's Action
    
    @IBAction func actionArabicSelect(_ sender: Any) {
        imgArbic.image = UIImage.init(named: "pinkSelectedRadio")
        imgEng.image = UIImage.init(named: "circle")
        changeLanguage = "ar"
        showAlert()
    }
    @IBAction func actionEnglishSelect(_ sender: Any) {
        imgEng.image = UIImage.init(named: "pinkSelectedRadio")
        imgArbic.image = UIImage.init(named: "circle")
        changeLanguage = "en"
        showAlert()
    }
    @IBAction func actionLeftMenu(_ sender: Any) {
        SlideNavigationController.sharedInstance().toggleLeftMenu()
    }
    @IBAction func actionChangePassword(_ sender: Any) {
        let obj: ChangePasswordViewController = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil)
        setPushViewTransition(obj)
    }
    
    @IBAction func actionPriceCard(_ sender: Any) {
    }
    
    @IBAction func actionLanguageChange(_ sender: Any) {
        viewbackground.isHidden = false
        UIView.animate(withDuration: 0.6, animations: {
            self.viewbackground.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }, completion: nil)
        
    }
    @IBAction func actionRightToggleMenu(_ sender: Any) {
        SlideNavigationController.sharedInstance().toggleRightMenu()
    }
    
    @IBAction func actionRateAndReview(_ sender: Any) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1261446199"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func actionFeedback(_ sender: Any) {
    }
    
    @IBAction func actionSignOut(_ sender: Any) {
        
        let alert = UIAlertController.init(title: "", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        let actionOK = UIAlertAction.init(title: "OK", style: .default) { (alert: UIAlertAction!) in
           
            self.FireAPI()
            
            // let obj : SignInOrCreateNewAccount = SignInOrCreateNewAccount(nibName: "SignInOrCreateNewAccount", bundle: nil)
            // USER_DEFAULT.set("0", forKey: "isLogin")
            // AppDelegateVariable.appDelegate.sliderMenuControllser()
            //            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //            appDelegate.navController = SlideNavigationController.init(rootViewController: obj)
            //            appDelegate.window?.rootViewController = appDelegate.navContorller
            //            appDelegate.window?.makeKeyAndVisible()
        }
        let actionCancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionTermAndCondition(_ sender: Any) {
    }
    
    //MARK:- UIAlertController
    func showAlert(){
        let alert = UIAlertController.init(title: "Tawsila", message: "This requires restarting the application. Are you sure you want to close the app now?", preferredStyle: .alert)
        let actionOK = UIAlertAction.init(title: "OK", style: .default) { (alert: UIAlertAction!) in
            UserDefaults.standard.setValue(self.changeLanguage, forKey: "LanguageSelected")
            
            // Restart App Here
             AppDelegateVariable.appDelegate.restartApp() // 30-06-2017 vikram singh
            // call didFinishLaunchWithOptions ... why?
            
            
            //  appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        }
        let actionCancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tapGestureHandler(gesture: UIGestureRecognizer) {
        
        UIView.animate(withDuration: 0.6, animations: {
            self.viewbackground.frame = CGRect(x: self.view.frame.size.width, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }, completion:{ _ in
            self.viewbackground.isHidden = true
        })
        
    }
    
        func FireAPI()
        {
            let dic = NSMutableDictionary()
            dic.setValue(USER_ID, forKey: "id")
       
            if userType == "driver" {
                 dic.setValue("driver", forKey: "usertype")
            }else{
                dic.setValue("user", forKey: "usertype")
            }
            
            RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
            
            var parameterString = String(format : "logout")
            
            for (key, value) in dic
            {
                parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
            }
            
            Utility.sharedInstance.postDataInJson(header: parameterString,  withParameter:dic ,inVC: self) { (dataDictionary, msg, status) in
                
                if status == true
                {
                     USER_DEFAULT.set("0", forKey: "isLogin")
                     AppDelegateVariable.appDelegate.sliderMenuControllser()
                    
                }
                else
                {
                    Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
                }
            }
        }
}
