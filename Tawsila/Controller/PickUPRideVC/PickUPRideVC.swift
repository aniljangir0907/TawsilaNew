//
//  PickUPRideVC.swift
//  Tawsila
//
//  Created by Sanjay on 21/06/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import RappleProgressHUD
import RappleProgressHUD
import Alamofire
import SDWebImage
import UserNotifications
import SwiftySound


class PickUPRideVC: UIViewController , GMSMapViewDelegate , UNUserNotificationCenterDelegate , PayPalPaymentDelegate  {
    
    var payPalConfig = PayPalConfiguration()
    @IBOutlet var lbltitle: UILabel!
    
    @IBOutlet var viewFooter: UIView!
    
    var mapView: GMSMapView!
    var lblTime: UILabel!
    @IBOutlet var viewForMap: UIView!
    
    @IBOutlet var viewDriverDetail: UIView!
    @IBOutlet var lbl_driverName: UILabel!
    @IBOutlet var lbl_carType: UILabel!
    @IBOutlet var lbl_car_number: UILabel!
    
    var cordinatePick = CLLocationCoordinate2D()
    var cordinateDrop = CLLocationCoordinate2D()
    var cordinateDestination = CLLocationCoordinate2D()
    
    var id_booking : String!
    
    var id_driver : String!
    var cordinateDriver = CLLocationCoordinate2D()
    var driverMaker = GMSMarker()
    var marker_pick = GMSMarker()
    var bounds = GMSCoordinateBounds()
    
    var addressDrop : String!
    
    var is_fill = Bool()
    var is_path = Bool()
    var is_Ride_Start = Bool()
    var is_complete = Bool()
    
    var reason = String()

    
    
    @IBOutlet var driverRating: StarRatingControl!
    
    // -- BILL POPUP
    
    @IBOutlet var lbl_Amount: UILabel!
    @IBOutlet var lbl_pickAddress: UILabel!
    @IBOutlet var lbl_dropAddress: UILabel!
    @IBOutlet var lblCarType_bill: UILabel!
    @IBOutlet var tapButtonOK: UIButton!
    @IBOutlet var rating: StarRatingControl!
    @IBOutlet var viewBIll: UIView!
    @IBOutlet var rtVIew: UIView!
    @IBOutlet var imgRed: UIImageView!
    
    var total_amout = String()
    
    var car_type = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        is_path = false
        is_fill = false
        is_Ride_Start = false
        
        cordinateDestination = AppDelegateVariable.appDelegate.codrdinateDestiantion
        
//        id_driver = "14"
//        AppDelegateVariable.appDelegate.id_booking = "100"
        id_booking = AppDelegateVariable.appDelegate.id_booking as String
        
        cordinatePick = AppDelegateVariable.appDelegate.codrdinatePick
        
        //  Map View
        
        let camera = GMSCameraPosition.camera(withLatitude: cordinatePick.latitude, longitude: cordinatePick.longitude, zoom: 13.0)
        
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self as GMSMapViewDelegate
        mapView.isMyLocationEnabled = true
        mapView.camera = camera
        mapView.frame = CGRect(x: 0, y: 0, width: Constant.ScreenSize.SCREEN_WIDTH, height: Constant.ScreenSize.SCREEN_HEIGHT)
        viewForMap.addSubview(mapView)
        
        marker_pick = GMSMarker()
        marker_pick.position = cordinatePick
        marker_pick.map = mapView
        marker_pick.iconView = markerIconView();
        
        driverMaker = GMSMarker()
        
