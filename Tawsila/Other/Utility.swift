//
//  Utility.swift
//  BLUBUMP
//
//  Created by octal-mac-108 on 04/05/17.
//  Copyright © 2017 Octal. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RappleProgressHUD
import CoreLocation
//import GooglePlaces
class Utility
{
    
    static let sharedInstance = Utility()
    fileprivate init() {}
    
    //Show alert from any page you want
    func showAlert(_ title:String, msg:String, controller:UIViewController) {
        let alertController = UIAlertController(title: title,
                                      message: msg,
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        controller.present(alertController, animated: true, completion: nil)
    }
    
    //Trim a String 
    func trim(_ str:String) -> String
    {
        let trimString:String = str.trimmingCharacters(in: CharacterSet.newlines)
        return trimString.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    //Use to encode password for signup
  
		
	//get color a String -- 
	
	
	func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
		let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
		label.numberOfLines = 0
		label.lineBreakMode = NSLineBreakMode.byWordWrapping
		label.font = font
		label.text = text
		
		label.sizeToFit()
		return label.frame.height
	}
    
    //----- SANJAY USE THIS FOR API
    
    func postDataInDataForm(header: String,  inVC vc: UIViewController,  completion: @escaping (_ responce : NSDictionary,_ message : String, _ status : Bool) -> ()) {
        
        //RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
        let urlString           = NSString(format: "%@%@",BSE_URL,header)
        
        let escapedAddress = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        Alamofire.request(escapedAddress!, method: .post, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                
                if let JSON = response.result.value {
                    
                    let responce = JSON as! NSDictionary
                                        
                    let sucess = responce.object(forKey: "type") as! String
                    
                    let message = responce.object(forKey: "msg") as! String
                    if  sucess == "error"
                    {
                        completion(responce,message , false )
                    }
                    else
                    {
                        completion(responce,message , true )
                    }
                    
                    RappleActivityIndicatorView.stopAnimation()
                }
                
                
                break
            case .failure(let error):
                print(error)
                Utility.sharedInstance.showAlert(kAPPName, msg:error.localizedDescription , controller: vc)
                RappleActivityIndicatorView.stopAnimation()
                break
                
                
            }
        }
        
    }
    
	

