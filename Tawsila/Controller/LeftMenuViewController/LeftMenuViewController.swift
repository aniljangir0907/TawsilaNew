//
//  LeftMenuViewController.swift
//  Tawsila
//
//  Created by vikram singh charan on 6/14/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import RappleProgressHUD

class LeftMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var userType: String! //30-June-2017 vikram singh
    var lblGoOnlineAndOffline: UILabel!//30-June-2017 vikram singh
    var switchOnLineOffline: UISwitch!//30-June-2017 vikram singh
    
    var currentVC = UIViewController()
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var lblUserDetail: UILabel!
    var arrLeftMenu =  [["image" : "home", "key" : "Home"], ["image" : "myride", "key" : "My rides"], ["image" : "wallet", "key" : "Wallet"], ["image" : "freeRide", "key" : "Get Free Rides"], ["image" : "settings", "key" : "Settings"], ["image" : "contactUs", "key" : "Contact us"],  ["image" : "help", "key" : "Help"]]
    
    var arrLeftMenuDriver = [["image" : "myride", "key" : "All Rides"], ["image" : "signout", "key" : "Signout"], ["image" : "settings", "key" : "Settings"]]//30-June-2017 vikram singh
    
    override func viewDidLoad() {
        
        print(USER_DEFAULT.object(forKey: "userData") as! NSDictionary)
        self.lblUserDetail.text = (USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "username") as? String
        super.viewDidLoad()
        
        
      //  currentVC =
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userType = (USER_DEFAULT.object(forKey: "userType") as! String ) //30-June-2017 vikram singh
        if  userType == "driver" {//30-June-2017 vikram singh
            lblUserDetail.isHidden = true
            
        }else{
            lblUserDetail.isHidden = false
        }
        self.tblView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITableView Delegate and DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  userType == "driver" {//30-June-2017 vikram singh
            return arrLeftMenuDriver.count+1
        }else{
            return       arrLeftMenu.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "leftMenuCell", bundle: nil), forCellReuseIdentifier: "cellLeftMenu")
        var cell : leftMenuCell = tableView.dequeueReusableCell(withIdentifier: "cellLeftMenu", for: indexPath) as! leftMenuCell
        
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellLeftMenu", for: indexPath) as! leftMenuCell
        }
        
        var dic : NSDictionary!
        
        if userType == "driver" {//30-June-2017 vikram singh
            
            if  indexPath.row == 3 {
                cell.imgIcon.isHidden = true
                cell.lblTitle.isHidden = true
                let driverStatus = USER_DEFAULT.object(forKey: "driverstatus") as! String
                lblGoOnlineAndOffline = UILabel.init(frame: CGRect(x: 20, y: 10, width: cell.frame.size.width-100, height: 38))
                
                cell.addSubview(lblGoOnlineAndOffline)
                switchOnLineOffline = UISwitch.init(frame: CGRect(x: cell.frame.size.width-80, y: 10, width: 60, height: 38))
                switchOnLineOffline.onTintColor = UIColor.init(red: 255.0/255.0, green: 0/255.0, blue: 141.0/255.0, alpha: 1.0)
                switchOnLineOffline.addTarget(self, action: #selector(switchOnlineAndOffline(_:)), for: .valueChanged)
                if driverStatus == "No" {
                    switchOnLineOffline.setOn(true, animated: true)
                    lblGoOnlineAndOffline.text = "Go Online"
                }
                else{
                    switchOnLineOffline.setOn(false, animated: true)
                    lblGoOnlineAndOffline.text = "Go Offline"
                }
                cell.addSubview(switchOnLineOffline)
            }else{
                cell.imgIcon.isHidden = false
                cell.lblTitle.isHidden = false
                dic = arrLeftMenuDriver[indexPath.row] as NSDictionary
                cell.imgIcon.image = UIImage.init(named:  dic.value(forKey: "image")! as! String)
                cell.lblTitle.text = dic.value(forKey: "key") as! String?
            }
        }
        else {
            dic = arrLeftMenu[indexPath.row] as NSDictionary
            cell.imgIcon.image = UIImage.init(named:  dic.value(forKey: "image")! as! String)
            cell.lblTitle.text = dic.value(forKey: "key") as! String?
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SlideNavigationController.sharedInstance().toggleLeftMenu()
        if userType == "user" {
            
            switch indexPath.row {
            case 0:
                let obj : HomeViewControlle = HomeViewControlle(nibName: "HomeViewControlle", bundle: nil)
                currentVC = obj;
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obj, withCompletion: nil)
            case 1:
                
                let obj : MyRidesVC = MyRidesVC(nibName: "MyRidesVC", bundle: nil)
                currentVC = obj;

                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obj, withCompletion: nil)
            case 2:
                let obj : WalletViewController = WalletViewController(nibName: "WalletViewController", bundle: nil)
                
                currentVC = obj;

                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obj, withCompletion: nil)
            case 3:
                // let moveViewController : GetFreeRides = GetFreeRides(nibName: "GetFreeRides", bundle: nil)
                // AppDelegateVariable.appDelegate.presentVC = 0
                // AppDelegateVariable.appDelegate.isPresentVC = true
                print("GetFreeRides")
                break
            case 4:
                let obj : SettingViewController = SettingViewController(nibName: "SettingViewController", bundle: nil)
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obj, withCompletion: nil)
            case 5:
                let moveViewController : Contact_Us = Contact_Us(nibName: "ContactUs", bundle: nil) 
                
                currentVC.present(moveViewController, animated: true, completion: nil)
                
                // AppDelegateVariable.appDelegate.presentVC = 1
                print("Contact Sceen design.")
            case 6:
                UIApplication.shared.openURL(URL(string: "http://taxiappsourcecode.com/tawasilataxi/contact_us")!)
                print("help Screen design")
            default:
                print("ViewController not Found.")
            }
        }
        else{
            switch indexPath.row {
            case 0:
                let obje: AllRides = AllRides(nibName: "AllRides", bundle: nil) as! AllRides
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obje, withCompletion: nil)
            case 1:

                
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
                
//                USER_DEFAULT.set("0", forKey: "isLogin")
//                AppDelegateVariable.appDelegate.sliderMenuControllser()
//                
            case 2:
                print("Tawsila")
            default:
                print("ViewController not Found.")
            }
        }
    }
    
    @IBAction func switchOnlineAndOffline(_ sender:UISwitch) {
        if sender.isOn {
            lblGoOnlineAndOffline.text = "Go Online"
        }
        else{
            lblGoOnlineAndOffline.text = "Go Offline"
        }
    }
    
    func FireAPI()
    {
        //  http://taxiappsourcecode.com/api/index.php?option=logout&id=7&usertype=driver
        
        let dic = NSMutableDictionary()
        
        dic.setValue(USER_ID, forKey: "id")
        dic.setValue("driver", forKey: "usertype")
        
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
