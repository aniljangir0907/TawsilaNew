//
//  Contact Us.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/5/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class Contact_Us: UIViewController {
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
    

    
    @IBAction func actionCancel(_ sender: Any) {
        
    }
    
    @IBAction func actionCallUs(_ sender: Any) {
        
    }
    
    @IBAction func actionMessageSendUs(_ sender: Any) {
    }
}
