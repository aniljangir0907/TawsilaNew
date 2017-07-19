//
//  Constant.swift
//  BLUBUMP
//  Created by octal-mac-108 on 04/05/17.
//  Copyright © 2017 Octal. All rights reserved.
//

import Foundation
import Alamofire

let BSE_URL   = "http://taxiappsourcecode.com/api/index.php?option="
//let BSE_URL_IMG   = "http://ec2-54-218-74-164.us-west-2.compute.amazonaws.com"

let MSGTRY : String = "Please try again later."
let kAPPName : String = "TAWSILA"

let USER_DEFAULT = UserDefaults.standard

let USER_ID : String = UserDefaults.standard .object(forKey: "user_id") as! String

let USER_NAME : String = UserDefaults.standard.object(forKey: "user_name") as! String

let FCM_TOKEN : String = UserDefaults.standard.object(forKey: "FCM_TOKEN") as! String


let THEME_COLOR = UIColor(red: 33/255.0, green: 134/255.0, blue: 226/255.0, alpha: 1.0)
let NavigationBackgraoungColor = UIColor(red: 163.0/255.0, green: 135.0/255.0, blue: 3.0/255.0, alpha: 1.0) //vikram singh

struct Constant {
    
    struct Notifications {
        static let kNotificationDidSelectCategory = "SelectCategory"
        static let kNotificationPushViewController = "PushViewController"
		static let kNotificationUpdateFriendsList = "UpdateFriendsList"
		static let kNotificationDidSelectMedia = "DidSelectMedia"
		static let kNotificationUserBlocked = "UserBlocked"
		static let kNotificationUserBlockedForLogin = "UserBlockedForLogin"
		static let kNotificationDidSelectMediaDetail = "DidSelectMediaDetail"
		static let kNtificationShowTabbar = "ShowTabbar"
		static let kNtificationHideTabbar = "HideTabbar"
		static let kNotificationDidSelectEvent = "SelectEvent"
		static let kNotificationUserLogout = "UserLogout"
		static let kNotificationShowDetail = "ShowDetail"
		static let kNotificationHideNavigation = "HideNavigation"
		static let kNotificationPopView = "PopView"
		
		
    }
    struct MyVariables {
       
        static var appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    static let font = Constant.Font()
    struct Font {
        func SetFontSize(_ fontsize:CGFloat ) -> UIFont {
            return UIFont(name:"Brandon Grotesque", size:fontsize)!
        }
    }
    
    
    static let showPopupView = Constant.showPopup()
    struct showPopup
    {
        func showAlertViewWithAlertView(_ viewAlert : UIView, WithBlackTransperentView viewblackTransperent: UIView, WithAlertShowBool isAlertShow: Bool )
        {
            if isAlertShow
            {
                viewAlert.transform = CGAffineTransform(scaleX: 0, y: 0)
                viewAlert.isHidden = false
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    viewAlert.transform = CGAffineTransform.identity
                    viewblackTransperent.isHidden = false
                    }, completion: { (isDone) -> Void in
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    viewAlert.transform = CGAffineTransform.identity
                    viewAlert.transform = CGAffineTransform(scaleX: 0, y: 0)
                    viewblackTransperent.isHidden = true
                    }, completion: { (isDone) -> Void in
                        viewAlert.isHidden = true
                })
            }
        }
    }
    
    struct COLOR {
        static let Color_App = UIColor(red: 33/255.0, green: 134/255.0, blue: 226/255.0, alpha: 1.0)
        static let Color_BG_2 = UIColor(red: 133/255.0, green: 146/255.0, blue: 201/255.0, alpha: 1.0)
        static let Color_BG_3 = UIColor(red: 189/255.0, green: 139/255.0, blue: 190/255.0, alpha: 1.0)
        static let Color_BG_4 = UIColor(red: 164/255.0, green: 212/255.0, blue: 158/255.0, alpha: 1.0)
        static let Navigation_Color = UIColor(red: 105/255.0, green: 193/255.0, blue: 182/255.0, alpha: 1.0)
        static let ButtonFreezeMap = UIColor(red: 105/255.0, green: 193/255.0, blue: 182/255.0, alpha: 1.0)
        static let ButtonUnfreezeMap = UIColor(red: 8/255.0, green: 57/255.0, blue: 89/255.0, alpha: 1.0)
        static let PopupTableHeader = UIColor(red: 240/255.0, green: 240/255.0, blue: 241/255.0, alpha: 1.0)
		static let Unselected_Text_Color = UIColor(red: 194/255.0, green: 255/255.0, blue: 251/255.0, alpha: 1.0)
    }
	
	struct ScreenNo22 {
		static let FriendsProfile = 0
		static let InfluencerProfile = 1
		static let Teams = 2
		static let Brands = 3
		static let Continents = 4
		//static let SearchEvent = 5
	}
	
	
    struct ScreenSize
    {
        static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS  =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    }
    
    
}
struct AppDelegateVariable {
    //static var yourVariable = "someString"
    static var appDelegate = UIApplication.shared.delegate as! AppDelegate
}


