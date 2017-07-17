//
//  ChangePasswordViewController.swift
//  Tawsila
//
//  Created by Vikram on 11/06/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import RappleProgressHUD
class ChangePasswordViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet var txtCurrentPassword: UITextField!
    @IBOutlet weak var btnSavePassword: UIButton!
    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var txtConfrPassword: UITextField!
    @IBOutlet var viewArabic: UIView!
    @IBOutlet var viewEnglish: UIView!
    
    @IBOutlet var txtCurrentPasswordAr: UITextField!
    @IBOutlet var txtNewPasswordAr: UITextField!
    @IBOutlet var txtConfrPasswordAr: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        setShowAndHideViews(viewEnglish, vArb: viewArabic)
    }
    @IBAction func actionSaveNewPassword(_ sender: Any) {
         self.changePassword()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
   
    @IBAction func actionBack(_ sender: Any) {
       actionBackButton(sender)
    }
    
    func changePassword()
    {
        if  Reachability.isConnectedToNetwork() == false
        {
            Utility.sharedInstance.showAlert("Alert", msg: "Internet Connection not Availabel!", controller: self)
            return
        }
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
        var parameterString : String!
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
             parameterString = String(format : "%@reset_forgot_password&id=%@&password=%@&confirmpassword=%@",BSE_URL,((USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "id") as? String)!,self.txtNewPassword.text!,self.txtConfrPassword.text!)
        }else{
             parameterString = String(format : "%@reset_forgot_password&id=%@&password=%@&confirmpassword=%@",BSE_URL,((USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "id") as? String)!,self.txtNewPasswordAr.text!,self.txtConfrPasswordAr.text!)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
//                let userDict = dataDictionary.object(forKey: "result") as! NSArray
//                
//                print(userDict.count)
//                print(userDict)
//                if msg == "No record found"
//                {
                    Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
//                }
//                else
//                {
////                    self.arrayRideData = userDict.mutableCopy()  as! NSMutableArray
////                    self.tblMyRides.reloadData()
//                }
                
                
                
            }
            else
                
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
            
        }
        
        
    }
    
    // MARK: - UITextFieldDelegate implement
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool  {
        
        if textField == txtNewPassword || textField == txtNewPasswordAr  {
            if  textField.text == txtCurrentPassword.text ||  textField.text == txtCurrentPasswordAr.text{
                Utility.sharedInstance.showAlert("Alert", msg: "Your previous password and new password are same. Please change password.", controller: self)
            }
        }
        if textField == txtConfrPassword || textField == txtConfrPasswordAr  {
            if  textField.text != txtNewPassword.text ||  textField.text != txtNewPasswordAr.text{
                Utility.sharedInstance.showAlert("Alert", msg: "Password doesn't match.", controller: self)
            }
        }
        return true
    }
    

}
