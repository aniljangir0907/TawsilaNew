//
//  DriverHomeScreen.swift
//  Tawsila
//
//  Created by vikram singh charan on 6/30/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import RappleProgressHUD
import Alamofire
import SDWebImage
import UserNotifications
import AVFoundation
import SwiftySound

class DriverHomeScreen: UIViewController, GMSMapViewDelegate, SlideNavigationControllerDelegate, UNUserNotificationCenterDelegate , acceptDeclineDelegate {
    
    
    var mapView: GMSMapView!
    var acController = GMSAutocompleteViewController()
    var locationManager = CLLocationManager()
    var rightBarButton : UIBarButtonItem!
    var pickUpCordinate : CLLocationCoordinate2D!
    var destinationCordinate : CLLocationCoordinate2D!
    
    @IBOutlet var viewArabic: UIView!
    @IBOutlet var viewMap: UIView!
    @IBOutlet var viewMapAr: UIView!
    @IBOutlet var viewEnglish: UIView!
    
    var dicIds = NSMutableDictionary()
    
    var booking_id = String()
    var rider_id = String()
    var rider_username = String()
    
    var popUp = AcceptAndDeclineView()
    
    var array_Booking_List = NSArray()
    
    var  mode = Bool()
    
    var  is_popup = Bool()
    
    var is_location = Bool()
    
    var is_update = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // -- Locaton Manager
        