extension NSDictionary {
    
    static func fromDictionary<Key: Hashable, Value:AnyObject>(_ dictionary:Dictionary<Key, Value>) -> NSDictionary where Key: NSCopying {
        
        let mutableDict : NSMutableDictionary = NSMutableDictionary()
        
        for key in dictionary.keys {
            if let value = dictionary[key] {
                mutableDict[key] = value
            } else {
                mutableDict[key] = NSNull()
            }
        }
        return mutableDict
    }
    
    static func fromDictionary<Key: Hashable, Value:AnyObject>(_ dict: Dictionary<Key, Optional<Value>>) -> NSDictionary where Key: NSCopying {
        
        let mutableDict : NSMutableDictionary = NSMutableDictionary()
        
        for key in dict.keys {
            if let maybeValue = dict[key] {
                if let value = maybeValue {
                    mutableDict[key] = value
                } else {
                    mutableDict[key] = NSNull()
                }
            }
        }
        return mutableDict
    }
}
extension UIView {
    func dropShadow() {
        self.layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        self.layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 6.0
        self.layer.masksToBounds = false
    }
}
extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 246.0/255.0, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

//MARK:-------------------------- UIViewController extension ---------------------------
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    //bellow two methods are added for back button on navigtation bar by vikram singh
    func backNavigationButton() ->UIBarButtonItem{
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "backImge"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(self.actionBackButton), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        navigationItem.setLeftBarButton(item1, animated: true)
        return item1
    }
    
    /// bellow method is added to go previous viewController
    func actionBackButton(_ sender: Any)  {
        if AppDelegateVariable.appDelegate.strLanguage == "en"{
            navigationController?.popViewController(animated: true)
        }else{
            setRightToLeftViewTransition(true)
        }
    }
    
    // bellow func is used to naviagate viewcontoller for left to right like  Arabic and Hebew language view transition
    func setPushViewTransition(_ viewC: UIViewController){
   
        if AppDelegateVariable.appDelegate.strLanguage == "ar" {
            let transition = CATransition.init()
            transition.duration = 0.45
            transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            navigationController?.view.layer.add(transition, forKey: nil)
            navigationController?.pushViewController(viewC, animated: true)
        }else {
            navigationController?.pushViewController(viewC, animated: true)
        }
    
    }
    
    // bellow func is used to naviagate previous viewcontoller for left to right like  Arabic and Hebew language view transition
    
    func setRightToLeftViewTransition(_ isBack:Bool){
        let transition = CATransition.init()
        transition.duration = 0.45
        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.popViewController(animated: isBack)
    }
}

//MARK: ---------------Hide and Show Arabic and English View on same ViewController ---------
extension UIViewController{
    func setShowAndHideViews(_ vEng: UIView, vArb: UIView) ->Void {
       
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            vArb.isHidden = true
            vEng.isHidden = false
        }else{
            vEng.isHidden = true
            vArb.isHidden = false
        }
    }
}

