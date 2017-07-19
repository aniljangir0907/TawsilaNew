//
//  PayBillDetails.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/2/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class PayBillDetails: UIView {

    @IBOutlet var bntGoMyRide: UIButton!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var viewPayBill: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnGoToMyRide: UIButton!
    @IBOutlet var lblAddressDest: UILabel!
    
    // View Arabic
    @IBOutlet weak var lblAmountAr: UILabel!
    @IBOutlet weak var viewPayBillAr: UIView!
    @IBOutlet weak var lblAddressAr: UILabel!
    @IBOutlet weak var btnGoToMyRideAr: UIButton!
 
    @IBOutlet var car_type: UILabel!
    var selfBack = UIViewController()
    
    override func draw(_ rect: CGRect) {
           
       // addBehavior()
    }
    
    func addBehavior() {
        print("Add all the behavior here")
        if  AppDelegateVariable.appDelegate.strLanguage == "en" {
            viewPayBill.isHidden = false
            viewPayBillAr.isHidden = true
            viewPayBill.layer.cornerRadius = 4.0
            viewPayBill.layer.masksToBounds = true
            viewPayBill.layer.borderColor = UIColor.lightGray.cgColor
            viewPayBill.layer.borderWidth = 1.0
        }else{
            viewPayBill.isHidden = true
            viewPayBillAr.isHidden = false
            viewPayBillAr.layer.cornerRadius = 4.0
            viewPayBillAr.layer.masksToBounds = true
            viewPayBillAr.layer.borderColor = UIColor.lightGray.cgColor
            viewPayBillAr.layer.borderWidth = 1.0
        }
        
    }
    
  
    
    @IBAction func actionGotoRideScreen(_ sender: Any) {

//        let obje: AllRides = AllRides(nibName: "AllRides", bundle: nil) as AllRides
//        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obje, withCompletion: nil)
        
//        let obj: AllRides = AllRides(nibName: "AllRides", bundle: nil)
//   self.selfBack.navigationController?.pushViewController(obj, animated: true)
    }


}
