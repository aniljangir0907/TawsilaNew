//
//  PickUpPassenger.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/2/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import RappleProgressHUD
import GoogleMaps
import GooglePlaces
import RappleProgressHUD
import Alamofire
import SDWebImage
import UserNotifications
import AVFoundation
import NotificationCenter


class PickUpPassenger: UIViewController, GMSMapViewDelegate, UNUserNotificationCenterDelegate {
    
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var pickUpCordinate : CLLocationCoordinate2D!
    var destinationCordinate : CLLocationCoordinate2D!
    
    @IBOutlet weak var viewEnglish: UIView!
    @IBOutlet weak var lblInitialAddress: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDestinationAddress: UILabel!
    @IBOutlet weak var viewForMap: UIView!
    @IBOutlet var btnArrived: btnCustomeClass!
    
    
    @IBOutlet weak var viewArabic: UIView!
    @IBOutlet weak var lblInitialAddressAr: UILabel!
    @IBOutlet weak var lblMobileNumberAr: UILabel!
    @IBOutlet weak var lblUserNameAr: UILabel!
    @IBOutlet weak var lblDestinationAddressAr: UILabel!
    @IBOutlet weak var viewForMapAr: UIView!
    
    var is_arrived = Bool()
    var is_started = Bool()
    var is_completed = Bool()
    
    var booking_id = String()
    
    var rider_id = String()
    var rider_username = String()
    
    var pickArea = String()
    var dropArea = String()
    var distance = String()
    var ammount = String()
    
    var reason = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self .perform( #selector(self.updateLocation), with: 1, afterDelay: 0)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        setShowAndHideViews(viewEnglish, vArb: viewArabic)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func updateLocation()
    {
        let lat = locationManager.location?.coordinate.latitude
        let lon = locationManager.location?.coordinate.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: lon!, zoom: 14.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.camera = camera
        mapView.frame = CGRect(x: 0, y: 0, width: Constant.ScreenSize.SCREEN_WIDTH, height: Constant.ScreenSize.SCREEN_HEIGHT)
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            viewForMap.addSubview(mapView)
        }else{
            viewForMapAr.addSubview(mapView)
        }
    }
    
    
    
    @IBAction func actionAskForCancel(_ sender: Any) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
        let cancelRide: UIAlertAction = UIAlertAction(title: "Cancel Ride", style: .default) { action -> Void in


            self .performSelector(onMainThread: #selector(self.cancelPopUp), with: "", waitUntilDone: false)
            
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelRide)

        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func cancelPopUp()  {
       
        let actionSheetController: UIAlertController = UIAlertController(title: "Choose Cancel Option", message: "", preferredStyle: .actionSheet)
        
        let action0: UIAlertAction = UIAlertAction(title: "Some urgent work", style: .default) { action -> Void in
            
            self.reason = "Some urgent work";
            self.cancelRide()
        }
        
        let action1: UIAlertAction = UIAlertAction(title: "Pickup location is too far", style: .default) { action -> Void in
            
            self.reason = "Pickup location is too far";
            self.cancelRide()
            
        }
        let action2: UIAlertAction = UIAlertAction(title: "I have changed my mind", style: .default) { action -> Void in
            
            self.reason = "I have changed my mind";
            self.cancelRide()
            
        }
        let action3: UIAlertAction = UIAlertAction(title: "Go another nearby ride", style: .default) { action -> Void in
            
            self.reason = "Go another nearby ride";
            self.cancelRide()
            
        }
        
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
            //Just dismiss the action sheet
            
        }
        
        actionSheetController.addAction(action0)
        actionSheetController.addAction(action1)
        actionSheetController.addAction(action2)
        actionSheetController.addAction(action3)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    @IBAction func actionCallToUser(_ sender: Any) {
    }
    @IBAction func actionArrived(_ sender: Any) {
        
        if is_arrived == true
        {
           self.startRide()
        }
        else
        {
            btnArrived .setTitle("Start Ride", for: .normal)
            is_arrived = true
        }
    }
    
    @IBAction func actionCompleteRide(_ sender: Any) {
        destinationCordinate = locationManager.location?.coordinate
        self .getPolylineRoute(from: pickUpCordinate, to: destinationCordinate);
        
    }
    
    func arrived() {
        
        let dic = NSMutableDictionary()
        
        dic.setValue(booking_id, forKey: "booking_id")
        dic.setValue(USER_ID, forKey: "driver_id")
        dic.setValue(USER_ID, forKey: "rider_id")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "accept_booking")
        
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
    
    func startRide() {
        
        // http://taxiappsourcecode.com/api/index.php?option=start_ride]    parameter name -- [username=scientificwebs, booking_id=405, driver_id=14
        
        pickUpCordinate = locationManager.location?.coordinate
        
        let dic = NSMutableDictionary()
        
        
        dic.setValue(rider_username, forKey: "username")
        dic.setValue(booking_id, forKey: "booking_id")
        dic.setValue(USER_ID, forKey: "driver_id")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "start_ride")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                self.btnArrived.isHidden =  true
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
        
    }
    
