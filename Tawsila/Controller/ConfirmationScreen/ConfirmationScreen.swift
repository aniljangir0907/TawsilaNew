//
//  ConfirmationScreen.swift
//  Tawsila
//
//  Created by vikram singh charan on 6/19/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class ConfirmationScreen: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var txtVerificationCode: UITextField!
    @IBOutlet var txtVerficationCodeAr: UITextField!
   @IBOutlet var viewArabic: UIView!
    @IBOutlet var viewEnglish: UIView!
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    //MARK:- UIButton's Action
    @IBAction func actionContinue(_ sender: Any) {
       // AppDelegateVariable.appDelegate.sliderMenuControllser()
        let loginView: SignInViewController = SignInViewController(nibName: "SignInViewController", bundle: nil)
        setPushViewTransition(loginView)
    }
    
    @IBAction func actionDidNotGetCode(_ sender: Any) {
        AppDelegateVariable.appDelegate.sliderMenuControllser()
    }
    @IBAction func actionResendCode(_ sender: Any) {
        AppDelegateVariable.appDelegate.sliderMenuControllser()
    }
    
    //MARK: -UITextField Delegate Method implemnet
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }


}

