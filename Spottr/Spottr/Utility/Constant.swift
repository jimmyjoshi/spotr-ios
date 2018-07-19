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
let Application_Name  =  "Spottr"
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

let kServerURL = "http://35.154.84.230/spottr/public/api/"
let kkeyError = "error"

var progressView : UIView?

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
    
    func toStringDateFM(strFormateofDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormateofDate
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
    
    public class func cameraBGCOLOR () -> UIColor {
        return UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
    }
}
