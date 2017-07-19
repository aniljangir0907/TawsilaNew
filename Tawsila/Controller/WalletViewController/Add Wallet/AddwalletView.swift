//
//  AddwalletView.swift
//  Tawsila
//
//  Created by Sanjay on 19/07/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class AddwalletView: UIView {

    @IBOutlet var btnAddNow: btnCustomeClass!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var lblAmountAdd: UILabel!
    
    override func draw(_ rect: CGRect) {
        
        txtAmount.leftViewMode = UITextFieldViewMode.always
        let img =  UIImageView.init(frame: CGRect(x: 0, y: 10, width: 20, height: txtAmount.frame.size.height-20))
        img.image = UIImage(named: "doller_icon")
        txtAmount.leftView = img
        
        txtAmount.text = AppDelegateVariable.appDelegate.wallet_amount+" SAR"

    }

    @IBAction func actionAmount(_ sender: UIButton) {
        
        txtAmount.text = sender.titleLabel?.text        
    }

}
