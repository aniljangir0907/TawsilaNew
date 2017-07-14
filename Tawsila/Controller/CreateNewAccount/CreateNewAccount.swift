//
//  CreateNewAccount.swift
//  Tawsila
//
//  Created by vikram singh charan on 6/11/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import RappleProgressHUD

class CreateNewAccount: UIViewController {
    @IBOutlet var txtUserFullName: UITextField!
    @IBOutlet var txtemail: UITextField!
    @IBOutlet var txtpassword: UITextField!
    @IBOutlet var txtMobile: UITextField!
    @IBOutlet var txtCountryCode: UITextField!
    @IBOutlet var txtInvitationCode: UITextField!
    @IBOutlet var imgTerm_Conditions: UIImageView!
    @IBOutlet var viewEnglish: UIView!
    @IBOutlet var viewArabic: UIView!
   
    // Arabic View IBOutlet
    @IBOutlet var txtUserNameAr: ACFloatingTextfield!
    @IBOutlet var txtEmailAr: ACFloatingTextfield!
    @IBOutlet var txtPassAr: ACFloatingTextfield!
    @IBOutlet var txtMobileAr: ACFloatingTextfield!
    @IBOutlet var txtCountryCodeAr: UITextField!
    @IBOutlet var txtInvitationCodeAr: ACFloatingTextfield!
    @IBOutlet var imgSelectAr: UIImageView!
    
