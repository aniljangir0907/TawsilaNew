//
//  AddWallet.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/18/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import CoreText

class AddWallet: UIViewController {

    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var lblAmountAdd: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        txtAmount.leftViewMode = UITextFieldViewMode.always
        let img =  UIImageView.init(frame: CGRect(x: 0, y: 10, width: 20, height: txtAmount.frame.size.height-20))
        img.image = UIImage(named: "doller_icon")
        txtAmount.leftView = img
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func actionBack(_ sender: Any) {
        actionBackButton(sender)
    }
    @IBAction func actionAddNow(_ sender: Any) {
    }
    
    @IBAction func actionAmount(_ sender: UIButton) {
        
        txtAmount.text = sender.titleLabel?.text
        
        if  sender.tag == 0 {
            
        }
         else  if  sender.tag == 1 {
                
        }else  if sender.tag == 2 {
            
        }else  if sender.tag == 3 {
            
        }else  if sender.tag == 4 {
            
        }else  if sender.tag == 5 {
            
        }
    }
    
    

}
