 //
 //  HomeViewControlle.swift
 //  Tawsila
 //
 //  Created by Sanjay on 11/06/17.
 //  Copyright © 2017 scientificweb. All rights reserved.
 //
 
 import UIKit
 import GoogleMaps
 import GooglePlaces
 import RappleProgressHUD
 import Alamofire
 import SDWebImage
 import UserNotifications
 
 class HomeViewControlle: UIViewController ,GMSMapViewDelegate ,SlideNavigationControllerDelegate ,GMSAutocompleteViewControllerDelegate ,notificationDelegate , UNUserNotificationCenterDelegate {
    
    var mapView: GMSMapView!
    
    // IBOutlet for English View
    @IBOutlet var viewEnglish: UIView!
    @IBOutlet var viewForMap: UIView!
    @IBOutlet var lblPickAddress: UILabel!
    @IBOutlet var viewPickAddress: UIView!
    @IBOutlet var viewDestinationAddress: UIView!
    @IBOutlet var lblDestinationAddress: UILabel!
    @IBOutlet var imageDestDot: UIImageView!
    @IBOutlet var imagePicDot: UIImageView!
    @IBOutlet var buttonConfirmBooking: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var viewConfirmBtns: UIView!
    @IBOutlet var viewBottom: UIView!
    @IBOutlet var scrollViewCars: UIScrollView!
    @IBOutlet var viewEstimate: UIView!
    @IBOutlet var imgMidPin: UIImageView!
    @IBOutlet var lblEstimatedTime: UILabel!
    @IBOutlet var lblEstimatedFare: UILabel!
    
    // IBOutlet for Arabic View
    
    @IBOutlet var viewArabic: UIView!
    @IBOutlet var viewForMapAr: UIView!
    @IBOutlet var lblPickAddressAr: UILabel!
    @IBOutlet var viewPickAddressAr: UIView!
    @IBOutlet var viewDestinationAddressAr: UIView!
    @IBOutlet var lblDestinationAddressAr: UILabel!
    @IBOutlet var imageDestDotAr: UIImageView!
    @IBOutlet var imagePicDotAr: UIImageView!
    @IBOutlet var buttonConfirmBookingAr: UIButton!
    @IBOutlet var btnCancelAr: UIButton!
    @IBOutlet var viewConfirmBtnsAr: UIView!
    @IBOutlet var viewBottomAr: UIView!
    @IBOutlet var scrollViewCarsAr: UIScrollView!
    @IBOutlet var viewEstimateAr: UIView!
    @IBOutlet var imgMidPinAr: UIImageView!
    @IBOutlet var lblEstimatedTimeAr: UILabel!
    @IBOutlet var lblEstimatedFareAr: UILabel!
    
    var acController = GMSAutocompleteViewController()
    var locationManager = CLLocationManager()
    var rightBarButton : UIBarButtonItem!
    var pickUpCordinate : CLLocationCoordinate2D!
    var destinationCordinate : CLLocationCoordinate2D!
    var tagBookNow : Int!
    var arrCars : NSArray!
    
    var tempTag: Int!
    var tagCarType: Int!
    var is_LoadCars = Bool()
    var onetime: Int = 0
    
    var tempView = UIView()
    var viewWaiting = UIView()
    var dictMarker:NSMutableDictionary!
    
    var id_booking = String()
    
    var timerForGetCars = Timer();
    
    var initialRate = String()
    var standredRate = String()
    var icon = UIImage()
    
    var is_accepted = Bool()
    var is_location = Bool()
    
    var payMedia = String()
    
    var estFare = Int()
    
    @IBOutlet var lblpayMedia: UILabel!
    
    @IBOutlet var icon_pay_media: UIImageView!
    
    @IBOutlet var viewSeletPayMethod: UIView!
    
    var isSellectCarType = Bool()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tempTag = 0
        tagBookNow = 0
        tagCarType = 0
        is_LoadCars = true
        is_location = false
        AppDelegateVariable.appDelegate.is_loadCar = 0
        dictMarker = NSMutableDictionary()
        isSellectCarType = false
        setBorderWidth()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //let aVariable = appDelegate.delegate
        appDelegate.delegate = self
        
        // -- Locaton Manager
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self .perform( #selector(self.updateLocation), with: 1, afterDelay: 0)
        
        
        if  AppDelegateVariable.appDelegate.strLanguage == "en" {
            viewBottom.isHidden = true
            viewConfirmBtns.isHidden = true
        }else{
            viewBottomAr.isHidden = true
            viewConfirmBtnsAr.isHidden = true
        }
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)

        // self.getCarsAPI()
        // self.gotoNextView()
    }
    
    func setBorderWidth(){
        
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            viewPickAddress.layer.borderColor = UIColor.lightGray.cgColor
            viewPickAddress.layer.borderWidth = 1
            
            viewDestinationAddress.layer.borderColor = UIColor.lightGray.cgColor
            viewDestinationAddress.layer.borderWidth = 1
            viewDestinationAddress.isHidden = true
            
            buttonConfirmBooking.layer.cornerRadius = 3
            btnCancel.layer.cornerRadius = 3
            
            viewEstimate.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
            viewEstimate.layer.borderWidth = 0.5
            viewEstimate.layer.cornerRadius = 3
            viewEstimate.isHidden = true
            
            viewSeletPayMethod.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
            viewSeletPayMethod.layer.borderWidth = 0.5
            viewSeletPayMethod.layer.cornerRadius = 3
            viewSeletPayMethod.isHidden = true
            
        }
        else{
            
            viewPickAddressAr.layer.borderColor = UIColor.lightGray.cgColor
            viewPickAddressAr.layer.borderWidth = 1
            
            viewDestinationAddressAr.layer.borderColor = UIColor.lightGray.cgColor
            viewDestinationAddressAr.layer.borderWidth = 1
            viewDestinationAddressAr.isHidden = true
            
            buttonConfirmBookingAr.layer.cornerRadius = 3
            btnCancelAr.layer.cornerRadius = 3
            
            viewEstimateAr.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
            viewEstimateAr.layer.borderWidth = 0.5
            viewEstimateAr.layer.cornerRadius = 3
            viewEstimateAr.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            
            // Enable or disable features based on authorization.
        }
        
        is_accepted = false
        
        AppDelegateVariable.appDelegate.is_loadCar = 0
        
        setShowAndHideViews(viewEnglish, vArb: viewArabic)
        
        if AppDelegateVariable.appDelegate.id_booking == "false"
        {
            AppDelegateVariable.appDelegate.id_booking = "NO";
            self.tapCacelBooking("");
           // self.getCarsAPI()
        }
        
        if AppDelegateVariable.appDelegate.id_booking == "cancel"
        {
            Utility.sharedInstance.showAlert(kAPPName, msg: "Ride cancelled by Driver", controller: self)
            
            AppDelegateVariable.appDelegate.id_booking = "NO";
            self.tapCacelBooking("");
        }
        
        self.getCarsAPI()

        
        Utility.sharedInstance.getUserWallet(vc : self)
        
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super .viewWillDisappear(true)
        AppDelegateVariable.appDelegate.is_loadCar = 1
    }
    
    // MARK:
    // MARK: - Load Cars and Car Locaions
    
    func getCarsAPI()
    {
        var parameterString = String(format : "get_cars")
        
        let dic = NSMutableDictionary()
        
        dic.setValue(String (format: "%f", (locationManager.location!.coordinate.latitude)), forKey: "lat")
        dic.setValue(String (format: "%f", (locationManager.location!.coordinate.longitude)), forKey: "long")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        // print(parameterString)
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                
                if(self.onetime == 0)
                {
                    let array : NSArray = (dataDictionary.object(forKey:"result") as! NSArray)
                    self.arrCars = array
                    self.onetime = 1
                    self.loadCars(arrayCars:array)
                    self.perform( #selector(self.getCarsLocations), with: 1, afterDelay: 0)
                }
            }
        }
    }
    
    func getCarsLocations()
    {
        var parameterString = String(format : "get_cars_wise_driver")
        
        let dic = NSMutableDictionary()
        
        dic.setValue((self.arrCars.object(at: tagCarType) as! NSDictionary ) .object(forKey: "car_type") as! String, forKey: "car_type")
        dic.setValue("PTPT", forKey: "transfertype")
        dic.setValue(String (format: "%f", (mapView.myLocation?.coordinate.latitude)!), forKey: "lat")
        dic.setValue(String (format: "%f", (mapView.myLocation?.coordinate.longitude)!), forKey: "long")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        print(parameterString)
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if (AppDelegateVariable.appDelegate.is_loadCar == 0)
            {
                self .perform( #selector(self.getCarsLocations), with: 1, afterDelay: 1)
            }
            if status == true
            {
                var icon = UIImage()
                
                
                let car : String = ((self.arrCars.object(at: self.tagCarType) as! NSDictionary ) .object(forKey: "car_type") as! String).uppercased()
                
                
                if (car == "Luxury".uppercased())
                {
                    icon =  #imageLiteral(resourceName: "car_luxury")
                }
                else  if (car == "Outstation".uppercased())
                {
                    icon = #imageLiteral(resourceName: "car_texy")
                }
                else  if (car == "SUV")
                {
                    icon = #imageLiteral(resourceName: "car_other")
                }
                else  if (car == "MINI")
                {
                    icon = #imageLiteral(resourceName: "car_mini_icon")
                }
                else  if (car == "SEDAN")
                {
                    icon =  #imageLiteral(resourceName: "car_texy")
                }
                else
                {
                    icon = #imageLiteral(resourceName: "car_other")
                }
                
                
                
                
                if self.tagCarType != self.tempTag
                {
                    self.mapView.clear()
                    self.tempTag = self.tagCarType
                }
                
                let dataArray:NSArray = (dataDictionary as NSDictionary).object(forKey: "result") as! NSArray
                self.initialRate = ((dataArray.object(at: 0) as! NSDictionary) .object(forKey: "intailrate") as! String)
                self.standredRate = ((dataArray.object(at: 0) as! NSDictionary) .object(forKey: "standardrate") as! String)
                
                for  i in 0 ... (dataArray.count - 1)
                {
                    let lat = ((dataArray.object(at: i) as! NSDictionary) .object(forKey: "latitude") as! String)
                    let lon = ((dataArray.object(at: i) as! NSDictionary) .object(forKey: "longitude") as! String)
                    var cordinate = CLLocationCoordinate2D ()
                    cordinate.latitude = (lat as NSString).doubleValue
                    cordinate.longitude = (lon as NSString).doubleValue
                    
                    let id_driver =  ((dataArray.object(at: i) as! NSDictionary) .object(forKey: "id") as! String);
                    
                    if (self.dictMarker .object(forKey: id_driver) != nil)
                    {
                        let marker : GMSMarker = self.dictMarker .object(forKey: id_driver) as! GMSMarker
                        
                        
                        if(marker.position.latitude == cordinate.latitude && marker.position.longitude == cordinate.longitude)
                        {
                            marker.position = cordinate
                            marker.map = self.mapView
                        }
                        else
                        {
                            self.getHeadingForDirection(fromCoordinate: marker.position, toCoordinate: cordinate, marker: marker)
                            marker.position = cordinate
                            marker.map = self.mapView
                            self.dictMarker .setObject(marker, forKey: id_driver as NSCopying)
                        }
                    }
                    else
                    {
                        let marker = GMSMarker()
                        // marker.t
                        marker.position = cordinate
                        marker.map = self.mapView
                        marker.icon = icon
                        
                        self.dictMarker .setObject(marker, forKey: id_driver as NSCopying)
                        self.getHeadingForDirection(fromCoordinate: marker.position, toCoordinate: (self.mapView.myLocation?.coordinate)!, marker: marker)
                    }
                }
            }
            else
                
            {
                self.mapView.clear()
                // Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    // MARK:
    // MARK: - Bottom View
    
    func loadCars(arrayCars: Any)
    {
        var wd = 80
        var xxx : Int = 0
        
        for i in 0 ... (self.arrCars.count - 1) {
            
            let dict : NSDictionary = self.arrCars .object(at: i) as! NSDictionary

            let arrVehcles : NSArray = dict .value(forKey: "car_nearst_data") as! NSArray
            
            let lblTime = UILabel(frame: CGRect(x: xxx * wd, y: 0, width: wd, height: 20))
            lblTime.textAlignment = .center
            lblTime.text = "10 min"
            lblTime.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            lblTime.font = UIFont .systemFont(ofSize: 12)
            
            if arrVehcles.count > 0 {
                
               if isSellectCarType == false
               {
                    isSellectCarType = true
                tagCarType = i;
               }
                
                
                let dicTemp : NSDictionary = arrVehcles .object(at: 0) as! NSDictionary
                
                let distance = dicTemp .object(forKey: "distance") as! String
                
                let dis : Float = (distance as NSString).floatValue * Float32(2)
                
                let estTime = NSString (format: "%d", Int32(dis))
                
                lblTime.text = (estTime as String) + "min"
                
                if estTime == "0"
                {
                    lblTime.text = "1 min"
                }
                
                // float speedIs1KmMinute = (float) 0.49;
                

                
            }
            else
            {
                lblTime.text = "0 min"
            }
            
            
            if i < (self.arrCars.count - 1)
            {
                let lbl_line = UILabel(frame: CGRect(x: wd + xxx * wd, y: 20, width: 1, height: 60))
                lbl_line.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                if  AppDelegateVariable.appDelegate.strLanguage == "en" {
                    self.scrollViewCars.addSubview(lbl_line)
                }else{
                    self.scrollViewCarsAr.addSubview(lbl_line)
                }
                ///self.scrollViewCars.addSubview(lbl_line)
            }
            
            let viewForImage: UIView = UIView(frame: CGRect(x: wd/2 - 25 + xxx * wd, y: 20, width: 50, height: 50))
            viewForImage.layer.cornerRadius = 25
            viewForImage.tag = i+1000
            
            if tagCarType == i
            {
                tempView = viewForImage
                viewForImage.backgroundColor = NavigationBackgraoungColor
            }
            else
            {
                viewForImage.layer.borderColor = UIColor.darkGray.cgColor
                viewForImage.layer.borderWidth = 0.8
                viewForImage.backgroundColor = UIColor.white
            }
            
            
            let imgUrl = dict.object(forKey: "car_image") as? String
            let car_icon = UIImageView(frame: CGRect(x: 5 , y: 5, width: 40, height: 40))
            car_icon.image = #imageLiteral(resourceName: "carIcon")
            let escapedAddress = imgUrl?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            car_icon .sd_setImage(with: NSURL.init(string: escapedAddress!)! as URL)
            car_icon.contentMode = UIViewContentMode.scaleAspectFit
            viewForImage.addSubview(car_icon)
            
            let lblCarName = UILabel(frame: CGRect(x: xxx * wd, y:70, width: wd, height: 21))
            lblCarName.textAlignment = .center
            lblCarName.text = dict.object(forKey: "car_type") as? String
            lblCarName.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            lblCarName.font = UIFont .systemFont(ofSize: 12)
            
            
            let btnTapCar = UIButton(frame: CGRect(x: xxx * wd, y: 0, width: wd, height: 90))
            
            if  AppDelegateVariable.appDelegate.strLanguage == "en" {
                
                self.scrollViewCars.addSubview(viewForImage)
                self.scrollViewCars.addSubview(lblTime)
                self.scrollViewCars.addSubview(btnTapCar)
                self.scrollViewCars.addSubview(lblCarName)
                
            }else{
                self.scrollViewCars.addSubview(viewForImage)
                self.scrollViewCarsAr.addSubview(lblTime)
                self.scrollViewCarsAr.addSubview(btnTapCar)
                self.scrollViewCarsAr.addSubview(lblCarName)
            }
            
            btnTapCar .addTarget(self, action: #selector(tapCarBottom), for: UIControlEvents.touchUpInside)
            btnTapCar.tag = i
            
            xxx = xxx + 1;
            
//            if arrVehcles.count > 0
//            {
//                xxx = xxx + 1;
//            }
//            else
//            {
//                btnTapCar.isHidden = true
//                lblCarName.isHidden = true
//                viewForImage.isHidden = true
//                lblTime.isHidden = true
//            }
//            
        }
        
        if  AppDelegateVariable.appDelegate.strLanguage == "en" {
            scrollViewCars.showsHorizontalScrollIndicator = false
            scrollViewCars .contentSize = CGSize(width: self.arrCars.count*wd, height: 90)
            viewBottom.isHidden = false
        }else{
            scrollViewCarsAr.showsHorizontalScrollIndicator = false
            scrollViewCarsAr .contentSize = CGSize(width: self.arrCars.count*wd, height: 90)
            viewBottomAr.isHidden = false
        }
        
    }
    
    func tapCarBottom(sender:UIButton)
    {
        
        //  let popUp : ViewDetailCar = Bundle.main.loadNibNamed("ViewDetailCar", owner: 0, options: nil)![0] as? UIView as! ViewDetailCar
        //        popUp.cat_type.text = (self.arrCars.object(at: sender.tag) as! NSDictionary) .object(forKey: "car_type") as? String
        //        popUp.frame = self.view.frame
        //
        //  self.view.addSubview(popUp)
        
        tagCarType = sender.tag
        
        tempView.layer.borderColor = UIColor.darkGray.cgColor
        tempView.layer.borderWidth = 0.8
        tempView.backgroundColor = UIColor.white
        
        tempView = scrollViewCars.viewWithTag(sender.tag+1000)!
        tempView.backgroundColor = NavigationBackgraoungColor
        tempView.layer.borderColor = NavigationBackgraoungColor.cgColor
        
    }
    
    // MARK: SlideNavigationController Delegate
    @IBAction func actionLeftMenu(_ sender: Any) {
        SlideNavigationController.sharedInstance().toggleLeftMenu()
    }
    @IBAction func actionRightMenu(_ sender: Any) {
        SlideNavigationController.sharedInstance().toggleRightMenu()
    }
    
    // MARK: - Bookings Buttons Methods
    // MARK:
    
    @IBAction func tapBookNow(_ sender: Any) {
        
        self.tagBookNow = 1;
        
        AppDelegateVariable.appDelegate.is_loadCar = 1;
        
        if  AppDelegateVariable.appDelegate.strLanguage == "en" {
            
            imagePicDot.image = #imageLiteral(resourceName: "dotGreen")
            imageDestDot.tintColor = UIColor.red
            imageDestDot.image = imageDestDot.image?.withRenderingMode(.alwaysTemplate)
            
            viewDestinationAddress.isHidden = false
            self.viewConfirmBtns.isHidden = false
            
            destinationCordinate = pickUpCordinate
            
            UIView.animate(withDuration: 0.2)
            {
                self.viewBottom.frame =  CGRect(x: 0, y: Constant.ScreenSize.SCREEN_HEIGHT  , width: Constant.ScreenSize.SCREEN_WIDTH, height: 134)
            }
        }
        else
        {
            imagePicDotAr.image = #imageLiteral(resourceName: "dotGreen")
            imageDestDotAr.tintColor = UIColor.red
            imageDestDotAr.image = imageDestDotAr.image?.withRenderingMode(.alwaysTemplate)
            
            viewDestinationAddressAr.isHidden = false
            self.viewConfirmBtnsAr.isHidden = false
            
            destinationCordinate = pickUpCordinate
            
            UIView.animate(withDuration: 0.2)
            {
                self.viewBottomAr.frame =  CGRect(x: 0, y: Constant.ScreenSize.SCREEN_HEIGHT  , width: Constant.ScreenSize.SCREEN_WIDTH, height: 134)
            }
        }
        
    }
    
    @IBAction func tapCacelBooking(_ sender: Any)
    {
        AppDelegateVariable.appDelegate.is_loadCar = 0;
        self .perform( #selector(self.getCarsLocations), with: 1, afterDelay: 0)
        
        self.tagBookNow = 0;
        viewEstimate.isHidden = true
        viewSeletPayMethod.isHidden = true
        lblDestinationAddress.text = "Select Destination"
        
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            viewDestinationAddress.isHidden = true
            imagePicDot.image = #imageLiteral(resourceName: "Search")
            mapView.clear()
            imgMidPin.isHidden = false
            
            UIView.animate(withDuration: 0.2)
            {
                self.viewBottom.frame =  CGRect(x: 0, y: Constant.ScreenSize.SCREEN_HEIGHT-134  , width: Constant.ScreenSize.SCREEN_WIDTH, height: 134)
            }
        }else
        {
            viewDestinationAddressAr.isHidden = true
            imagePicDotAr.image = #imageLiteral(resourceName: "Search")
            mapView.clear()
            imgMidPinAr.isHidden = false
            
            UIView.animate(withDuration: 0.2)
            {
                self.viewBottomAr.frame =  CGRect(x: 0, y: Constant.ScreenSize.SCREEN_HEIGHT-134  , width: Constant.ScreenSize.SCREEN_WIDTH, height: 134)
            }
        }
        
    }
    
    //}
    
    //    @IBAction func tapCacelBooking(_ sender: Any)
    //    {
    //        viewDestinationAddress.isHidden = true
    //        tagBookNow = 0;
    //        imagePicDot.image = #imageLiteral(resourceName: "Search")
    //        mapView.clear()
    //        imgMidPin.isHidden = false
    //
    //        UIView.animate(withDuration: 0.2)
    //        {
    //            self.viewBottom.frame =  CGRect(x: 0, y: Constant.ScreenSize.SCREEN_HEIGHT-134  , width: Constant.ScreenSize.SCREEN_WIDTH, height: 134)
    //        }
    //
    //        mapView.animate(toZoom: 10)
    //
    //    }
    //
    
    
    @IBAction func tapRideLater(_ sender: Any) {
        
        let obj : RideLaterVC = RideLaterVC(nibName: "RideLaterVC", bundle: nil)
        obj.pickUpAddress = lblPickAddress.text!
        obj.pickUpCordinate = pickUpCordinate
        obj.car_type = (self.arrCars.object(at: tagCarType) as! NSDictionary ) .object(forKey: "car_type") as! String
        obj.rateInitial = self.initialRate;
        obj.rateStandred = self.standredRate;
        navigationController?.pushViewController(obj, animated: true)
        
    }
    
    // MARK:
    // MARK: - MapView Delegate
    
    func updateLocation()
    {
        let lat = locationManager.location?.coordinate.latitude
        let lon = locationManager.location?.coordinate.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: lon!, zoom: 14.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self as GMSMapViewDelegate
        mapView.isMyLocationEnabled = true
        mapView.camera = camera
        mapView.frame = CGRect(x: 0, y: 0, width: Constant.ScreenSize.SCREEN_WIDTH, height: Constant.ScreenSize.SCREEN_HEIGHT)
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            viewForMap.addSubview(mapView)
        }else{
            viewForMapAr.addSubview(mapView)
        }
        is_location = true
        
        self .perform( #selector(self.getCarsAPI), with: 1, afterDelay: 1)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if self.tagBookNow == 1
        {
            // destinationCordinate = position.target
        }
        if self.tagBookNow == 0
        {
            pickUpCordinate = position.target
            
            
            
            let string:String = String (format: "http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&language=ENGLISH", position.target.latitude,position.target.longitude)
            
            print(string)
            
            Alamofire.request(string, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                //print(response);
                
                do
                {
                    if (response.result.value != nil)
                    {
                        let array : NSArray = ((response.result.value as AnyObject).object(forKey:"results") as! NSArray)
                        
                        if (array.count > 0)
                        {
                            let dic = array.object(at: 0) as! NSDictionary
                            let addressString = dic .object(forKey: "formatted_address") as! String
                            if AppDelegateVariable.appDelegate.strLanguage == "en"{
                                if self.tagBookNow == 0
                                {
                                    self.lblPickAddress.text = addressString
                                }
                                if self.tagBookNow == 1
                                {
                                    //self.lblDestinationAddress.text = addressString
                                }
                            }else {
                                if self.tagBookNow == 0
                                {
                                    self.lblPickAddressAr.text = addressString
                                }
                                if self.tagBookNow == 1
                                {
                                    // self.lblDestinationAddressAr.text = addressString
                                }
                            }
                        }
                    }
                    else
                    {
                        if AppDelegateVariable.appDelegate.strLanguage == "en"{
                            self.lblPickAddress.text = "location not found"
                        }else {
                            self.lblPickAddressAr.text = "location not found"
                        }
                    }
                }catch{
                    print("error")
                }
            }
        }
    }
    
    // MARK: - Confirm Booiking Method
    // MARK:
    
    @IBAction func tapConfirmBooking(_ sender: Any)
    {
        is_LoadCars = false
        
        if self.tagBookNow == 2
        {
            let device_token : String = USER_DEFAULT .object(forKey: "FCM_TOKEN") as! String
            
            AppDelegateVariable.appDelegate.codrdinateDestiantion = destinationCordinate
            AppDelegateVariable.appDelegate.codrdinatePick = pickUpCordinate
            
            let random : String = "32873423323"
            let dic = NSMutableDictionary()
            
            dic.setValue(USER_NAME, forKey: "username")
            dic.setValue("PTPT", forKey: "purpose")
            dic.setValue(DLRadioButton.getCurrentDateOnly(), forKey: "pickup_date")
            dic.setValue(DLRadioButton.getCurrentTime(), forKey: "pickup_time")
            dic.setValue((self.arrCars.object(at: tagCarType) as! NSDictionary ) .object(forKey: "car_type") as! String, forKey: "taxi_type")
            dic.setValue("05:05:77 am", forKey: "departure_time")
            dic.setValue("28/07/2017", forKey: "departure_date")
            dic.setValue("15", forKey: "distance")
            dic.setValue("100", forKey: "amount")
            dic.setValue("jaipur", forKey: "address")
            dic.setValue("Cash", forKey: "payment_media")
            dic.setValue("15", forKey: "km")
            
            dic.setValue(String (format: "%f", (mapView.myLocation?.coordinate.latitude)!), forKey: "lat")
            dic.setValue(String (format: "%f", (mapView.myLocation?.coordinate.longitude)!), forKey: "long")
            dic.setValue(random, forKey: "random")
            
            dic.setValue(device_token, forKey: "device_id")
            
            if AppDelegateVariable.appDelegate.strLanguage == "en"{
                
                dic.setValue(lblPickAddress.text, forKey: "pickup_address")
                dic.setValue(lblPickAddress.text, forKey: "pickup_area")
                dic.setValue(lblDestinationAddress.text, forKey: "drop_area")
            }
            else{
                dic.setValue(lblPickAddressAr.text, forKey: "pickup_address")
                dic.setValue(lblPickAddressAr.text, forKey: "pickup_area")
                dic.setValue(lblDestinationAddressAr.text, forKey: "drop_area")
            }
            
            
            ////<<<<<<< HEAD
            //            dic.setValue("Jaipur", forKey: "pickup_area")
            //            dic.setValue("21/06/2017", forKey: "pickup_date")
            //            dic.setValue("05:05 am", forKey: "pickup_time")
            //            dic.setValue("Jaipur", forKey: "drop_area")
            //            dic.setValue("jaipur", forKey: "area")
            //            dic.setValue("", forKey: "landmark")
            //            dic.setValue("jaipur", forKey: "pickup_address")
            //            dic.setValue("", forKey: "timetype")
            //            dic.setValue("", forKey: "transfer")
            //            dic.setValue("", forKey: "promo_code")
            //            dic.setValue("", forKey: "area")
            //            dic.setValue("", forKey: "landmark")
            //            dic.setValue("", forKey: "flight_number")
            //            dic.setValue("", forKey: "package")
            //
            //=======
            // let str = "http://taxiappsourcecode.com/api/index.php?option=booking_request"
            
            RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
            
            
            var parameterString = String(format : "booking_request")
            
            
            for (key, value) in dic
            {
                parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
                
                // println("\(key) -> \(value)")
            }
            
            Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
                
                RappleActivityIndicatorView.stopAnimation()
                
                
                if status == true
                {
                    self.showWaitingView()
                    let id_boking : String =  (String(format: "%@", dataDictionary.object(forKey: "booking_id") as! CVarArg)) as String
                    AppDelegateVariable.appDelegate.id_booking = id_boking
                    // self .perform( #selector(self.showWaitingView), with: 1, afterDelay: 0)
                }
                else
                {
                    self.tapCacelBooking("")
                    Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
                }
            }
        }
    }
    
    func gotoNextView(){
        
        // viewWaiting.removeFromSuperview()
        let obj : PickUPRideVC = PickUPRideVC(nibName: "PickUPRideVC", bundle: nil)
        // obj.id_booking = self.id_booking;
        self.present(obj, animated: true, completion: nil)
        //        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    // MARK: - Drow Route Method
    // MARK:
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        
        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
        
        //    https://maps.googleapis.com/maps/api/elevation/json?locations=39.7391536,-104.9847034&key=YOUR_API_KEY
        
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
                        
                        let value : NSDictionary = dic.object(forKey: "overview_polyline") as! NSDictionary
                        
                        let polyString : String = value.object(forKey: "points") as! String
                        
                        self.showPath(polyStr: polyString)
                        
                        let estTime =  (((((dic.object(forKey: "legs") as! NSArray) .object(at: 0) ) as AnyObject)
                            .object(forKey: "duration") ) as! NSDictionary) .object(forKey: "text") as? String
                        
                        let estDistance : String =  ((((((dic.object(forKey: "legs") as! NSArray) .object(at: 0) ) as AnyObject)
                            .object(forKey: "distance") ) as! NSDictionary) .object(forKey: "text") as? String)!
                        
                        let doubleValue : Double = NSString(string: estDistance).doubleValue // 3.1
                        
                        
                        
                        self.estFare = Int(Int((self.standredRate as NSString).floatValue + (self.initialRate as NSString).floatValue * Float32(doubleValue)))
                        
                        
                        self.lblEstimatedFare.text =  String (format: "%d SAR", self.estFare )
                        self.lblEstimatedTime.text = estTime
                        
                    }
                    else
                    {
                        self.tagBookNow = 2
                        
                        self.lblEstimatedFare.text = "500"
                        self.lblEstimatedTime.text = "45 min"
                        self.estFare = 500
                        // Utility.sharedInstance.showAlert(kAPPName, msg: "Route Not Found" as String, controller: self)
                    }
                    
                    if (Int(AppDelegateVariable.appDelegate.wallet_amount)! > self.estFare)
                    {
                        self.lblpayMedia.text = "Wallet("+AppDelegateVariable.appDelegate.wallet_amount+")"
                        self.payMedia = "Wallet";
                        self.icon_pay_media.image = #imageLiteral(resourceName: "wallet_Icon")
                    }
                    else
                    {
                        self.payMedia = "Cash";
                        self.lblpayMedia.text = "Cash"
                        self.icon_pay_media.image = #imageLiteral(resourceName: "cash_icon")
                    }
                }
            }
            catch
            {
                print("error in JSONSerialization")
            }
        }
    }
    
    func showPath(polyStr :String)
    {
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.strokeColor = #colorLiteral(red: 0.7661251426, green: 0.6599388719, blue: 0, alpha: 1)
        
        polyline.map = mapView
        
        // Today
        
        var bounds = GMSCoordinateBounds()
        
        for index in 1...Int((path?.count())!)
            
        {
            bounds = bounds.includingCoordinate((path?.coordinate(at: UInt(index)))!)
        }
        
        bounds = bounds.includingCoordinate(pickUpCordinate)
        bounds = bounds.includingCoordinate(destinationCordinate)
        
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100))
        self.tagBookNow = 2
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:
    // MARK: - Tap Search
    
    @IBAction func tapSearch(_ sender: Any) {
        
        
        acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
        
    }
    
    // MARK:
    // MARK: - Tap Search
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 10.0)
        mapView.camera = camera
        
        if tagBookNow == 0
        {
            pickUpCordinate = place.coordinate
        }
        else
        {
            self.mapView.clear()
            
            lblDestinationAddress.text = place.formattedAddress
            destinationCordinate = place.coordinate
            
            viewSeletPayMethod.isHidden = false
            self.viewEstimate.isHidden = false
            self.imgMidPin.isHidden = true
            
            let marker_pick = GMSMarker()
            marker_pick.position = self.pickUpCordinate
            marker_pick.title = self.lblPickAddressAr.text
            marker_pick.map = self.mapView
            marker_pick.icon = #imageLiteral(resourceName: "markerLocation")
            
            let marker_dest = GMSMarker()
            marker_dest.position = self.destinationCordinate
            marker_dest.title = self.lblPickAddressAr.text
            marker_dest.map = self.mapView
            marker_dest.icon = #imageLiteral(resourceName: "markerDesitnation")
            self.tagBookNow = 2
            
            getPolylineRoute(from: pickUpCordinate, to: destinationCordinate)
            
        }
        dismiss(animated: true, completion: nil)
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
    
    func showWaitingView()
    {
        viewWaiting = UIView(frame: CGRect(x:0 , y: 0, width: Constant.ScreenSize.SCREEN_WIDTH, height: Constant.ScreenSize.SCREEN_HEIGHT))
        
        viewWaiting.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        view .addSubview(self.viewWaiting)
        
        let imgRotate: UIImageView = UIImageView(frame: CGRect(x: Constant.ScreenSize.SCREEN_WIDTH/2-60, y: Constant.ScreenSize.SCREEN_HEIGHT/2-60, width: 120, height: 120))
        viewWaiting.addSubview(imgRotate);
        
        imgRotate.image = #imageLiteral(resourceName: "progressLoader")
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = 360 * CGFloat(M_PI/180)
        let innerAnimationDuration : CGFloat = 1.5
        rotationAnimation.duration = Double(innerAnimationDuration)
        rotationAnimation.repeatCount = 30
        imgRotate.layer.add(rotationAnimation, forKey: "rotateInner")
        
        
        self .perform(#selector(hideView), with: "", afterDelay: 30)
    }
    
    func hideView()
    {
        if is_accepted == false {
            
            self.deadBookingStatusApi()
        }
        viewWaiting.removeFromSuperview()
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
        }
        else
        {
            marker.rotation = CLLocationDegrees(degree + 360)
        }
        
        CATransaction.begin()
        CATransaction.setValue(Int(2.0), forKey: kCATransactionAnimationDuration)
        
        marker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        CATransaction.commit()
    }
    
    
    // MARK: - Notification Delegate
    
    func gotNotification(title:String) {
        
        print("hello")
        
        if title == "accept_booking" {
            
            self.performSelector(onMainThread: #selector(self.gotoNextView), with: "", waitUntilDone:true)
            self.gotoNextView()
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
        
        let application = UIApplication.shared
        
        //  self.delegate?.gotNotification(title: notification.request.content.title);
        let title : String = notification.request.content.title
        //  let title1 : String = notification.request.content as! String
        //  print(title1)
        
        if title == "accept_booking"
        {
            
            self.viewWaiting.removeFromSuperview()
            
            is_accepted = true
            let obj : PickUPRideVC = PickUPRideVC(nibName: "PickUPRideVC", bundle: nil)
           
            obj.car_type = (self.arrCars.object(at: self.tagCarType) as! NSDictionary ) .object(forKey: "car_type") as! String
            self.getTopViewController()?.present(obj, animated: true, completion: nil)
            
            self.tapCacelBooking("")
            
            // self.getTopViewController()?.navigationController?.pushViewController(obj, animated: true)
          
            // self.performSelector(onMainThread: #selector(self.gotoNextView), with: "", waitUntilDone:true)
            // self.gotoNextView()
        }
        
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
        return nil
    }
    
    
    func deadBookingStatusApi()  {
        
        let urlStr : String = String (format: "mark_dead_booking&booking_id=%@",AppDelegateVariable.appDelegate.id_booking)
        
        
        Utility.sharedInstance.postDataInDataForm(header: urlStr, inVC: self) { (dataDictionary, msg, status) in
            
            RappleActivityIndicatorView.stopAnimation()
            
            
            if status == true
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: "Your Ride has beed dead because no driver accepted" , controller: self)
                
            }
            else
            {
                //  self.deadBookingStatusApi()
                
                //  Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    @IBAction func actionShareApp(_ sender: Any) {
        
    }
    
    @IBAction func tapPaymentMethod(_ sender: Any) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Choose payment method", message: "", preferredStyle: .actionSheet)
        
        let action0: UIAlertAction = UIAlertAction(title: "Wallet", style: .default) { action -> Void in
            
            self.lblpayMedia.text = "Wallet("+AppDelegateVariable.appDelegate.wallet_amount+")"
            self.payMedia = "Wallet";
            self.icon_pay_media.image = #imageLiteral(resourceName: "wallet_Icon")
            
            if ( Int((AppDelegateVariable.appDelegate.wallet_amount as NSString ).integerValue) < Int(self.estFare))
            {
                self.lblpayMedia.text = "Wallet("+AppDelegateVariable.appDelegate.wallet_amount+")"
                self.payMedia = "Wallet";
                self.icon_pay_media.image = #imageLiteral(resourceName: "wallet_Icon")
                
                let actionController: UIAlertController = UIAlertController(title: "Add money", message: "", preferredStyle: .alert)
                
                
                let action1: UIAlertAction = UIAlertAction(title: "ok", style: .default) { action -> Void in
                    
                    let obj : WalletViewController = WalletViewController(nibName: "WalletViewController", bundle: nil)
                    obj.hometag = true
                    self.present(obj, animated: true, completion: nil)
                    
                }
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                    
                    //Just dismiss the action sheet
                    
                }
                
                actionController.addAction(action1)
                actionController.addAction(cancelAction)
                self.present(actionController, animated: true, completion: nil)
            }
        }
        
        let action1: UIAlertAction = UIAlertAction(title: "Cash", style: .default) { action -> Void in
            
            self.payMedia = "Cash";
            self.lblpayMedia.text = "Cash"
            self.icon_pay_media.image = #imageLiteral(resourceName: "cash_icon")
            
        }
        
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
            //Just dismiss the action sheet
            
        }
        
        actionSheetController.addAction(action0)
        actionSheetController.addAction(action1)
        
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
 }
 
 extension Int
 {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
 }
 extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
 }
