//
//  AllRideCell.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/2/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class AllRideCell: UITableViewCell {
    
    // View english
    @IBOutlet var viewEnglish: UIView!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblPrcie: UILabel!
    @IBOutlet var imgUserProfile: UIImageView!
    @IBOutlet var lblCarModel: UILabel!
    @IBOutlet var lblInitialAddress: UILabel!
    @IBOutlet var lblDestinationAddress: UILabel!
    
    
    // view Arabic
    @IBOutlet var viewAraic: UIView!
    @IBOutlet var lblDateTimeAr: UILabel!
    @IBOutlet var lblPrcieAr: UILabel!
    @IBOutlet var imgUserProfileAr: UIImageView!
    @IBOutlet var lblCarModelAr: UILabel!
    @IBOutlet var lblInitialAddressAr: UILabel!
    @IBOutlet var lblDestinationAddressAr: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgUserProfile.layer.cornerRadius = imgUserProfile.frame.size.height/2
        imgUserProfile.layer.borderColor = UIColor
            .white.cgColor
        imgUserProfile.layer.borderWidth = 0.5
        imgUserProfile.layer.masksToBounds = true
        
        imgUserProfileAr.layer.cornerRadius = imgUserProfileAr.frame.size.height/2
        imgUserProfileAr.layer.borderColor = UIColor
            .white.cgColor
        imgUserProfileAr.layer.borderWidth = 0.5
        imgUserProfileAr.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setDataOnCell(_ dic: NSDictionary){
      
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            lblPrcie.text = "\(dic.value(forKey: "amount") as! String) SAR"
            lblDateTime.text = "\(dic.value(forKey: "pickup_date") as! String)  \(dic.value(forKey: "pickup_time") as! String)"
            lblCarModel.text = "\(dic.value(forKey: "car_type") as! String)"
            lblInitialAddress.text = "\(dic.value(forKey: "pickup_area") as! String)"
            lblDestinationAddress.text = "\(dic.value(forKey: "drop_area") as! String)"
            
        }else{
            lblPrcieAr.text = "\(dic.value(forKey: "amount") as! String) SAR"
            lblDateTimeAr.text = "\(dic.value(forKey: "pickup_date") as! String)  \(dic.value(forKey: "pickup_time") as! String)"
            lblCarModelAr.text = "\(dic.value(forKey: "car_type") as! String)"
            lblInitialAddressAr.text = "\(dic.value(forKey: "pickup_area") as! String)"
            lblDestinationAddressAr.text = "\(dic.value(forKey: "drop_area") as! String)"
        }
    }
    
}
