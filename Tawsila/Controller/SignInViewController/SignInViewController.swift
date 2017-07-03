//
//  SignInViewController.swift
//  Tawsila
//
//  Created by Dinesh Mahar on 10/06/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import RappleProgressHUD

class SignInViewController: UIViewController {

    @IBOutlet var viewAr: UIView!
    @IBOutlet var viewEng: UIView!
    @IBOutlet var txtEmailAr: ACFloatingTextfield!
    @IBOutlet var txtPassAr: ACFloatingTextfield!
    @IBOutlet var btnDriver: UIButton!
    @IBOutlet var imgDriver: UIImageView!
    @IBOutlet var imgRider: UIImageView!
    @IBOutlet var btnRider: UIButton!
    @IBOutlet var imgDAr: UIImageView!
    @IBOutlet var imgRAr: UIImageView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPass: UITextField!
    var userType : String = "user"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setShowAndHideViews(viewEng, vArb: viewAr)
        
        AppDelegateVariable.appDelegate.strLanguage = "en"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionDriver(_ sender: Any) {
        userType = "driver"
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            imgDriver.image = UIImage.init(named: "selectRadio")
            imgRider.image = UIImage.init(named: "unselectRadio")
        }else{
            imgDAr .image = UIImage.init(named: "selectRadio")
            imgRAr.image = UIImage.init(named: "unselectRadio")
        }
       
    }
    @IBAction func actionRider(_ sender: Any) {
        userType = "user"
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            imgDriver.image = UIImage.init(named: "unselectRadio")
            imgRider.image = UIImage.init(named: "selectRadio")
        }else{
            imgDAr.image = UIImage.init(named: "unselectRadio")
            imgRAr.image = UIImage.init(named: "selectRadio")
        }
       
    }
    
    @IBAction func actionForgotPassword(_ sender: Any) {
        let obj : forgotPassword = forgotPassword(nibName: "forgotPassword", bundle: nil)
        setPushViewTransition(obj)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        actionBackButton(sender)
    }
    
    @IBAction func actionSignIn(_ sender: Any) {
        
        if  Reachability.isConnectedToNetwork() == false
        {
            Utility.sharedInstance.showAlert("Alert", msg: "Internet Connection not Availabel!", controller: self)
            return
        }
        
        if  AppDelegateVariable.appDelegate.strLanguage == "en" {
            if (Utility.sharedInstance.trim(txtEmail.text!)).characters.count == 0 {
                Utility.sharedInstance.showAlert("Alert", msg: "Please enter your email.", controller: self)
                return
            }
            
            if (AppDelegateVariable.appDelegate.isValidEmail(txtEmail.text!) == false)
            {
                Utility.sharedInstance.showAlert("Alert", msg: "Please enter valid email.", controller: self)
                return
            }
            
            if (Utility.sharedInstance.trim(txtPass.text!)).characters.count == 0 {
                Utility.sharedInstance.showAlert("Alert", msg: "Please enter password.", controller: self)
                return
            }
            if (AppDelegateVariable.appDelegate.isValidPassword(txtPass.text!)==false) {
               // Utility.sharedInstance.showAlert("Alert", msg: "Please enter password atleast 6 alphanumeric character." , controller: self)
               // return
            }
        }
        else{
            
            if (Utility.sharedInstance.trim(txtEmailAr.text!)).characters.count == 0 {
                Utility.sharedInstance.showAlert("إنذار", msg: "رجاءا أدخل بريدك الإلكتروني.", controller: self)
                return
            }
            
            if (AppDelegateVariable.appDelegate.isValidEmail(txtEmailAr.text!) == false)
            {
                Utility.sharedInstance.showAlert("إنذار", msg: "الرجاء إدخال عنوان بريد إلكتروني صالح.", controller: self)
                return
            }
            
            if (Utility.sharedInstance.trim(txtPassAr.text!)).characters.count == 0 {
                Utility.sharedInstance.showAlert("إنذار", msg: "الرجاء إدخال كلمة المرور.", controller: self)
                return
            }
            if (AppDelegateVariable.appDelegate.isValidPassword(txtPassAr.text!)==false) {
    //            Utility.sharedInstance.showAlert("إنذار", msg: "الرجاء إدخال كلمة المرور على الأقل 6 حرف أبجدي رقمي." , controller: self)
  //              return
            }
        }
        
        let device_token : String = USER_DEFAULT .object(forKey: "FCM_TOKEN") as! String
        
      
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
        
        var parameterString :String
        if AppDelegateVariable.appDelegate.strLanguage == "en"{
            parameterString = String(format : "login&email=%@&password=%@&usertype=%@&device_id=%@",self.txtEmail.text! as String,self.txtPass.text! as String,userType,device_token)
        }
        else{
            parameterString = String(format : "login&email=%@&password=%@&usertype=%@&device_id=%@",self.txtEmailAr.text! as String,self.txtPassAr.text! as String,userType,device_token
            )
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                var userDict = (dataDictionary.object(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                userDict = AppDelegateVariable.appDelegate.convertAllDictionaryValueToNil(userDict) 
                
                let user_id : String = userDict .object(forKey: "id") as! String
                let user_name : String = userDict .object(forKey: "username") as! String
                
                USER_DEFAULT.set(user_id, forKey: "user_id")
                USER_DEFAULT.set(user_name, forKey: "user_name")
                USER_DEFAULT.set("1", forKey: "isLogin")
                USER_DEFAULT.set(userDict, forKey: "userData")
                
                AppDelegateVariable.appDelegate.sliderMenuControllser()
            }
            else
                
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
//        let obj : HomeViewControlle = HomeViewControlle(nibName: "HomeViewControlle", bundle: nil)
//        navigationController?.pushViewController(obj, animated: true)
   // }

}
