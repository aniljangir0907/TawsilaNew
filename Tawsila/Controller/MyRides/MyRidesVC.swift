//
//  MyRidesVC.swift
//  Tawsila
//
//  Created by vikram singh charan on 6/13/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import RappleProgressHUD

class MyRidesVC: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var viewArabic: UIView!
    @IBOutlet var tblMyRides: UITableView!
    @IBOutlet var tblMyRidesAr: UITableView!
    @IBOutlet var viewEnglish: UIView!
    @IBOutlet weak var lblNotFound: UILabel!
    @IBOutlet weak var img_notFound: UIImageView!
    var arrayRideData : NSMutableArray = []
    var arrayCurrentData : NSMutableArray = []
    var arrayCompletedData : NSMutableArray = []
    var arrayScheduledData : NSMutableArray = []
    var status:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        status = "current"
        img_notFound.isHidden = true
        self.tblMyRides.tableFooterView = UIView()
        self.tblMyRidesAr.tableFooterView = UIView()
        self.getAllMyRide()
        setShowAndHideViews(viewEnglish, vArb: viewArabic)
    }
    
    func getAllMyRide()
    {
        self.arrayCurrentData.removeAllObjects()
        self.arrayRideData.removeAllObjects()
        self.arrayCompletedData.removeAllObjects()
        self.arrayScheduledData.removeAllObjects()
        
        if  Reachability.isConnectedToNetwork() == false
        {
            Utility.sharedInstance.showAlert("Alert", msg: "Internet Connection not Availabel!", controller: self)
            return
        }
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
        let parameterString = String(format : "get_user_booking&username=%@",((USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "username") as? String)!)
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
            if status == true
            {
                let userDict = dataDictionary.object(forKey: "result") as! NSArray
                if msg == "No record found"
                {
                    Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
                }
                else
                {
                    self.arrayRideData = userDict.mutableCopy()  as! NSMutableArray
                   // var dic : NSDictionary!
                    for  dic in self.arrayRideData {
                        let dict = dic as! NSDictionary
                   //        Completed,Cancelled ,Booking,Processing
                        if (((dict.value(forKey: "status") as! String) == "Processing")){
                            self.arrayCurrentData.add(dict)
                        }else if (((dict.value(forKey: "status") as! String) == "Cancelled") || ((dict.value(forKey: "status") as! String) == "Completed")) {
                            self.arrayCompletedData.add(dict)
                        }
                        else if ((dict.value(forKey: "status") as! String) == "Scheduled") {
                            self.arrayScheduledData.add(dict)
                            
                        }
                    }
                    if AppDelegateVariable.appDelegate.strLanguage == "en"{
                        self.tblMyRides.reloadData()
                    }else {
                        self.tblMyRidesAr.reloadData()
                    }
                }
                RappleActivityIndicatorView.stopAnimation()
            }
            else {
                RappleActivityIndicatorView.stopAnimation()
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    //MARK:- UITableViewDelegate and DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if status == "current" {
            return arrayCurrentData.count
        }else if status == "Completed"{
            return arrayCompletedData.count
        }else if status == "Scheduled"{
            return arrayScheduledData.count
        }else{
        return arrayRideData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        img_notFound.isHidden = true
        tableView.register(UINib(nibName: "MyRidesTableViewCell", bundle: nil), forCellReuseIdentifier: "cellMyRides")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMyRides", for: indexPath) as! MyRidesTableViewCell
         setShowAndHideViews(cell.viewEnglish, vArb: cell.viewAraic)
        var dic : NSDictionary?
       
        print("Status : - ",status)
        if status == "current" {
            dic  = arrayCurrentData[indexPath.row] as? NSDictionary
        }else if status == "Completed"{
            dic  = arrayCompletedData[indexPath.row] as? NSDictionary
        }else if status == "Scheduled" {
            dic  = arrayScheduledData[indexPath.row] as? NSDictionary
        }
        print(dic!)
        
        cell.setDataInCell(dic!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 181.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if status == "Completed" || status == "Scheduled" {
            let obje: bookingViewController = bookingViewController(nibName: "bookingViewController", bundle: nil)
            obje.dataDictionary = arrayCompletedData[indexPath.row] as! NSDictionary
            setPushViewTransition(obje)
        }
    }
    
    //MARK: - UIButtons actions perform  here
    @IBAction func actionLeftMenu(_ sender: Any) {
        SlideNavigationController.sharedInstance().toggleLeftMenu()
    }
    
    @IBAction func actionRightMenu(_ sender: Any) {
        SlideNavigationController.sharedInstance().toggleRightMenu()
    }
    
    @IBAction func actionCurrent(_ sender: Any) {
        status = "current"
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            if arrayCurrentData.count == 0  {
                tblMyRides.isHidden = true
                 img_notFound.isHidden = false
            }
            else{
                tblMyRides.isHidden = false
                 tblMyRides.reloadData()
            }
        }
        else{
            if arrayCurrentData.count == 0  {
                tblMyRidesAr.isHidden = true
                 img_notFound.isHidden = false
            }
            else{
                tblMyRidesAr.isHidden = false
                tblMyRidesAr.reloadData()
            }
        }
    }
    
    @IBAction func actionCompelted(_ sender: Any) {
        status = "Completed"
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            if arrayCompletedData.count == 0  {
                tblMyRides.isHidden = true
                 img_notFound.isHidden = false
            }
            else{
                tblMyRides.isHidden = false
                tblMyRides.reloadData()
            }
        }
        else{
            if arrayCompletedData.count == 0  {
                tblMyRidesAr.isHidden = true
                 img_notFound.isHidden = false
            }
            else{
                tblMyRidesAr.isHidden = false
                tblMyRidesAr.reloadData()
            }
        }
    }
    
    @IBAction func actionScheduled(_ sender: Any) {
        status = "Scheduled"
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            if arrayScheduledData.count == 0  {
                tblMyRides.isHidden = true
                img_notFound.isHidden = false
            }
            else{
                tblMyRides.isHidden = false
                tblMyRides.reloadData()
            }
        }
        else{
            if arrayScheduledData.count == 0  {
                tblMyRidesAr.isHidden = true
                img_notFound.isHidden = false
            }
            else{
                tblMyRidesAr.isHidden = false
                tblMyRidesAr.reloadData()
            }
        }
        }
    }

