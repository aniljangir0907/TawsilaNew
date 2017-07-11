//
//  RideLaterVC.swift
//  Tawsila
//
//  Created by Sanjay on 11/06/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import RappleProgressHUD

class RideLaterVC: UIViewController ,GMSMapViewDelegate , GMSAutocompleteViewControllerDelegate
{
    
    var viewDatePicker : UIView!
    
    @IBOutlet var pickDate: UITextField!
    @IBOutlet var pickTime: UITextField!
    
    var acController = GMSAutocompleteViewController()
    
    var temp : Int!
    var tempLoc : Int!

    
    @IBOutlet var imgLocation: UIImageView!
    @IBOutlet var imgDest: UIImageView!
    @IBOutlet var btnSchduleRide: UIButton!
    
    var pickUpAddress = String ()
    var car_type = String()

    @IBOutlet var lblDestination: UILabel!
    @IBOutlet var lblLocatoin: UILabel!
    
    var pickUpCordinate : CLLocationCoordinate2D!
    var destinationCordinate : CLLocationCoordinate2D!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgDest.tintColor = UIColor.red
        imgDest.image = imgDest.image?.withRenderingMode(.alwaysTemplate)
        
        imgLocation.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        imgLocation.image = imgDest.image?.withRenderingMode(.alwaysTemplate)
        
        btnSchduleRide.layer.cornerRadius = 3;
        
        lblLocatoin.text = pickUpAddress
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tapPickDate(_ sender: UIButton)
    {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = THEME_COLOR
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RideLaterVC.donePicker))
        
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RideLaterVC.donePicker))
        
        
        
        toolBar.setItems([cancelButton, spaceButton ,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        if sender.tag == 1
        {
            pickTime.inputView = datePickerView
            pickTime.inputAccessoryView = toolBar
            pickTime .becomeFirstResponder()
            datePickerView.datePickerMode = UIDatePickerMode.time
            temp = 0;
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH : mm"
            pickTime.text = dateFormatter.string(from:NSDate() as Date)
            
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            pickDate.text = dateFormatter.string(from:NSDate() as Date)
            
            pickDate.inputView = datePickerView
            pickDate.inputAccessoryView = toolBar
            pickDate .becomeFirstResponder()
            datePickerView.datePickerMode = UIDatePickerMode.date
            
            temp = 1;
        }
        
    }
    
    
    func datePickerValueChanged(sender:UIDatePicker)
    {
        if temp == 1
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/mm/yyyy"
            pickDate.text = dateFormatter.string(from:sender.date as Date)
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH : MM"
            pickTime.text = dateFormatter.string(from:sender.date as Date)
        }
        
        // dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func donePicker()
    {
        pickDate.resignFirstResponder()
        pickTime.resignFirstResponder()
    }
    
    func tapDone(){
        
        UIView.animate(withDuration: 0.2) {
            
            self.viewDatePicker.frame = CGRect(x: 0, y: Constant.ScreenSize.SCREEN_HEIGHT, width: Constant.ScreenSize.SCREEN_WIDTH, height: 200)
        }
        
    }
    
    
    
    @IBAction func tapPickTime(_ sender: Any) {
    }
    
    @IBAction func tapLocation(_ sender: Any)
    {
        acController = GMSAutocompleteViewController()
        present(acController, animated: true, completion: nil)
        acController.delegate = self
        tempLoc = 1
    }
    
    @IBAction func tapDestination(_ sender: Any) {
    
        acController = GMSAutocompleteViewController()
        present(acController, animated: true, completion: nil)
        acController.delegate = self
        tempLoc = 2
        
    }
    
    @IBAction func tapScheduleRide(_ sender: Any)
    {
        if pickDate.text == "Pick Date" {
            
            Utility.sharedInstance.showAlert(kAPPName, msg: "Select Date First" as String, controller: self)

            return;
        }
        
        if pickTime.text == "Pick Time" {
            
            Utility.sharedInstance.showAlert(kAPPName, msg: "Select Time First" as String, controller: self)
            
            return;
        }
        
        if lblDestination.text == "Select Destination" {
            
            Utility.sharedInstance.showAlert(kAPPName, msg: "Select Destination Locatoin First" as String, controller: self)
            
            return;
        }
        
        if lblLocatoin.text == "Pickup Location" {
            
            Utility.sharedInstance.showAlert(kAPPName, msg: "Select Pickup Location First" as String, controller: self)
            
            return;
        }
        
        
       self.FireAPI()
    }
    
    func FireAPI()
    {
        
        let random : String = "24324323"
        let dic = NSMutableDictionary()
        
        dic.setValue("scientificwebs", forKey: "username")
        dic.setValue("PTPT", forKey: "purpose")
        dic.setValue(lblLocatoin.text, forKey: "pickup_area")
        dic.setValue(pickDate.text, forKey: "pickup_date")
        dic.setValue(pickTime.text, forKey: "pickup_time")
        dic.setValue(lblDestination.text, forKey: "drop_area")
        dic.setValue("", forKey: "area")
        dic.setValue("", forKey: "landmark")
        dic.setValue(lblLocatoin.text, forKey: "pickup_address")
        dic.setValue(self.car_type, forKey: "taxi_type")
        // dic.setValue("", forKey: "departure_time")
        // dic.setValue("", forKey: "departure_date")
        // dic.setValue("", forKey: "flight_number")
        // dic.setValue("", forKey: "package")
        // dic.setValue("", forKey: "promo_code")
        dic.setValue("15", forKey: "distance")
        dic.setValue("150", forKey: "amount")
        dic.setValue("jaipur", forKey: "address")
        // dic.setValue("", forKey: "transfer")
        dic.setValue("cash", forKey: "payment_media")
        dic.setValue("150", forKey: "km")
        // dic.setValue("", forKey: "timetype")
        dic.setValue(String (format: "%f", pickUpCordinate.latitude), forKey: "lat")
        dic.setValue(String (format: "%f", pickUpCordinate.longitude), forKey: "long")
        dic.setValue(random, forKey: "random")
        dic.setValue(FCM_TOKEN, forKey: "device_id")
        
        // http://taxiappsourcecode.com/api/index.php?
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
        var parameterString = String(format : "booking_request_schedule")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        
        Utility.sharedInstance.postDataInJson(header: parameterString,  withParameter:dic ,inVC: self) { (dataDictionary, msg, status) in
            
            if msg == "Booking scheduled"
            {
                self.pickTime.text = "Pick Time"
                self.pickDate.text = "Pick Date"
                self.lblLocatoin.text = "Pickup Location"
                self.lblDestination.text = "Select Destination"
            }
            
            if status == true
            {
                var userDict = (dataDictionary.object(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                userDict = AppDelegateVariable.appDelegate.convertAllDictionaryValueToNil(userDict)
                
                self.pickTime.text = "Pick Time"
                self.pickDate.text = "Pick Date"
                self.lblLocatoin.text = "Pickup Location"
                self.lblDestination.text = "Select Destination"
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
        

    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        
        print("Place name: \(place.name)")
        // print("Place address: \(place.formattedAddress)")
        // print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
        
        if tempLoc == 1 {
            pickUpCordinate = place.coordinate
            lblLocatoin.text = place.formattedAddress
        }
        else{
            destinationCordinate = place.coordinate
            lblDestination.text = place.formattedAddress
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}


