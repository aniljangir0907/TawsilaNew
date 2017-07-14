//
//  AcceptAndDeclineView.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/2/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

@objc protocol acceptDeclineDelegate {
    
    func getResponcePopup( value : Bool)
}

class AcceptAndDeclineView: UIView {

    var delegate : acceptDeclineDelegate?
    
    @IBOutlet weak var viewAccept: UIView!
    @IBOutlet weak var lblLabel: UILabel!
    @IBOutlet weak var lblTimeRequest: UILabel!
    
    @IBOutlet weak var viewAcceptAr: UIView!
    @IBOutlet weak var lblLabelAr: UILabel!
    @IBOutlet weak var lblTimeRequestAr: UILabel!
    
    
    override func draw(_ rect: CGRect) {
        
        addBehavior()
    }
    
    func addBehavior() {
        print("Add all the behavior here")
        if AppDelegateVariable.appDelegate.strLanguage
         == "en" {
            viewAccept.isHidden = false
            viewAcceptAr.isHidden = true
            viewAccept.layer.cornerRadius = 4.0
            viewAccept.layer.masksToBounds = true
            viewAccept.layer.borderColor = UIColor.lightGray.cgColor
            viewAccept.layer.borderWidth = 1.0
        }else {
            viewAcceptAr.isHidden = false
            viewAccept.isHidden = true
            viewAcceptAr.layer.cornerRadius = 4.0
            viewAcceptAr.layer.masksToBounds = true
            viewAcceptAr.layer.borderColor = UIColor.lightGray.cgColor
            viewAcceptAr.layer.borderWidth = 1.0
        }
        
    }
    
    @IBAction func actionAcceptRequest(_ sender: Any)
    {
        delegate?.getResponcePopup(value: true)
        self .removeFromSuperview()
    }
    
    @IBAction func actionDeclineRequest(_ sender: Any)
    {
        delegate?.getResponcePopup(value: false)
        self .removeFromSuperview()
    }
    
    @IBAction func actionRemove(_ sender: Any)
    {
       self .removeFromSuperview()
    }
    

}
