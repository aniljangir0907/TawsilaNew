//
//  CancelView.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/2/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class CancelView: UIView {

    @IBOutlet weak var viewEnglish: UIView!
    @IBOutlet weak var viewArabic: UIView!
    
    
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
            viewEnglish.isHidden = false
            viewArabic.isHidden  = true
            viewEnglish.layer.cornerRadius = 4.0
            viewEnglish.layer.masksToBounds = true
            viewEnglish.layer.borderColor = UIColor.lightGray.cgColor
            viewEnglish.layer.borderWidth = 1.0
         }else{
            viewEnglish.isHidden = true
            viewArabic.isHidden  = false
            viewArabic.layer.cornerRadius = 4.0
            viewArabic.layer.masksToBounds = true
            viewArabic.layer.borderColor = UIColor.lightGray.cgColor
            viewArabic.layer.borderWidth = 1.0
        }
       
        
    }
    
    @IBAction func actionReasonForCancel(_ sender: Any) {
    }
    @IBAction func actionCancel(_ sender: Any) {
    }
    @IBAction func actionOk(_ sender: Any) {
    }

}
