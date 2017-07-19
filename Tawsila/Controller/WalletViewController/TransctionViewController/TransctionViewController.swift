//
//  TransctionViewController.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/6/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class TransctionViewController: UIViewController {
    
    var hometag = Bool()
    
    @IBOutlet weak var viewEnglish: UIView!
    @IBOutlet weak var viewmain: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPaymentID: UILabel!
    @IBOutlet weak var viewArabic: UIView!
    @IBOutlet weak var viewmainAr: UIView!
    @IBOutlet weak var lblStatusAr: UILabel!
    @IBOutlet weak var lblAmountAr: UILabel!
    @IBOutlet weak var lblPaymentIDAr: UILabel!
    var payAmount = String()
    var payId = String()
    //var payAmount = String()
    
    @IBOutlet var imgSccessFail: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setShowAndHideViews(viewEnglish, vArb: viewArabic)
        
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            lblAmount.text = payAmount
            lblPaymentID.text = payId
        }
        else{
            lblAmountAr.text = payAmount
            lblPaymentIDAr.text = payId
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionBack(_ sender: Any) {
        actionBackButton(sender)
    }
    
    @IBAction func actionOk(_ sender: Any) {
        actionBackButton(sender)
        
        if self.hometag == true
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
