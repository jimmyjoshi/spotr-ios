//
//  AppDelegate.swift
//  Spottr
//
//  Created by Kevin on 16/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var bUserProfile = Bool()
    var strDeviceToken = NSString()
    var arrLoginData = NSDictionary()
    var dicRegisterParameters = NSMutableDictionary()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        strDeviceToken = "424442253525"

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        //Push Notification Setting Code
        if #available(iOS 10.0, *)
        {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                
                if granted == true
                {
                    print("Allow")
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else
                {
                    print("Don't Allow")
                }
            }
        }
        else
        {
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
            let setting = UIUserNotificationSettings(types: type, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        if (userDefaults.bool(forKey: kkeyisUserLogin))
        {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let objFeedsVC = mainStoryboard.instantiateViewController(withIdentifier: "FeedsVC")
            let nav = UINavigationController(rootViewController: objFeedsVC)
            nav.navigationBar.isHidden = true
            appdelegate.window!.rootViewController = nav
        }
        else
        {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let nav = UINavigationController(rootViewController: homeViewController)
            nav.isNavigationBarHidden = true
            appdelegate.window!.rootViewController = nav
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: Push Notification Service
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        print(deviceToken)
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceTokenString -> \(deviceTokenString)")
        strDeviceToken = deviceTokenString as NSString
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("error fail -> \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    {
        print("Push Notification Info:>%@", userInfo)
        var apsInfo: [AnyHashable: Any]? = (userInfo["aps"] as? [AnyHashable: Any])
        let alert: NSDictionary? = (apsInfo?["alert"] as? NSDictionary)
        let state:UIApplicationState = application.applicationState
    }
}

