//
//  AllRides.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/2/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import RappleProgressHUD

class AllRides: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrayRideData : NSMutableArray = []
    @IBOutlet weak var btnTitle: UILabel!
    @IBOutlet weak var btnRightMenu: UIButton!
    @IBOutlet weak var btnLeftMenu: UIButton!
    @IBOutlet weak var tblAllRide: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewAccordingLanguage()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animation: Bool) {
        setViewAccordingLanguage()
        tblAllRide.delegate = self
        tblAllRide.dataSource = self
        self.getAllMyRide()
    }
    func setViewAccordingLanguage() {
        if AppDelegateVariable.appDelegate.strLanguage == "ar" {
            btnTitle.text = "بلدي ركوب الخيل"
            btnLeftMenu.isHidden = true
            btnRightMenu.isHidden = false
        }
        else{
            btnTitle.text = "My Rides"
            btnLeftMenu.isHidden = false
            btnRightMenu.isHidden = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actionRightMenu(_ sender: Any) {
        SlideNavigationController.sharedInstance().toggleRightMenu()
    }
    @IBAction func actionLeftMenu(_ sender: Any) {
        SlideNavigationController.sharedInstance().toggleLeftMenu()
    }
    
    //MARK:- UITableView Delegate and DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayRideData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "AllRideCell", bundle: nil), forCellReuseIdentifier: "AllRideCell")
        var cell : AllRideCell = tableView.dequeueReusableCell(withIdentifier: "AllRideCell", for: indexPath) as! AllRideCell
        
        if cell == nil{
            cell = tableView.dequeueReusableCell(withIdentifier: "AllRideCell", for: indexPath) as! AllRideCell
        }
        setShowAndHideViews(cell.viewEnglish, vArb: cell.viewAraic)
        let dic  = arrayRideData[indexPath.row] as! NSDictionary
        cell.setDataOnCell(dic)
        return cell
    }
    
    // get Driver all rides
    func getAllMyRide()
    {
        if  Reachability.isConnectedToNetwork() == false
        {
            Utility.sharedInstance.showAlert("Alert", msg: "Internet Connection not Availabel!", controller: self)
            return
        }
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
        let parameterString = String(format : "get_driver_booking&user_id=%@",USER_ID)
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                let userDict = dataDictionary.object(forKey: "result") as! NSArray
                
                print(userDict.count)
                print(userDict)
                if msg == "No record found"
                {
                    Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
                }
                else
                {
                    self.arrayRideData = userDict.mutableCopy()  as! NSMutableArray
                    self.tblAllRide.reloadData()
                }
            }
            else {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
}