        mode = false
        is_location = false
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        
        self .perform( #selector(self.updateLocation), with: 1, afterDelay: 0)
        
//        let popUp = Bundle.main.loadNibNamed("PayBillDetails", owner: self, options: nil)![0] as? UIView as! PayBillDetails
//        popUp.frame = self.view.frame
//        self.view.addSubview(popUp)
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
        
        self.dicIds = DLRadioButton.getDictionary() as! NSMutableDictionary

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super .viewDidAppear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super .viewDidDisappear(true)

        self.mode = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setShowAndHideViews(viewEnglish, vArb: viewArabic)
        self.mode = false
        self.is_popup = false
        self .perform( #selector(self.updateLocation), with: 1, afterDelay: 0)

        if AppDelegateVariable.appDelegate.id_booking == "cancel"
        {
            self.mode = false
            Utility.sharedInstance.showAlert(kAPPName, msg: "Ride cancelled by Rider", controller: self)
            AppDelegateVariable.appDelegate.id_booking = "NO";

        }
        
        if is_location == true
        {
            self.perform( #selector(self.perform_update_location), with: 1, afterDelay: 0)
        }
        else
        {
            // Utility.sharedInstance.showAlert(kAPPName, msg: "location not found", controller: self)
        }
      
    }
    // MARK: SlideNavigationController Delegate
    @IBAction func actionLeftMenu(_ sender: Any) {
        SlideNavigationController.sharedInstance().toggleLeftMenu()
    }
    @IBAction func actionRightMenu(_ sender: Any) {
        SlideNavigationController.sharedInstance().toggleRightMenu()
    }
    // MARK:
    // MARK: - MapView Delegate
    
    func updateLocation()
    {
        let lat = locationManager.location?.coordinate.latitude
        let lon = locationManager.location?.coordinate.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: lon!, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self as GMSMapViewDelegate
        mapView.isMyLocationEnabled = true
        mapView.camera = camera
        mapView.frame = CGRect(x: 0, y: 0, width: Constant.ScreenSize.SCREEN_WIDTH, height: Constant.ScreenSize.SCREEN_HEIGHT)
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            viewMap.addSubview(mapView)
        }else{
            viewMapAr.addSubview(mapView)
        }
        
        is_location = true
        self.perform( #selector(self.perform_update_location), with: 1, afterDelay: 1)
        

    }
    
    func perform_update_location() {
        
        let dic = NSMutableDictionary()
        
        dic.setValue(USER_ID, forKey: "user_id")
        dic.setValue(String (format: "%f", (locationManager.location!.coordinate.latitude)), forKey: "lat")
        dic.setValue(String (format: "%f", (locationManager.location!.coordinate.longitude)), forKey: "long")
        
        ///RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "save_driver_location")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if self.mode == false
            {
                self.perform( #selector(self.perform_update_location), with: 1, afterDelay: 1)
            }
            
            if status == true
            {
                if self.mode == false && self.is_popup == false
                {
                    
                    self.array_Booking_List = dataDictionary.value(forKey: "result") as! NSArray
                    
                    if  (self.array_Booking_List.count > 0)
                    {
                        let dic : NSDictionary = (self.array_Booking_List.object(at: 0) as! NSDictionary )
                        
                        if dic.count > 0
                        {
                            
                            self.booking_id = (self.array_Booking_List.object(at: 0) as! NSDictionary ).value(forKey: "booking_id") as! String
                            
                            self.rider_id =  (self.array_Booking_List.object(at: 0) as! NSDictionary ).value(forKey: "rider_id") as! String

                            if (self.booking_id == "517")
                            {
                                if self.array_Booking_List.count > 1
                                {
                                    if (DLRadioButton.isExist( self.booking_id ) == false)
                                    {
                                        self.ridePopUp()
                                        self.dicIds .setValue(self.booking_id, forKey: self.booking_id)
                                        
                                        DLRadioButton.saveMutableDictionay(self.dicIds as! [AnyHashable : Any])
                                    }
                                }
                            }
                            else
                            {
                                if (DLRadioButton.isExist(self.booking_id) == false)
                                {
                                    self.ridePopUp()
                                    // self.dicIds.setValue("hello", forKey: self.booking_id as String)
                                    // DLRadioButton.saveMutableDictionay(self.dicIds as! [AnyHashable : Any])
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                // Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    func playAudio()
    {
        let urlAudio = Bundle.main.url(forResource: "notify_ride", withExtension: "mp3")
        let sound = Sound(url: urlAudio!)
        sound?.play()
    }
    
    func ridePopUp()
    {
        if self.is_popup == false
        {
            self.playAudio()
            self.is_popup = true
            popUp = Bundle.main.loadNibNamed("AcceptAndDeclineView", owner: self, options: nil)![0] as? UIView as! AcceptAndDeclineView
            popUp.frame = self.view.frame
            self.view.addSubview(popUp)
            popUp.delegate = self
        }
    }
    
    func getResponcePopup(value: Bool)
    {
        if value == true
        {
            mode = true
            self.getRiderDetail()
        }
        else
        {
            let actionSheetController: UIAlertController = UIAlertController(title: "Decline Ride", message: "Are you sure want to decline this Ride", preferredStyle: .alert)
            
            let action0: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                
                self.is_popup = true
                self.tapDecline_Ride(is_time_out: false)
            }
            
            actionSheetController.addAction(action0)
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    func timeOut(value: Bool)
    {
        self.tapDecline_Ride(is_time_out: true)
    }
    
    // MARK:
    // MARK: - API METHODS
    
    func getRiderDetail() {
        
        let dic = NSMutableDictionary()
        
        dic.setValue("user", forKey: "usertype")
        dic.setValue(rider_id, forKey: "id")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "get_user_profile")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                self.rider_username = (dataDictionary .value(forKey: "result") as! NSDictionary ) .value(forKey: "username") as! String
                
                self.tapAccept_Ride()
            }
            else
            {
                // self.getRiderDetail();
            }
        }
    }

    
    func tapAccept_Ride() {
        
        let dic = NSMutableDictionary()
        
        dic.setValue(booking_id, forKey: "booking_id")
        dic.setValue(USER_ID, forKey: "driver_id")
        dic.setValue(rider_username, forKey: "rider_id")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "accept_booking")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                
                let obj : PickUpPassenger = PickUpPassenger(nibName: "PickUpPassenger", bundle: nil)
                obj.booking_id = self.booking_id
                obj.rider_id = self.rider_id
                obj.rider_username = self.rider_username
                self.navigationController?.pushViewController(obj, animated: true)
                
            }
            else
            {
                self.is_popup = false
                self.mode = false
                self.perform( #selector(self.perform_update_location), with: 1, afterDelay: 1)
                
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
        
    }
    
    func tapDecline_Ride(is_time_out : Bool)
    {
        popUp.removeFromSuperview()
        
        var statusStr = "Decline By Driver"
        
        if is_time_out == true {
            
            statusStr = "time out"
        }
        
        let dic = NSMutableDictionary()
        
        dic.setValue(booking_id, forKey: "booking_id")
        dic.setValue(USER_ID, forKey: "driver_id")
        dic.setValue(statusStr, forKey: "status")
        
        // status=time_out/declined
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "booking_action_by_driver")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            self.is_popup = false
            
            if status == true
            {
                
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    func tapCancel_Ride() {
        
        let dic = NSMutableDictionary()
        
        dic.setValue(booking_id, forKey: "booking_id")
        dic.setValue(USER_ID, forKey: "driver_id")
        dic.setValue(USER_ID, forKey: "reason_to_cancel")
        
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "cancel_booking_by_driver")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    
    // MARK: - Notification Delegate
    // MARK:
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
        
        let application = UIApplication.shared
        
        // self.delegate?.gotNotification(title: notification.request.content.title);
        
        // let title : String = notification.request.content.title
        // let title : String =  (notification.request.content.userInfo as NSDictionary ) .object(forKey: "gcm.notification.title1") as! String
        
        if(application.applicationState == .active) {
            
            //app is currently active, can update badges count here
            
        }else if(application.applicationState == .background){
            
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            
        }else if(application.applicationState == .inactive){
            
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
        }
    }

    public func getTopViewController() -> UIViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController
        {
            while (topController.presentedViewController != nil)
            {
                topController = topController.presentedViewController!
            }
            return topController
        }
        return nil}
}
