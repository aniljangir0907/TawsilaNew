//
//  BalanceScreenViewController.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/6/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class BalanceScreenViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var txtAmount: ACFloatingTextfield!
    @IBOutlet weak var txtAmountAr: ACFloatingTextfield!
    @IBOutlet weak var viewEnglish: UIView!
    @IBOutlet weak var viewArabic: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setShowAndHideViews(viewEnglish, vArb: viewArabic)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func actionBack(_ sender: Any) {
        actionBackButton(sender)
    }
    
    @IBAction func actionPayNow(_ sender: Any) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}
