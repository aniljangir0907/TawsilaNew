//
//  SignInOrCreateNewAccount.swift
//  Tawsila
//
//  Created by Dinesh Mahar on 10/06/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
@IBDesignable
class btnCustomeClass: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 4.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}

class SignInOrCreateNewAccount: UIViewController {
    @IBOutlet var viewArabic: UIView!
    
    @IBOutlet var btnCreateNewAccount: UIButton!
    @IBOutlet var viewEnglish: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // AppDelegateVariable.appDelegate.checkNewVerisonAvailabel(viewController: self)
      
    }
    override func viewWillAppear(_ animated: Bool) {
        setShowAndHideViews(viewEnglish, vArb: viewArabic)
    }
    override func viewDidDisappear(_ animated: Bool) {

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionSignIn(_ sender: Any) {
        let obj : SignInViewController = SignInViewController(nibName: "SignInViewController", bundle: nil)
        setPushViewTransition(obj)
    }
    
    @IBAction func actionCreateNewAccout(_ sender: Any) {
        let obj : CreateNewAccount = CreateNewAccount(nibName: "CreateNewAccount", bundle: nil)
         setPushViewTransition(obj)
    }
}
