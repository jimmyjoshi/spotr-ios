//
//  Constant.swift
//  YoBored_New
//
//  Created by Bhavik on 18/07/16.
//  Copyright © 2016 Bhavik. All rights reserved.
//

import Foundation
import UIKit

let MainScreen = UIScreen.main.bounds.size

let appDelegate     = UIApplication.shared.delegate as! AppDelegate
let userDefaults    = UserDefaults.standard
let Application_Name  =  "TickTock"
let Alert_NoInternet    = "You are not connected to internet.\nPlease check your internet connection."
let kPrivacyTermsVCViewID = "PrivacyTermsVC"
let Alert_NoDataFound    = "No Data Found."

let kkeydata = "data"
let kkeymessage = "message"
let kkeyuserid = "id"
let kkeyuser_name = "user_name"
let kkeyemail = "email"
let kkeybio = "bio"
let kkeydevice_id = "device_id"
let kkeyimage = "image"
let kkeystatus = "status"
let kkeyvisibility = "visibility"
let kkeyname = "name"
let kkeyaddress = "address"
let kkeyfirst_name = "first_name"
let kkeylast_name = "last_name"
let kkeyfollowing = "following"
let kkeylat = "lat"
let kkeylon = "lon"
let kkeyuser = "user"
let kkeyLoginData = "LoginData"
let kkeyisUserLogin = "UserLogin"
let kkeytext = "text"
let kkeytime = "time"
let kkeytitle = "title"
let kkeyuser_id = "user_id"
let kkeyamount = "amount"
let kkeyavailableBids = "availableBids"

let kUserBidBank = "UserBidBank"

let kNO = "NO"
let kYES = "YES"

let kFBAPPID = "128398547683260"


//let kServerURL = "http://35.154.46.190:1337/api/"
let kServerURL = "http://18.221.196.29:9000/"

let kPrivacyURL = "http://35.154.46.190:1337/privacy"
let kFAQURL = "http://35.154.46.190:1337/faq"

//var CurrentUser : UserModel = UserModel()

var progressView : UIView?

//var CurrentUser : ModelUser = ModelUser()
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        return dateFormatter.string(from: self)
    }
}
extension UIColor {
    
    public class func APPCOLOR () -> UIColor {
        return UIColor(red: 32.0/255.0, green: 63.0/255.0, blue: 120.0/255.0, alpha: 1.0)
    }
    public class func appYellowColor () -> UIColor {
        return UIColor(red: 255.0/255.0, green: 185.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    }
    public class func appDarkChocColor () -> UIColor {
        return UIColor(red: 44.0/255.0, green: 20.0/255.0, blue: 18.0/255.0, alpha: 1.0)
    }
    public class func appDarkPinkColor () -> UIColor {
        return UIColor(red: 211.0/255.0, green: 55.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    }
//    public class func NAVIGATIONBAR () -> UIColor {
//        return UIColor(red: 249.0/255.0, green: 3.0/255.0, blue: 110.0/255.0, alpha: 1.0)
//    }
//    public class func GRAYCOLOR () -> UIColor {
//        return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.60)
//    }
//    public class func NAVIGATIONTITLE () -> UIColor {
//        return UIColor.whiteColor()
//    }
//    public class func ButtonTagBorderColor () -> UIColor {
//        return UIColor(red: 191.0/255.0, green: 194.0/255.0, blue: 194.0/255.0, alpha: 0.60)
//    }
//    public class func PAYMENTORANGECOLOR () -> UIColor {
//        return UIColor(red: 236.0/255.0, green: 151.0/255.0, blue: 53.0/255.0, alpha: 1.0)
//    }
//    public class func PAYMENTBLUECOLOR () -> UIColor {
//        return UIColor(red: 67.0/255.0, green: 149.0/255.0, blue: 248.0/255.0, alpha: 1.0)
//    }
//    public class func PAYMENTGREENCOLOR () -> UIColor {
//        return UIColor(red: 104.0/255.0, green: 189.0/255.0, blue: 101.0/255.0, alpha: 1.0)
//    }
}
