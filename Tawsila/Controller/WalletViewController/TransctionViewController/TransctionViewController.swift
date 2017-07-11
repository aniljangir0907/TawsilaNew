//
//  TransctionViewController.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/6/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class TransctionViewController: UIViewController {

    @IBOutlet weak var viewmain: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPaymentID: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func actionBack(_ sender: Any) {
    }
    
    @IBAction func actionOk(_ sender: Any) {
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
