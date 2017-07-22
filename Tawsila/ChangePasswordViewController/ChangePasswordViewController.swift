
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
        
        if chekcValidation() == true {
            self.changePassword()
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        actionBackButton(sender)
    }
    
    
    func chekcValidation() -> Bool {
        
       if  (Utility.sharedInstance.trim(txtCurrentPassword.text!)).characters.count == 0 || (Utility.sharedInstance.trim(txtNewPassword.text!)).characters.count == 0 || (Utility.sharedInstance.trim(txtConfrPassword.text!)).characters.count == 0
       {
        
            Utility.sharedInstance.showAlert("Alert", msg: "Required All Fields.", controller: self)

       }
        
        
        let currentPassword : String = USER_DEFAULT .object(forKey: "password") as! String
        
        if  txtCurrentPassword.text != currentPassword
        {
            Utility.sharedInstance.showAlert("Alert", msg: "Your old Password doesn't match", controller: self)
            return false;
        }

        
        
        if (AppDelegateVariable.appDelegate.isValidPassword(txtNewPassword.text!) == false) {
            Utility.sharedInstance.showAlert("Alert", msg: "Please enter password atleast 6  alphanumeric character." , controller: self)
            return false
        }
        
        
        
        if  currentPassword == txtNewPassword.text
        {
            Utility.sharedInstance.showAlert("Alert", msg: "Your previous password and new password are same. Please change password.", controller: self)
            
            return false;
        }
        
        
        if  txtConfrPassword.text != txtNewPassword.text
        {
            Utility.sharedInstance.showAlert("Alert", msg: "Password doesn't match.", controller: self)
            
            return false;
        }
        
        return true;
        
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
            parameterString = String(format : "reset_forgot_password&id=%@&password=%@&confirmpassword=%@",USER_ID,self.txtNewPassword.text!,self.txtConfrPassword.text!)
        }else{
            parameterString = String(format : "reset_forgot_password&id=%@&password=%@&confirmpassword=%@",USER_ID,self.txtNewPasswordAr.text!,self.txtConfrPasswordAr.text!)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                self.txtNewPassword.text = ""
                self.txtCurrentPassword.text = ""
                self.txtConfrPassword.text = ""
                
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        return textField.resignFirstResponder()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool  {
        return true
    }
    
    
}