    var textF: UITextField!
    var isSelect :Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        setShowAndHideViews(viewEnglish, vArb: viewArabic)
        let img = UIImageView.init(frame: CGRect(x: 0, y: 10, width: 20, height: 20))
        img.image  = UIImage.init(named: "dropDown")
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            textF = txtCountryCode
            textF.rightView?.frame = img.frame
            textF.rightViewMode = .always
            textF.rightView = img
        }
        else{
            textF = txtCountryCodeAr
            textF.leftView?.frame = img.frame
            textF.leftViewMode = .always
            textF.leftView = img
        }
       
        isSelect = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Check Validation on textfields
    func chechValidation(){
        if  AppDelegateVariable.appDelegate.strLanguage == "en" {
            if (Utility.sharedInstance.trim(self.txtUserFullName.text!)).characters.count == 0 {
                Utility.sharedInstance.showAlert("Alert", msg: "Please enter your Full Name.", controller: self)
                return
            }
            
            if (Utility.sharedInstance.trim(txtemail.text!)).characters.count == 0 {
                Utility.sharedInstance.showAlert("Alert", msg: "Please enter your email.", controller: self)
                return
            }
            
            if (AppDelegateVariable.appDelegate.isValidEmail(txtemail.text!) == false)
            {
                Utility.sharedInstance.showAlert("Alert", msg: "Please enter valid email.", controller: self)
                return
            }
            
            if (Utility.sharedInstance.trim(txtpassword.text!)).characters.count == 0 {
                Utility.sharedInstance.showAlert("Alert", msg: "Please enter password.", controller: self)
                return
            }
            if (AppDelegateVariable.appDelegate.isValidPassword(txtpassword.text!) == false) {
                Utility.sharedInstance.showAlert("Alert", msg: "Please enter password atleast 6  alphanumeric character." , controller: self)
                return
            }
            
            if (Utility.sharedInstance.trim(txtMobile.text!)).characters.count == 0 {
                Utility.sharedInstance.showAlert("Alert", msg: "Please enter mobile number.", controller: self)
                return
            }
            if (AppDelegateVariable.appDelegate.isValidMobileNumber(txtMobile.text!)==false){
               // Utility.sharedInstance.showAlert("Alert", msg: "Please enter 10 digit mobile number.", controller: self)
               // return
            }
        }
        else{
            if (Utility.sharedInstance.trim(self.txtUserNameAr.text!)).characters.count == 0 {
                Utility.sharedInstance.showAlert("إنذار", msg: "Please enter your Full Name.", controller: self)
                return
            }
            
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
                Utility.sharedInstance.showAlert("إنذار", msg: "الرجاء إدخال كلمة المرور على الأقل 6 حرف أبجدي رقمي." , controller: self)
            }
            
            if (Utility.sharedInstance.trim(txtMobileAr.text!)).characters.count == 0 {
                Utility.sharedInstance.showAlert("إنذار", msg: "Please enter mobile number.", controller: self)
                return
            }
            if (AppDelegateVariable.appDelegate.isValidMobileNumber(txtMobileAr.text!)==false){
                
                //Utility.sharedInstance.showAlert("إنذار", msg: "Please enter 10 digit mobile number.", controller: self)
                //return
            }
        }
    }
    //MARK:- UIButtons Actions
    @IBAction func actionSignUp(_ sender: Any) {
        
        if  Reachability.isConnectedToNetwork() == false
        {
            Utility.sharedInstance.showAlert("Alert", msg: "Internet Connection not Availabel!", controller: self)
            return
        }
    
        chechValidation() /// vikram singh
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
//<<<<<<< HEAD
//        let parameter s = [
//             "username" :  self.txtUserFullName.text! as String,
//            "email" :  self.txtemail.text! as String,
//            "password":   self.txtpassword.text! as String,
//            "phone":   self.txtpassword.text! as String,
//            "country_mobile_code" : "91",
//            "terms_and_condition" : "",
//            "device_id" : "123456789"
//            
//        ]
        
        let parameterString : String!
        if  AppDelegateVariable.appDelegate.strLanguage == "en" {
                  parameterString = String(format : "register&username=%@&email=%@&password=%@&mobile=%@&country_mobile_code=%@&terms_and_condition=%@&device_id=%@",self.txtUserFullName.text! as String,self.txtemail.text! as String,self.txtpassword.text! as String,self.txtMobile.text! as String,"91","","1234567890")
        }
        else{
                  parameterString = String(format : "register&username=%@&email=%@&password=%@&mobile=%@&country_mobile_code=%@&terms_and_condition=%@&device_id=%@",self.txtUserNameAr.text! as String,self.txtEmailAr.text! as String,self.txtPassAr.text! as String,self.txtMobileAr.text! as String,"91","","1234567890")
        }
     
//=======
        //        let parameters = [
        //             "username" :  self.txtUserFullName.text! as String,
        //            "email" :  self.txtemail.text! as String,
        //            "password":   self.txtpassword.text! as String,
        //            "phone":   self.txtpassword.text! as String,
        //            "country_mobile_code" : "91",
        //            "terms_and_condition" : "",
        //            "device_id" : "123456789"
        //
        //        ]
       // let parameterString = String(format : "register&username=%@&email=%@&password=%@&mobile=%@&country_mobile_code=%@&terms_and_condition=%@&device_id=%@",self.txtUserFullName.text! as String,self.txtemail.text! as String,self.txtpassword.text! as String,self.txtMobile.text! as String,"91","","1234567890")//>>>>>>> e0d25e47d49dd5473c751927147f180b243f0428
   
        
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString,  inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                var userDict = ((dataDictionary.object(forKey: "result") as! NSArray).object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                userDict = AppDelegateVariable.appDelegate.convertAllDictionaryValueToNil(userDict)
                
                let user_id : String = userDict .object(forKey: "id") as! String

//                USER_DEFAULT.set("1", forKey: "isLogin")
//                USER_DEFAULT.set(userDict, forKey: "userData")
//                
//                USER_DEFAULT.set(user_id, forKey: "user_id")
//                USER_DEFAULT.set(self.txtUserFullName.text, forKey: "user_name")
         
//                let verification = ConfirmationScreen()
//                self.setPushViewTransition(verification)
                
              //  AppDelegateVariable.appDelegate.sliderMenuControllser()
                
                
                //print("Location:  \(userInfo)")
                /// NotificationCenter.default.post(name: Notification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: (userInfo as AnyObject) as? [AnyHashable : Any])
                //  AppDelegateVariable.appDelegate.loginInMainView()
                
                let obej: ConfirmationScreen = ConfirmationScreen(nibName: "ConfirmationScreen", bundle: nil)
                ///self.navigationController?.pushViewController(obej, animated: true)
                self.setPushViewTransition(obej)
            }
            else {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    @IBAction func actionTermAndConditions(_ sender: Any) {
        if AppDelegateVariable.appDelegate.strLanguage == "en"{
        if isSelect == false{
            imgTerm_Conditions.image = UIImage.init(named: "selectdCheck")
            isSelect = true
            UserDefaults.standard.setValue("1", forKey: "TermsCondtions")
        } else {
            isSelect = false
            imgTerm_Conditions.image = UIImage.init(named: "unselectedCheckbox")
            UserDefaults.standard.setValue("0", forKey: "TermsCondtions")
        }
        }else{
            if isSelect == false{
                imgSelectAr.image = UIImage.init(named: "selectdCheck")
                isSelect = true
                UserDefaults.standard.setValue("1", forKey: "TermsCondtions")
            } else {
                isSelect = false
                imgSelectAr.image = UIImage.init(named: "unselectedCheckbox")
                UserDefaults.standard.setValue("0", forKey: "TermsCondtions")
            }
        
        }
    }
    
    @IBAction func actionback(_ sender: Any) {
            actionBackButton(sender)
    }
    
}
