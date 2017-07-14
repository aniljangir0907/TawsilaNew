//
//  PayBillDetails.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/2/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class PayBillDetails: UIView {

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var viewPayBill: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnGoToMyRide: UIButton!
    
    // View Arabic
    @IBOutlet weak var lblAmountAr: UILabel!
    @IBOutlet weak var viewPayBillAr: UIView!
    @IBOutlet weak var lblAddressAr: UILabel!
    @IBOutlet weak var btnGoToMyRideAr: UIButton!
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBehavior()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
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
//        let obj: AllRides = AllRides(nibName: "AllRides", bundle: nil) 
//        setPushViewTransition(obj)
    }


}
