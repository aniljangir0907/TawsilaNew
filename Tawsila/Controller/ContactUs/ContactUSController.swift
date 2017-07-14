//
//  ContactUSController.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/12/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class ContactUSController: UIViewController {

    @IBOutlet weak var viewEnglish: UIView!
    @IBOutlet weak var viewArabic: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        setShowAndHideViews(viewEnglish, vArb: viewArabic)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionCancel(_ sender: Any) {
       dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func actionCallUs(_ sender: Any) {
      let alert = UIAlertController(title: "Tawsila", message: "Call +7240001888", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) {  (action: UIAlertAction!) in
            if let url = URL(string: "tel://7240001888"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func actionMessageSendUs(_ sender: Any) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(URL(string: "http://taxiappsourcecode.com/tawasilataxi/contact_us")!, options: [ : ], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: "http://taxiappsourcecode.com/tawasilataxi/contact_us")!)
        }
    }
}
