//
//  bookingViewController.swift
//  Tawsila
//
//  Created by vikram singh charan on 6/15/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import RappleProgressHUD

class bookingViewController: UIViewController {
    var dataDictionary: NSDictionary!
    //  View English
    @IBOutlet var viewEng: UIView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var userProfilePic: UIImageView!
    @IBOutlet var imgCancel: UIImageView!
    @IBOutlet var lblCarModel: UILabel!
    @IBOutlet var lblCarNumber: UILabel!
    @IBOutlet var lblAmout: UILabel!
    @IBOutlet var lblHours: UILabel!
    @IBOutlet var lblMin: UILabel!
    @IBOutlet var lblInitialLocation: UILabel!
    @IBOutlet var lblDestinationLocation: UILabel!
    @IBOutlet var viewFare: UIView!
    @IBOutlet var lblRideFare: UILabel!
     @IBOutlet var lblTaxes: UILabel!
     @IBOutlet var lblTotalBill: UILabel!
    
    // view Arabic
    @IBOutlet var viewArabic: UIView!
    @IBOutlet var lblUserNameAr: UILabel!
    @IBOutlet var userProfilePicAr: UIImageView!
    @IBOutlet var imgCancelAr: UIImageView!
    @IBOutlet var lblCarModelAr: UILabel!
    @IBOutlet var lblCarNumberAr: UILabel!
    @IBOutlet var lblAmoutAr: UILabel!
    @IBOutlet var lblHoursAr: UILabel!
    @IBOutlet var lblMinAr: UILabel!
    @IBOutlet var lblInitialLocationAr: UILabel!
    @IBOutlet var lblDestinationLocationAr: UILabel!
    @IBOutlet var viewFareAr: UIView!
    @IBOutlet var lblRideFareAr: UILabel!
    @IBOutlet var lblTaxesAr: UILabel!
    @IBOutlet var lblTotalBillAr: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        setShowAndHideViews(viewEng, vArb: viewArabic)
      //  setDataOnViewController(dataDictionary)
        getBookingDetails()
    }
    func setDataOnViewController(_ dic: NSDictionary){
        print(dic)
        if (dic.value(forKey: "status")  as! String == "Cancelled") {
            if AppDelegateVariable.appDelegate.strLanguage == "en" {
                viewFare.isHidden = true
                imgCancel.isHidden = false
            }else{
                viewFareAr.isHidden = true
                imgCancelAr.isHidden = false
            }
        }
        else{
            if AppDelegateVariable.appDelegate.strLanguage == "en" {
                viewFare.isHidden = false
                imgCancel.isHidden = true
            }else{
                viewFareAr.isHidden = false
                imgCancelAr.isHidden = true
            }
        }
        
        
    }
    
    func getBookingDetails() {
        
        if  Reachability.isConnectedToNetwork() == false
        {
            Utility.sharedInstance.showAlert("Alert", msg: "Internet Connection not Availabel!", controller: self)
            return
        }
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
//        let parameterString = String(format : "get_booking_details&booking_id=%@",
//                                     self.dataDictionary.value(forKey: "id") as! String)
//        print(parameterString)
  
        let dic = NSMutableDictionary()
        
        dic .setValue("driver", forKey: "usertype")
        dic .setValue(dataDictionary.value(forKey: "assigned_for"), forKey: "id")
        
        // RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "get_user_profile")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        print(parameterString)
        
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
                    
                    
//                    self.arrayRideData = userDict.mutableCopy()  as! NSMutableArray
//                    // var dic : NSDictionary!
//                    for  dic in self.arrayRideData {
//                        let dict = dic as! NSDictionary
//                        //        Completed,Cancelled ,Booking,Processing
//                        if (((dict.value(forKey: "status") as! String) == "Processing") || ((dict.value(forKey: "status") as! String) == "Booking")){
//                            self.arrayCurrentData.add(dict)
//                        }else if (((dict.value(forKey: "status") as! String) == "Cancelled") || ((dict.value(forKey: "status") as! String) == "Completed")) {
//                            self.arrayCompletedData.add(dict)
//                        }
//                    }
//                    if AppDelegateVariable.appDelegate.strLanguage == "en"{
//                        self.tblMyRides.reloadData()
//                    }else {
//                        self.tblMyRidesAr.reloadData()
//                    }
               }
            }
            else {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }

    func getUSerDetails(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionBack(_ sender: Any) {
        actionBackButton(sender)
    }


}
