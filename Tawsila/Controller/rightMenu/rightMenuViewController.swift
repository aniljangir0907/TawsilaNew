//
//  rightMenuViewController.swift
//  Tawsila
//
//  Created by vikram singh charan on 6/14/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class rightMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var userType: String! //30-June-2017 vikram singh
    var lblGoOnlineAndOffline: UILabel!//30-June-2017 vikram singh
    var switchOnLineOffline: UISwitch!//30-June-2017 vikram singh
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var lblUserDetail: UILabel!
    
    var arrLeftMenu =  [["image" : "home", "key" : "منزل"], ["image" : "myride", "key" : "بلدي ركوب الخيل"], ["image" : "wallet", "key" : "محفظة نقود"], ["image" : "Share_icon", "key" : "مشاركة التطبيق"], ["image" : "settings", "key" : "إعدادات"], ["image" : "contactUs", "key" : "اتصل بنا"],  ["image" : "help", "key" : "مساعدة"]]
    
    var arrLeftMenuDriver = [["image" : "myride", "key" : "جميع ركوب الخيل"], ["image" : "signout", "key" : "خروج"], ["image" : "settings", "key" : "إعدادات"]] //30-June-2017 vikram singh
    
    override func viewDidLoad() {
        
        print(USER_DEFAULT.object(forKey: "userData") as! NSDictionary)
        self.lblUserDetail.text = (USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "username") as? String
        super.viewDidLoad()
        
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
        tableView.register(UINib(nibName: "rightMenuCell", bundle: nil), forCellReuseIdentifier: "rightMenuCell")
        var cell : rightMenuCell = tableView.dequeueReusableCell(withIdentifier: "rightMenuCell", for: indexPath) as! rightMenuCell
        
        if cell == nil{
            cell = tableView.dequeueReusableCell(withIdentifier: "rightMenuCell", for: indexPath) as! rightMenuCell
        }
        
        var dic : NSDictionary!
        
        if userType == "driver" {//30-June-2017 vikram singh
            
            if  indexPath.row == 3 {
                cell.imgIcon.isHidden = true
                cell.lblTitle.isHidden = true
                let driverStatus = USER_DEFAULT.object(forKey: "driverstatus") as! String
                if AppDelegateVariable.appDelegate.strLanguage == "en" {
                    lblGoOnlineAndOffline = UILabel.init(frame: CGRect(x: 20, y: 10, width: cell.frame.size.width-100, height: 38))
                    switchOnLineOffline = UISwitch.init(frame: CGRect(x: cell.frame.size.width-80, y: 10, width: 60, height: 38))
                }
                else{
                    lblGoOnlineAndOffline = UILabel.init(frame: CGRect(x: 100, y: 5, width: cell.frame.size.width-120, height: 38))
                    lblGoOnlineAndOffline.textAlignment = NSTextAlignment.right
                    switchOnLineOffline = UISwitch.init(frame: CGRect(x: 20, y: 10, width: 60, height: 38))
                }
                cell.addSubview(lblGoOnlineAndOffline)
                
                switchOnLineOffline.onTintColor = UIColor.init(red: 255.0/255.0, green: 0/255.0, blue: 141.0/255.0, alpha: 1.0)
                switchOnLineOffline.addTarget(self, action: #selector(switchOnlineAndOffline(_:)), for: .valueChanged)
              
                if driverStatus == "No" {
                    switchOnLineOffline.setOn(true, animated: true)
                    if AppDelegateVariable.appDelegate.strLanguage == "ar" {
                        lblGoOnlineAndOffline.text = "عبر الانترنت  "
                    }else{
                    lblGoOnlineAndOffline.text = "Go Online"
                    }
                }
                else{
                    switchOnLineOffline.setOn(false, animated: true)
                    if AppDelegateVariable.appDelegate.strLanguage == "ar" {
                        lblGoOnlineAndOffline.text = "الانتقال إلى وضع عدم الاتصال"
                    }else{
                        lblGoOnlineAndOffline.text = "Go Offline"
                    }

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
        else{
            dic = arrLeftMenu[indexPath.row] as NSDictionary
            cell.imgIcon.image = UIImage.init(named:  dic.value(forKey: "image")! as! String)
            cell.lblTitle.text = dic.value(forKey: "key") as! String?
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SlideNavigationController.sharedInstance().toggleRightMenu()
        if userType == "user" {
            
            switch indexPath.row {
            case 0:
                let obj : HomeViewControlle = HomeViewControlle(nibName: "HomeViewControlle", bundle: nil)
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obj, withCompletion: nil)
            case 1:
                
                let obj : MyRidesVC = MyRidesVC(nibName: "MyRidesVC", bundle: nil)
                
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obj, withCompletion: nil)
            case 2:
                let obj : WalletViewController = WalletViewController(nibName: "WalletViewController", bundle: nil)
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obj, withCompletion: nil)
            case 3:
                let moveViewController : ShareAppViewController = ShareAppViewController(nibName: "ShareAppViewController", bundle: nil)
                SlideNavigationController.sharedInstance().isPopViewController = true
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: moveViewController, withCompletion: nil)
                
                //                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: moveViewController, withSlideOutAnimation: nil, andCompletion: nil)
                print("GetFreeRides")
                break
            case 4:
                let obj : SettingViewController = SettingViewController(nibName: "SettingViewController", bundle: nil) as SettingViewController
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obj, withCompletion: nil)
            case 5:
                let moveViewController : ContactUSController = ContactUSController(nibName: "ContactUSController", bundle: nil)
                SlideNavigationController.sharedInstance().isPopViewController = true
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: moveViewController, withSlideOutAnimation: true, andCompletion: nil)
                print("Contact Sceen design.")
            case 6:
                if #available(iOS 10, *) {
                    UIApplication.shared.open(URL(string: "http://taxiappsourcecode.com/tawasilataxi/contact_us")!, options: [ : ], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string: "http://taxiappsourcecode.com/tawasilataxi/contact_us")!)
                }
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
                USER_DEFAULT.set("0", forKey: "isLogin")
                AppDelegateVariable.appDelegate.sliderMenuControllser()
                
            case 2:
                print("Tawsila")
            default:
                print("ViewController not Found.")
            }
        }
    }
    
    @IBAction func switchOnlineAndOffline(_ sender:UISwitch) {
        if sender.isOn {
            if AppDelegateVariable.appDelegate.strLanguage == "ar" {
                lblGoOnlineAndOffline.text = "عبر الانترنت  "
            }else{
                lblGoOnlineAndOffline.text = "Go Online"
            }
        }
        else{
            if AppDelegateVariable.appDelegate.strLanguage == "ar" {
                lblGoOnlineAndOffline.text = "الانتقال إلى وضع عدم الاتصال"
            }else{
                lblGoOnlineAndOffline.text = "Go Offline"
            }
        }
    }
}