        for i in 100 ... 103
        {
            let img: UIImageView = self.viewFooter.viewWithTag(i) as! UIImageView
            img.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            img.image = img.image?.withRenderingMode(.alwaysTemplate)
        }
        
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        self.perform(#selector(getBockingDetail), with: "", afterDelay: 0)
        
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
        tapButtonOK.layer.cornerRadius = 4;
        
        rtVIew.layer.cornerRadius = 4;
        rtVIew.layer.borderColor = UIColor.lightGray.cgColor
        rtVIew.layer.borderWidth = 1
        
        imgRed.tintColor = UIColor.red
        imgRed.image = imgRed.image?.withRenderingMode(.alwaysTemplate)
        
        lbl_carType.text = car_type
        
//        payPalConfig.acceptCreditCards = true
//        payPalConfig.merchantName = "Tawsila"
//        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
//        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
//        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
//        payPalConfig.payPalShippingAddressOption = .payPal;
//        
//        //  self.environment = PayPalEnvironmentSandbox
//        
//        //  apper
//        
//        PayPalMobile.preconnect(withEnvironment: environment)
//        
//        //self.total_amout = "20"
//        //self.perform(#selector(pay), with: "", afterDelay: 0)
        
        if AppDelegateVariable.appDelegate.strLanguage == "ar"
        {
            
            let array : Array
                = ["مكالمة","إلغاء","شارك","ركوب الحية","أكثر من","كيف كانت رحلتك؟"];
            
            for i in 0 ... 5
            {
                let lbl : UILabel = self.view .viewWithTag(200+i) as! UILabel;
                lbl.text = array[i]
            }
            
            lbltitle.text = "ركوب لاقط"
            lbltitle.textAlignment  = NSTextAlignment.right
            
            tapButtonOK .setTitle("حسنا", for: .normal);
        }
        self.getDriverRating()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        PayPalMobile.preconnect(withEnvironment: environment)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Fotter Methods
    
    @IBAction func tapCall(_ sender: Any) {
        
        let number = URL(string: "tel://1234" )
        UIApplication.shared.open(number!)
        
    }
    
    @IBAction func tapCancelRide(_ sender: Any){
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Cancel Ride", message: "Sure Want to Cacel Ride", preferredStyle: .alert)
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { action -> Void in
            
            
            self.cancelPopUp()
        }
        
        let noAction: UIAlertAction = UIAlertAction(title: "No", style: .default) { action -> Void in
            
            
            
        }
        
        actionSheetController.addAction(noAction)
        actionSheetController.addAction(yesAction)
        
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
        
        let action4: UIAlertAction = UIAlertAction(title: "My reason is not installed", style: .default) { action -> Void in
            
            self.reason = "My reason is not installed";
            self.cancelRide()
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
            //Just dismiss the action sheet
            
        }
        
        actionSheetController.addAction(action0)
        actionSheetController.addAction(action1)
        actionSheetController.addAction(action2)
        actionSheetController.addAction(action3)
        actionSheetController.addAction(action4)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }

    
    @IBAction func tapShare(_ sender: Any) {
        
        let text = "This is some text that I want to share."
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func tapLiveCamera(_ sender: Any) {
        
    }
    
    @IBAction func tapMore(_ sender: Any) {
        
    }
    
    
    // MARK: - Perform APIs
    // MARK:
    
    
    
    func getBockingDetail()
    {
        
        let dic = NSMutableDictionary()
        
        dic.setValue(AppDelegateVariable.appDelegate.id_booking, forKey: "booking_id")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "get_booking_details")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                self.id_driver = (String(format: "%@", (((dataDictionary.object(forKey: "result") as! NSArray) .object(at: 0) as! NSDictionary ) .object(forKey: "assigned_for")) as! CVarArg)) as String
                print(self.id_driver);
                
                if self.is_complete == true
                {
                    self.lbl_carType.text =  (String(format: "%@", (((dataDictionary.object(forKey: "result") as! NSArray) .object(at: 0) as! NSDictionary ) .object(forKey: "taxi_type")) as! CVarArg)) as String
                    
                    self.lbl_pickAddress.text =  (String(format: "%@", (((dataDictionary.object(forKey: "result") as! NSArray) .object(at: 0) as! NSDictionary ) .object(forKey: "pickup_area")) as! CVarArg)) as String
                    
                    self.lbl_dropAddress.text =  self.addressDrop
                    
                    self.lbl_Amount.text = (String(format: "%@ SAR", (((dataDictionary.object(forKey: "result") as! NSArray) .object(at: 0) as! NSDictionary ) .object(forKey: "amount")) as! CVarArg)) as String
                    
                    self.total_amout =  (String(format: "%@", (((dataDictionary.object(forKey: "result") as! NSArray) .object(at: 0) as! NSDictionary ) .object(forKey: "amount")) as! CVarArg)) as String
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.viewBIll.frame = CGRect(x: 0, y: 64, width: Constant.ScreenSize.SCREEN_WIDTH, height: Constant.ScreenSize.SCREEN_HEIGHT-64)
                    })
                }
                else
                {
                    self.perform(#selector(self.getDriverDetail), with: "", afterDelay: 0)
                }
                
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
        
        dic .setValue(self.reason, forKey: "reason_to_cancel")
        dic .setValue(id_booking, forKey: "booking_id")
        dic .setValue(USER_NAME, forKey: "rider_id")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
        var parameterString = String(format : "cancel_booking_by_rider")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
            // println("\(key) -> \(value)")
        }
        