    func completeRide()
    {
        
        let dic = NSMutableDictionary()
        
        //  http://taxiappsourcecode.com/api/index.php?option=reach_at_pickup_location
        // booking_id=, driver_id=, amount, km, distance, pickup_area, drop_area
        
        dic.setValue(USER_ID, forKey: "booking_id")
        dic.setValue(USER_ID, forKey: "driver_id")
        dic.setValue(pickArea, forKey: "pickup_area")
        dic.setValue(dropArea, forKey: "drop_area")
        dic.setValue(ammount, forKey: "amount")
        dic.setValue("50", forKey: "km")

        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "complete_booking")
        
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
    
    
    
    func cancelRide()
    {
        
        let dic = NSMutableDictionary()
        
        // http://taxiappsourcecode.com/api/index.php?option=cancel_booking_by_driver
        // booking_id=, driver_id=, amount, km, distance, pickup_area, drop_area
        // booking_id, driver_id, reason_to_cancel
        
        dic.setValue(booking_id, forKey: "booking_id")
        dic.setValue(USER_ID, forKey: "driver_id")
        dic.setValue(reason, forKey: "reason_to_cancel")
       
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "cancel_booking_by_driver")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
        
    }
    
    
    // MARK: - Drow Route Method
    // MARK:
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)

        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
        
        Alamofire.request(url.absoluteString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            // print(response);
            
            do {
                
                if (response.result.value != nil)
                {
                    let routes = (response.result.value as AnyObject).object(forKey: "routes")  as? [Any]
                    
                    if (routes?.count)! > 0
                    {
                        
                        
                        let overview_polyline : NSDictionary = (routes?[0] as? NSDictionary)!
                        
                        let dic : NSDictionary = overview_polyline as Any as! NSDictionary
                        
                        // let value : NSDictionary = dic.object(forKey: "overview_polyline") as! NSDictionary
                        
                        // let polyString : String = value.object(forKey: "points") as! String
                        
                        
                        // let estTime =  (((((dic.object(forKey: "legs") as! NSArray) .object(at: 0) ) as AnyObject)
                        //   .object(forKey: "duration") ) as! NSDictionary) .object(forKey: "text") as? String
                        
                        let estDistance : String =  ((((((dic.object(forKey: "legs") as! NSArray) .object(at: 0) ) as AnyObject).object(forKey: "distance") ) as! NSDictionary) .object(forKey: "text") as? String)!
               
                        self.pickArea =  (((((dic.object(forKey: "legs") as! NSArray) .object(at: 0) ) as AnyObject).object(forKey: "start_address") ) as? String)!
                        
                        self.dropArea =  (((((dic.object(forKey: "legs") as! NSArray) .object(at: 0) ) as AnyObject).object(forKey: "end_address") ) as? String)!

                        
                        self.distance = estDistance ;
                        
                        self.ammount = "100";
                        
                        self.completeRide();
                        
                        
                        // let doubleValue : Double = NSString(string: estDistance).doubleValue // 3.1
                        
                        // self.lblEstimatedFare.text =  String (format: "%.1f SAR", (self.initialRate as NSString).floatValue + (self.standredRate as NSString).floatValue * Float32(doubleValue) )
                        // self.lblEstimatedTime.text = estTime
                        
                        
                    }
                    else
                    {
                        Utility.sharedInstance.showAlert(kAPPName, msg: "Route Not Found" as String, controller: self)
                    }
                }
            }
            catch
            {
                print("error in JSONSerialization")
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
        
        let title : String = notification.request.content.title
        
        if title == "cancel_by_rider"
        {
            self.dismiss(animated: true, completion: nil)
        }
        
        
        if(application.applicationState == .active) {
            
            //app is currently active, can update badges count here
            
        }else if(application.applicationState == .background){
            
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            
        }else if(application.applicationState == .inactive){
            
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            
        }
    }
    
    
    
    //
    //                            regarding notification -  their are two new apis for notification ,, api for other notification are same -- 1. this api will be called when driver will arrive at pickup location ---- http://taxiappsourcecode.com/api/index.php?option=reach_at_pickup_location          parameter name --[username=scientificwebs,booking_id=405,driver_id=14]                                                                              2. this api will be called when driver will start ride --- http://taxiappsourcecode.com/api/index.php?option=start_ride]    parameter name -- [username=scientificwebs, booking_id=405, driver_id=14
}