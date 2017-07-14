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
        imgUserProfile.layer.masksToBounds = true
        
        imgUserProfileAr.layer.cornerRadius = imgUserProfileAr.frame.size.height/2
        imgUserProfileAr.layer.masksToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setDataOnCell(_ dic: NSDictionary){
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            
        }else{
            
        }
    }

}
