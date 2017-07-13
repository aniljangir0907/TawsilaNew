//
//  GetFreeRides.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/5/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class GetFreeRides: UIViewController {

    var strInvitationCode : String!
    @IBOutlet weak var viewEnglish: UIView!
    @IBOutlet weak var lblFreeCredits: UILabel!
    @IBOutlet weak var lblinviteFriend: UILabel!
    @IBOutlet weak var lblInvitationCode: UILabel!
    @IBOutlet weak var btnCopyInvitationCode: UIButton!
    @IBOutlet weak var viewBackGround: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
         self.view.backgroundColor = UIColor.clear
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func actionCopyInvitationCode(_ sender: Any) {
        if  lblInvitationCode.text != nil {
            strInvitationCode = lblInvitationCode.text
        }else {
            
        }
        
    }
    @IBAction func actionInviteFriends(_ sender: Any) {
        let strText : String = "Let me recommend you this application\n\n\n http://chauffeur-taxi.com/tawadmin/ "
        
        let activityViewController = UIActivityViewController(activityItems: [strText], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.postToFacebook,
           UIActivityType.postToTwitter,
            UIActivityType.postToWeibo,
            UIActivityType.message,
            UIActivityType.mail,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo,
            UIActivityType.airDrop,
            UIActivityType.openInIBooks]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    

}
