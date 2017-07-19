//
//  scheduleView.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/19/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class scheduleView: UIView {

    @IBOutlet weak var viewEnglish: UIView!
    @IBOutlet weak var lblDropLocation: UILabel!
    @IBOutlet weak var lblPickUPDate: UILabel!
    @IBOutlet weak var lblPickUpTime: UILabel!
    @IBOutlet weak var lblEstimateFair: UILabel!
    
    @IBOutlet weak var viewArabic: UIView!
    @IBOutlet weak var lblDropLocationAr: UILabel!
    @IBOutlet weak var lblPickUPDateAr: UILabel!
    @IBOutlet weak var lblPickUpTimeAr: UILabel!
    @IBOutlet weak var lblEstimateFairAr: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func actionConfirm(_ sender: Any) {
    }

}