        // booking_id, rider_id=username, reason_to_cancel
        // http://taxiappsourcecode.com/api/index.php?option=
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                AppDelegateVariable.appDelegate.id_booking = "false";
                self.dismiss(animated: true, completion: nil);
                RappleActivityIndicatorView.stopAnimation()
                
                
                //                let actionSheetController: UIAlertController = UIAlertController(title: "Success", message: "Ride Successfully Cancel", preferredStyle: .alert)
                //
                //                let yesAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                //
                //                    self.navigationController?.popViewController(animated: true)
                //                }
                
                //  actionSheetController.addAction(yesAction)
                //  self.present(actionSheetController, animated: true, completion: nil)
                
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
        
    }
    
    
    func getDriverDetail()
    {
        
        let dic = NSMutableDictionary()
        
        dic .setValue("driver", forKey: "usertype")
        dic .setValue(id_driver, forKey: "id")
        
        // RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "get_user_profile")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            RappleActivityIndicatorView.stopAnimation()
            
            if self.is_Ride_Start == false
            {
                self.perform(#selector(self.getDriverDetail), with: "", afterDelay: 2)
            }
            
            if status == true
            {
                print(dataDictionary);
                
                if (self.is_fill == false)
                {
                    self.is_fill = true
                    self.viewDriverDetail.isHidden = false
                    
                    var userDict = (dataDictionary.object(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    userDict = AppDelegateVariable.appDelegate.convertAllDictionaryValueToNil(userDict)
                    
                    self.lblCarType_bill.text = userDict.object(forKey: "car_type") as? String
                    self.lbl_driverName.text = userDict.object(forKey: "user_name") as? String
                    self.lbl_car_number.text = userDict.object(forKey: "car_no") as? String
                    
                    self.lbl_carType.text =  userDict.object(forKey: "car_type") as? String
                    
                }
                
                let lat = ( dataDictionary.object(forKey: "result")as! NSDictionary) .object(forKey: "latitude") as! String
                let lon = ( dataDictionary.object(forKey: "result") as! NSDictionary) .object(forKey: "longitude") as! String
                
                var cordinate = CLLocationCoordinate2D ()
                cordinate.latitude = (lat as NSString).doubleValue
                cordinate.longitude = (lon as NSString).doubleValue
                
                self.getPolylineRoute(from: self.cordinatePick, to: cordinate)
                
                self.getHeadingForDirection(fromCoordinate: self.driverMaker.position, toCoordinate: cordinate, marker: self.driverMaker)
                
                self.driverMaker.position = cordinate
                self.driverMaker.map = self.mapView
                
                if (self.lbl_carType.text?.uppercased()) == "Luxury".uppercased()
                {
                    self.driverMaker.icon =  #imageLiteral(resourceName: "car_luxury")
                }
                else  if (self.lbl_carType.text?.uppercased()) == "Outstation".uppercased()
                {
                    self.driverMaker.icon = #imageLiteral(resourceName: "car_texy")
                }
                else  if (self.lbl_carType.text?.uppercased()) == "SUV"
                {
                    self.driverMaker.icon = #imageLiteral(resourceName: "car_other")
                }
                else  if (self.lbl_carType.text?.uppercased()) == "MINI"
                {
                    self.driverMaker.icon = #imageLiteral(resourceName: "car_mini_icon")
                }
                else  if (self.lbl_carType.text?.uppercased()) == "SEDAN"
                {
                    self.driverMaker.icon =  #imageLiteral(resourceName: "car_texy")
                }
                else
                {
                    self.driverMaker.icon = #imageLiteral(resourceName: "car_other")
                }
                
                self.bounds = self.bounds.includingCoordinate(self.cordinatePick)
                self.bounds = self.bounds.includingCoordinate(cordinate)
                
                self.mapView.animate(with: GMSCameraUpdate.fit(self.bounds, withPadding: 100))
                
                
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    func sendPushNotification(title:String, message:String, fcmID: String)
    {
        
        let dic = NSMutableDictionary()
        
        dic.setValue("driver", forKey: "device_id")
        dic.setValue(id_driver, forKey: "message")
        dic.setValue(id_driver, forKey: "Title")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "push_notification")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                
                let actionSheetController: UIAlertController = UIAlertController(title: "Success", message: "Ride Successfully Cancel", preferredStyle: .alert)
                
                let yesAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                    
                    self.navigationController?.popViewController(animated: true)
                }
                
                actionSheetController.addAction(yesAction)
                self.present(actionSheetController, animated: true, completion: nil)
                
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
        
        
        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
        
        
        Alamofire.request(url.absoluteString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            do {
                
                if (response.result.value != nil)
                {
                    let routes = (response.result.value as AnyObject).object(forKey: "routes")  as? [Any]
                    
                    let overview_polyline : NSDictionary = (routes?[0] as? NSDictionary)!
                    
                    let dic : NSDictionary = overview_polyline as Any as! NSDictionary
                    
                    let value : NSDictionary = dic.object(forKey: "overview_polyline") as! NSDictionary
                    
                    
                    let estTime =  (((((dic.object(forKey: "legs") as! NSArray) .object(at: 0) ) as AnyObject)
                        .object(forKey: "duration") ) as! NSDictionary) .object(forKey: "text") as? String
                    self.lblTime.text = estTime;
                    
                    
                    let dropAddress : String =  (((((dic.object(forKey: "legs") as! NSArray) .object(at: 0) ) as AnyObject)
                        .object(forKey: "start_address")) as? String)!
                    
                    self.addressDrop = dropAddress 
                    
                    if (self.is_path == true)
                    {
                        let polyString : String = value.object(forKey: "points") as! String
                        
                        self.is_path = false
                        self.showPath(polyStr: polyString)
                        
                        
                        
                    }
                    
                    if (self.is_Ride_Start == true)
                    {
                        self.perform(#selector(self.startRide), with: "", afterDelay: 1)
                        
                        self.getHeadingForDirection(fromCoordinate: self.driverMaker.position, toCoordinate: (self.mapView.myLocation?.coordinate)!, marker: self.driverMaker)
                        
                        self.driverMaker.position = (self.mapView.myLocation?.coordinate)!
                        self.driverMaker.map = self.mapView
                        
                    }
                    
                }
            }
            catch
            {
                print("error in JSONSerialization")
            }
        }
    }
    
    func startRide()
    {
        
        self.getPolylineRoute(from:(self.mapView.myLocation?.coordinate)!, to: cordinateDestination)
        
    }
    
    
    func showPath(polyStr :String)
    {
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.strokeColor = #colorLiteral(red: 0.7661251426, green: 0.6599388719, blue: 0, alpha: 1)
        
        polyline.map = mapView
        
        var bounds = GMSCoordinateBounds()
        
        for index in 1...Int((path?.count())!)
            
        {
            bounds = bounds.includingCoordinate((path?.coordinate(at: UInt(index)))!)
        }
        bounds = bounds.includingCoordinate(cordinatePick)
        bounds = bounds.includingCoordinate(cordinateDestination)
        
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100))
        
        
        
//        let marker_pick = GMSMarker()
//        marker_pick.position = self.cordinatePick
//        marker_pick.title = self.lblPickAddressAr.text
//        marker_pick.map = self.mapView
//        marker_pick.icon = #imageLiteral(resourceName: "markerLocation")
        
        let marker_dest = GMSMarker()
        marker_dest.position = self.cordinateDestination
  //      marker_dest.title = self.lblPickAddressAr.text
        marker_dest.map = self.mapView
        marker_dest.icon = #imageLiteral(resourceName: "markerDesitnation")
        //self.tagBookNow = 2
    }
    
    
    
    
    func getTopViewController() -> UIViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController
        {
            while (topController.presentedViewController != nil)
            {
                topController = topController.presentedViewController!
            }
            return topController
        }
        return nil
    }
    
    
    // MARK: Other Usable Methods
    
    func markerIconView() -> UIView {
        
        let viewAnot : UIView = UIView(frame: CGRect(x:0, y: 0, width: 80, height: 60))
        viewAnot.backgroundColor = UIColor.clear
        
        let img : UIImageView = UIImageView(frame: CGRect(x:0, y: 0, width: 80, height: 60))
        img.image = #imageLiteral(resourceName: "markerLocation")
        img.contentMode = UIViewContentMode.scaleAspectFit
        viewAnot.addSubview(img)
        
        lblTime = UILabel(frame: CGRect(x:0, y: 0, width: 80, height: 30))
        lblTime.textAlignment = .center
        lblTime.text =  "time"
        lblTime.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lblTime.font = UIFont .systemFont(ofSize: 11)
        
        viewAnot .addSubview(lblTime);
        
        lblTime.layer.cornerRadius = 15;
        lblTime.clipsToBounds = true
        lblTime.layer.borderWidth = 0.8
        lblTime.layer.borderColor = UIColor.white.cgColor
        lblTime.backgroundColor = UIColor.black
        
        return viewAnot
    }
    
    func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D , marker : GMSMarker)
    {
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        
        if degree >= 0
        {
            marker.rotation = CLLocationDegrees(degree)
            
            CATransaction.begin()
            CATransaction.setValue(Int(2.0), forKey: kCATransactionAnimationDuration)
            
            marker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
            CATransaction.commit()
            
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
        
        // self.delegate?.gotNotification(title: notification.request.content.title);
        
        let title : String = notification.request.content.title
        
        if (title == "cancel_by_driver")
        {
            AppDelegateVariable.appDelegate.id_booking = "cancel";
            self.dismiss(animated: true, completion: nil)
        }
        
        if (title == "arrived_driver")
        {
            self.playAudio()

        }
        
        if (title == "start_ride")
        {
            
            
            self.is_path = true
            self.is_Ride_Start = true
            self.getPolylineRoute(from: cordinatePick, to: cordinateDestination)
        }
        
        if (title == "end_ride")
        {
            self.is_complete = true
            self.is_Ride_Start = false
            self.getBockingDetail()
            lbltitle.text = "Your Bill"
            
            if AppDelegateVariable.appDelegate.strLanguage == "ar"
            {
                lbltitle.text = "فاتورتك";
            }
        }
    }
    
    @IBAction func tapButtonOk(_ sender: Any)
    {
        //  http://taxiappsourcecode.com/api/index.php?option=add_booking_review
        
        //  booking_id=, review_by= Driver/Rider, rider_id=scientificwebs, driver_id, rating= 1 to 5 [ 1 or 2 or 3 or 4 or 5 ], review_text
        
        if (rating.rating > 0)
        {
            self.sendFeedBack()
//          self.perform(#selector(pay), with: "", afterDelay: 0)
        }
        else
        {
            Utility.sharedInstance.showAlert(kAPPName, msg: "Select Rating First" , controller: self)
        }
    }
    
    
    func sendFeedBack() {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Choose Cancel Option", message: "", preferredStyle: .actionSheet)
        
        let action0: UIAlertAction = UIAlertAction(title: "Driver is professional", style: .default) { action -> Void in
            
            self.reason = "Driver is professional";
            self.sendFeedBackApi()
        }
        
        let action1: UIAlertAction = UIAlertAction(title: "Nice ride", style: .default) { action -> Void in
            
            self.reason = "Nice ride";
            self.sendFeedBackApi()
            
        }
        let action2: UIAlertAction = UIAlertAction(title: "Safe ride", style: .default) { action -> Void in
            
            self.reason = "Safe ride";
            self.sendFeedBackApi()
            
        }
        let action3: UIAlertAction = UIAlertAction(title: "Reached on time", style: .default) { action -> Void in
            
            self.reason = "Reached on time";
            self.sendFeedBackApi()
            
        }
        
        let action4: UIAlertAction = UIAlertAction(title: "Well driving skill", style: .default) { action -> Void in
            
            self.reason = "Well driving skill";
            self.sendFeedBackApi()
            
        }

        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
        }

        
        actionSheetController.addAction(action0)
        actionSheetController.addAction(action1)
        actionSheetController.addAction(action2)
        actionSheetController.addAction(action3)
        actionSheetController.addAction(action4)

        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func sendFeedBackApi() {
        
        let dic = NSMutableDictionary()
        
        dic.setValue(id_booking, forKey: "booking_id")
        dic.setValue("rider", forKey: "review_by")
        dic.setValue(id_driver, forKey: "driver_id")
        dic.setValue(USER_NAME, forKey: "rider_id")
        dic.setValue(rating.rating, forKey: "rating")
        dic.setValue( self.reason, forKey: "review_text")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "add_booking_review")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                //iToast.makeText(" Review Completed ").show()
                
                AppDelegateVariable.appDelegate.id_booking = "false";
                
                
                
                let actionSheetController: UIAlertController = UIAlertController(title: "Thanks for riding with us", message: "", preferredStyle: .actionSheet)
                
                let action0: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                   
                    self.dismiss(animated: true, completion: {
                        
                    })
                }

                
                actionSheetController.addAction(action0)
                self.present(actionSheetController, animated: true, completion: nil)
                
              
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    
    func getDriverRating() {
        
        let dic = NSMutableDictionary()
        
        dic.setValue("driver", forKey: "review_by")
        dic.setValue(id_driver, forKey: "user_id")
    
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "get_reviews")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                //iToast.makeText(" Review Completed ").show()
                RappleActivityIndicatorView.stopAnimation()

