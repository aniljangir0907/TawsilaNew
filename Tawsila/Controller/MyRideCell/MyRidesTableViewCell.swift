//
//  MyRidesTableViewCell.swift
//  Tawsila
//
//  Created by vikram singh charan on 6/13/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class MyRidesTableViewCell: UITableViewCell {

    // View english 
    @IBOutlet var viewEnglish: UIView!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblPrcie: UILabel!
    @IBOutlet var imgUserProfile: UIImageView!
    @IBOutlet var lblCarModel: UILabel!
    @IBOutlet var lblInitialAddress: UILabel!
    @IBOutlet var lblDestinationAddress: UILabel!
    @IBOutlet var imgShowStatus: UIImageView!
    
    // view Arabic
    @IBOutlet var viewAraic: UIView!
    @IBOutlet var lblDateTimeAr: UILabel!
    @IBOutlet var lblPrcieAr: UILabel!
    @IBOutlet var imgUserProfileAr: UIImageView!
    @IBOutlet var lblCarModelAr: UILabel!
    @IBOutlet var lblInitialAddressAr: UILabel!
    @IBOutlet var lblDestinationAddressAr: UILabel!
    @IBOutlet var imgShowStatusAr: UIImageView!
    
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
    
    func setDataInCell(_ dic: NSDictionary) -> Void {
        if AppDelegateVariable.appDelegate.strLanguage == "en"{
            lblInitialAddress.text = (dic.value(forKey: "pickup_area")  as!  String)
            lblDestinationAddress.text = (dic.value(forKey: "drop_area")  as!  String)
            lblDateTime.text = "\(dic.value(forKey: "pickup_date")  as!  String)"+" "+"\(dic.value(forKey: "pickup_time")  as!  String)"
            lblCarModel.text = "\(dic.value(forKey: "taxi_type")  as!  String)"+"     "+"CRN- \(dic.value(forKey: "id")  as!  String)"

            
            if ((dic.value(forKey: "status")  as! String == "Processing")||(dic.value(forKey: "status")  as! String == "Booking")) {
                imgShowStatus.image = UIImage.init(named: "ontheway")
                imgUserProfile.isHidden = false
                lblPrcie.isHidden = false
            }
            else if (dic.value(forKey: "status")  as! String == "Cancelled"){
                 imgShowStatus.image = UIImage.init(named: "cancelled")
                imgUserProfile.isHidden = true
                lblPrcie.isHidden = true
            }
            else if (dic.value(forKey: "status")  as! String == "Completed") {
                imgShowStatus.image = UIImage.init(named: "completed")
                imgUserProfile.isHidden = false
                lblPrcie.isHidden = false
            }
            else if (dic.value(forKey: "status")  as! String == "Scheduled") {
                imgShowStatus.image = UIImage.init(named: "scheduled_icon")
                imgUserProfile.isHidden = true
                lblPrcie.isHidden = false
            }
            
            lblPrcie.text = "\(dic.value(forKey: "amount")  as!  String)  SAR"
        } else {
            lblInitialAddressAr.text = (dic.value(forKey: "pickup_area")  as!  String)
            lblDestinationAddressAr.text = (dic.value(forKey: "drop_area")  as!  String)
            lblDateTimeAr.text = "\(dic.value(forKey: "pickup_date")  as!  String)"+" "+"\(dic.value(forKey: "pickup_time")  as!  String)"
            lblCarModelAr.text = "\(dic.value(forKey: "taxi_type")  as!  String)"+"     "+"CRN- \(dic.value(forKey: "id")  as!  String)"
            
            
            if (dic.value(forKey: "status")  as! String == "Processing") {
                imgShowStatusAr.image = UIImage.init(named: "ontheway")
                imgUserProfileAr.isHidden = false
                lblPrcieAr.isHidden = false
            }
            else if (dic.value(forKey: "status")  as! String == "Cancelled"){
                imgShowStatusAr.image = UIImage.init(named: "cancelled")
                imgUserProfileAr.isHidden = true
                lblPrcieAr.isHidden = true
            }
            else{
                imgShowStatusAr.image = UIImage.init(named: "completed")
                imgUserProfileAr.isHidden = false
                lblPrcieAr.isHidden = false
            }
            
            lblPrcieAr.text = "\(dic.value(forKey: "amount")  as!  String)  SAR"
        }
    }
}