    func postDataInJson(header: String, withParameter parameter: NSDictionary, inVC vc: UIViewController,  completion: @escaping (_ responce : NSDictionary,_ message : String, _ status : Bool) -> ()) {
        
        //RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
        let urlString           = NSString(format: "%@%@",BSE_URL,header)
        
        let jsonData            = try! JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
        
        
        let jsonString           = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        print(jsonString)
        
        let escapedAddress = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        Alamofire.request(escapedAddress!, method: .post, parameters: parameter as? Parameters ,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
                
                if let JSON = response.result.value {
                    
                    
                    let responce = JSON as! NSDictionary
                    
                    
                    let sucess = responce.object(forKey: "type") as! String
                    
                    let message = responce.object(forKey: "msg") as! String
                    if  sucess == "error"
                    {
                       completion(responce,message , false )
                    }
                    else
                    {
                        completion(responce,message , true )
                    }
                    
                    RappleActivityIndicatorView.stopAnimation()
                }
                
                
                break
            case .failure(let error):
                 print(error)
                Utility.sharedInstance.showAlert(kAPPName, msg:error.localizedDescription , controller: vc)
                RappleActivityIndicatorView.stopAnimation()
                break
               
                
            }
        }
        
//      Alamofire.upload(
//            multipartFormData: { multipartFormData in
//                for (key, value) in parameter {
//                    multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key as! String)
//                }
//                for index in 0 ..< imgVArray.count {
//                    let imageData           = UIImageJPEGRepresentation((imgVArray[index] as! UIImage), 0.8)
//                    if index == 0{
//                        multipartFormData.append(imageData!, withName: "profile_image", fileName: "cover.png", mimeType: "image/png")
//                    }else{
//                        multipartFormData.append(imageData!, withName: "id_proof", fileName: "cover.png", mimeType: "image/png")
//                    }
//                }
//                
//                
//        },
//            with: url,
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON
//                        { response in
//                            
//                            print("\(header) Responce->\(response.result.value!)")
//                            
//                            
//                            if response.result.value != nil
//                            {
//                                let JSON = response.result.value! as AnyObject
//                                let responce = JSON["response"] as! NSDictionary
//                                
//                                let sucess = responce.value(forKey: "status")
//                                
//                                let message = responce.value(forKey: "message") as! String
//                                
//                                completion(responce,message as NSString, sucess as! Bool)
//                            }
//                            
//                            
//                    }
//                    break
//                case .failure( _):
//                    Utility.sharedInstance.showAlert(kAPPName, msg:"Error!!!", controller: self)
//                    RappleActivityIndicatorView.stopAnimation()
//                    
//                    break
//                }
//        }
//        )
        
        
    }
    
    func userFollow(header: String, withParameter parameter: NSDictionary, inVC vc: UIViewController, completion: @escaping (_ responce : Int,_ message : String, _ status : Bool) -> ())
    {
    // RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
    
    let urlString           = NSString(format: "%@/%@",BSE_URL,header)
    
      
    let escapedAddress = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    
        Alamofire.request(escapedAddress!, method: .post, parameters: parameter as? Parameters ,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in

    switch response.result {
    case .success:
    print(response)
    
    if let JSON = response.result.value {
    
    
        let dict  = JSON as! NSDictionary
    //responce
        let sucess = (dict.object(forKey: "response") as! NSDictionary).object(forKey: "status") as! Bool
//    
        let message = (dict.object(forKey: "response") as! NSDictionary).object(forKey: "message") as! String
        var followStatus = 0
        if sucess == true
        {
        
         followStatus = (dict.object(forKey: "response") as! NSDictionary).object(forKey: "is_followed") as! Int
        }
       
       // responce = dict.object(forKey: "response") as! NSArray
    
        completion(followStatus,message , sucess )
        RappleActivityIndicatorView.stopAnimation()
    }
    
    
    break
    case .failure(let error):
    print(error)
    Utility.sharedInstance.showAlert(kAPPName, msg:"Error!!!", controller: vc)
    RappleActivityIndicatorView.stopAnimation()
    break
    
    
    }
    }
     
    }
 //MARK: --------- GET ADDRESS
    
    func getAddressFromLatLong( userlocation: CLLocation, inVC vc: UIViewController,  completion: @escaping ( _ address : String) -> ()) {
        
        CLGeocoder().reverseGeocodeLocation(userlocation, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                let address = self.displayLocationInfo(pm)
                completion(address )
                
                //self.viewBottom.alpha = 1.0
                // print(pm.locality)
            }
            else {
                print("Problem with the data received from geocoder")
                let address = ""
                completion(address )
            }
        })


    }
    
    
    func displayLocationInfo(_ placemark: CLPlacemark?) -> String
    {
        var location = ""
        if let containsPlacemark = placemark
        {
            //stop updating location to save battery life
            
            let addressDict = containsPlacemark.addressDictionary! as NSDictionary
            
            
           // let locality = (containsPlacemark.subLocality != nil) ? containsPlacemark.subLocality : ""
            // let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            
            let city = (addressDict.object(forKey: "City")  != nil) ? addressDict.object(forKey: "City") : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
           // let street = (addressDict.object(forKey: "Street")  != nil) ? addressDict.object(forKey: "Street") : ""
            
          //  self.viewBottom.alpha = 1.0
            
           // location = NSString(format :"%@,%@,%@,%@,%@",street as! String ,locality!,city as! String,administrativeArea!,country!) as String
            
            location = NSString(format :"%@ %@, %@" ,city as! String,administrativeArea!,country!) as String
            
            return location
            //  PKHUD.sharedHUD.hide(animated: true)
            
        }
        return location
        
    }
    
    //MARK: ------- Image Color Chnage
    
    func imageTintColorChange (image : UIImage ) -> UIImage
    {
       
        let templateImage = image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        return templateImage
    }
    
    
    
}

extension UILabel
{
	func heightForView() -> CGFloat{
		let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
		label.numberOfLines = 0
		label.lineBreakMode = NSLineBreakMode.byWordWrapping
		label.font = self.font
		label.text = self.text
		
		label.sizeToFit()
		return label.frame.height
	}
}