//                let array : NSArray = dataDictionary .object(forKey: "result") as! NSArray
//                
//                var value : Int = 0
//                 for i in 0 ... (array.count - 1) {
//                    
//   // value = value + Int(((array.object(at: i) as! NSDictionary) .object(forKey: "rating") as! NSString ).integerValue);
//                
//                    
//                    // let rate : NSString = userDict.object(forKey: "rating") as! NSString
//                    
//                }
                
                self.driverRating.rating = 5
                
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    
    // MARK: Other Usable Methods
    
    func pay()
    {
        
        let item1 = PayPalItem(name: "Title", withQuantity: 1, withPrice: NSDecimalNumber(string:total_amout), withCurrency: "USD", withSku: "Hip-0037")
        let items = [item1]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Tawsila", intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable)
        {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            print("Payment not processalbe: \(payment)")
        }
    }
    
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        
        
        paymentViewController.dismiss(animated: true, completion: nil)
        
        Utility.sharedInstance.showAlert(kAPPName, msg: "Payment Unsucess", controller: self)
        
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        
        self.sendFeedBack()
        
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("\(String(describing: completedPayment.softDescriptor))")
            //self.viewPaymentBG.isHidden = true
            // self.isWithdraw = true
            let dict_details = completedPayment.confirmation as NSDictionary
            print((dict_details.value(forKey: "response") as AnyObject).value(forKey: "id") as! String)
            
            //self.subscribeTheItemsPurchase(transIds: (dict_details.value(forKey: "response") as AnyObject).value(forKey: "id") as! String)
        })
    }
 
    func playAudio()
    {
        let urlAudio = Bundle.main.url(forResource: "driver_arrived_sound", withExtension: "mp3")
        let sound = Sound(url: urlAudio!)
        sound?.play()
    }
}

