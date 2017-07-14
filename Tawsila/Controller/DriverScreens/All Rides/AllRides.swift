//
//  AllRides.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/2/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class AllRides: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var arrAllRide : NSArray!
    @IBOutlet weak var btnTitle: UILabel!
    @IBOutlet weak var btnRightMenu: UIButton!
    @IBOutlet weak var btnLeftMenu: UIButton!
    @IBOutlet weak var tblAllRide: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewAccordingLanguage()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animation: Bool) {
        setViewAccordingLanguage()
        tblAllRide.delegate = self
        tblAllRide.dataSource = self
        
    }
    func setViewAccordingLanguage() {
        if AppDelegateVariable.appDelegate.strLanguage == "ar" {
            btnTitle.text = "جميع ركوب الخيل"
            btnLeftMenu.isHidden = true
            btnRightMenu.isHidden = false
        }
        else{
            btnTitle.text = "All Rides"
            btnLeftMenu.isHidden = false
            btnRightMenu.isHidden = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actionRightMenu(_ sender: Any) {
        SlideNavigationController.sharedInstance().toggleRightMenu()
    }
    @IBAction func actionLeftMenu(_ sender: Any) {
        SlideNavigationController.sharedInstance().toggleLeftMenu()
    }
    
    //MARK:- UITableView Delegate and DataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "AllRideCell", bundle: nil), forCellReuseIdentifier: "AllRideCell")
        var cell : AllRideCell = tableView.dequeueReusableCell(withIdentifier: "AllRideCell", for: indexPath) as! AllRideCell
        
        if cell == nil{
            cell = tableView.dequeueReusableCell(withIdentifier: "AllRideCell", for: indexPath) as! AllRideCell
        }
        setShowAndHideViews(cell.viewEnglish, vArb: cell.viewAraic)
      //  cell.setDataOnCell(<#T##dic: NSDictionary##NSDictionary#>)
        return cell
    }
    
}
