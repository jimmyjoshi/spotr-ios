//
//  UserProfileVC.swift
//  Spottr
//
//  Created by Kevin on 20/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController,UIPopoverPresentationControllerDelegate
{
    @IBOutlet weak var vwUserNotification : UIView!
    @IBOutlet weak var vwFriendRequest : UIView!
    @IBOutlet weak var clFeeds : UICollectionView!
    @IBOutlet weak var btnSettings : UIButton!
    @IBOutlet weak var vwSettings : UIView!
    @IBOutlet weak var tblSetting : UITableView!
    var userProfileID : String?
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var txtvwBio : UITextView!
    var dictuserdata = NSDictionary()
    @IBOutlet weak var lblConnectionCount : UILabel!
    @IBOutlet weak var lblPostCount : UILabel!
    var arrFeeds = NSMutableArray()
    @IBOutlet weak var lblNotificationCount : UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.imgUser.layer.masksToBounds = true
        
        self.tblSetting.estimatedRowHeight = 30
        self.tblSetting.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
        if appDelegate.bUserProfile == true
        {
            vwUserNotification.isHidden = false
            vwFriendRequest.isHidden = true
            btnSettings.isHidden = false
        }
        else
        {
            vwUserNotification.isHidden = true
            vwFriendRequest.isHidden = false
            btnSettings.isHidden = true
        }
        
        showProgress(inView: self.view)
        self.getUserProfile()
    }

    
    func getUserProfile()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let url = kServerURL + "user-profile"
        let token = final .value(forKey: "token")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        let parameters: [String: Any] = ["user_id": userProfileID!]
        
        request(url, method: .post, parameters:parameters, headers: headers).responseJSON { (response:DataResponse<Any>) in
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value!)
                    
                    if let json = response.result.value
                    {
                        let dictemp = json as! NSDictionary
                        print("dictemp :> \(dictemp)")
                        
                        if let temp = dictemp.value(forKey: "error") as? NSDictionary
                        {
                            let msg = (temp.value(forKey: "message"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            self.dictuserdata  = dictemp.value(forKey: "data") as! NSDictionary
                            self.setUserProfileData()
                        }
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }
    
    func setUserProfileData()
    {
        if let imgUserPic = self.dictuserdata.value(forKey: "profile_pic") as? String
        {
            let url2 = URL(string: imgUserPic)
            if url2 != nil {
                imgUser.sd_setImage(with: url2, placeholderImage: UIImage(named: "profile_pic"))
            }
        }
        lblUserName.text = "\(self.dictuserdata.value(forKey: "name")!)"
        txtvwBio.text = "\(self.dictuserdata.value(forKey: "description")!)"
        lblConnectionCount.text = "\(self.dictuserdata.value(forKey: "connectionCount")!)"
        lblPostCount.text = "\(self.dictuserdata.value(forKey: "postCount")!)"

        if appDelegate.bUserProfile == true
        {
            lblNotificationCount.text = "\(self.dictuserdata.value(forKey: "notification_count")!)"
        }
        else
        {
            if "\(self.dictuserdata.value(forKey: "show_connect_btn")!)" == "1"
            {
                vwFriendRequest.isHidden = false
            }
            else
            {
                vwFriendRequest.isHidden = true
            }
        }
        
        showProgress(inView: self.view)
        self.setGetUserPostData()
    }
    
    //MARK: Get User Post Data
    func setGetUserPostData()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let url = kServerURL + "my-posts"
        let token = final .value(forKey: "token")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        let parameters: [String: Any] = ["user_id": userProfileID!]
        self.arrFeeds = NSMutableArray()
        
        request(url, method: .post, parameters:parameters, headers: headers).responseJSON { (response:DataResponse<Any>) in
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value!)
                    
                    if let json = response.result.value
                    {
                        let dictemp = json as! NSDictionary
                        print("dictemp :> \(dictemp)")
                        
                        if let temp = dictemp.value(forKey: "error") as? NSDictionary
                        {
                            let msg = (temp.value(forKey: "message"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            self.arrFeeds = NSMutableArray(array: dictemp.value(forKey: "data") as! NSArray)
                        }
                        self.clFeeds.reloadData()
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                self.clFeeds.reloadData()
                break
            }
        }
    }
    
    //MARK: Button Actions
    @IBAction func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gotoRequestsScreen()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let url = kServerURL + "connections/create"
        let token = final .value(forKey: "token")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        let parameters: [String: Any] = ["user_id": userProfileID!]
        
        request(url, method: .post, parameters:parameters, headers: headers).responseJSON { (response:DataResponse<Any>) in
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value!)
                    
                    if let json = response.result.value
                    {
                        let dictemp = json as! NSDictionary
                        print("dictemp :> \(dictemp)")
                        
                        if let temp = dictemp.value(forKey: "error") as? NSDictionary
                        {
                            let msg = (temp.value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            let msg = (dictemp.value(forKey: "message"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }

        /*let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objPostRequestVC = storyTab.instantiateViewController(withIdentifier: "PostRequestVC")
        self.navigationController?.pushViewController(objPostRequestVC, animated: true)*/
    }

    @IBAction func gotoConnectionScreen()
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
         let objPostRequestVC = storyTab.instantiateViewController(withIdentifier: "PostRequestVC")
         self.navigationController?.pushViewController(objPostRequestVC, animated: true)
    }
    
    @IBAction func gotoNotificationsScreen()
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objNofiticationVC = storyTab.instantiateViewController(withIdentifier: "NofiticationVC")
        self.navigationController?.pushViewController(objNofiticationVC, animated: true)
    }
    
    @IBAction func gotoFriendsListScreen()
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objViewFriendsVC = storyTab.instantiateViewController(withIdentifier: "ViewFriendsVC") as! ViewFriendsVC
        objViewFriendsVC.userProfileID = self.userProfileID
        self.navigationController?.pushViewController(objViewFriendsVC, animated: true)
    }
    
    @IBAction func gotoPostScreen()
    {
       /* let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objViewPostVC = storyTab.instantiateViewController(withIdentifier: "ViewPostVC")
        self.navigationController?.pushViewController(objViewPostVC, animated: true)*/
    }
    
    @IBAction func btnSettingsAction()
    {
        if vwSettings.isHidden == true
        {
            vwSettings.isHidden = false
        }
        else
        {
            vwSettings.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UserProfileVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.arrFeeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "UserFeedsCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! UserFeedsCell
        cell.bgImage.layer.masksToBounds = true
        
        let dicdata = self.arrFeeds[indexPath.row] as! NSDictionary
        
        if "\(dicdata.value(forKey: "is_image")!)" == "1"
        {
            if let bgmediaurl = dicdata.value(forKey: "media") as? String
            {
                let url2 = URL(string: bgmediaurl)
                if url2 != nil {
                    cell.bgImage.sd_setImage(with: url2, placeholderImage: UIImage(named: "ic_feed_bg"))
                }
            }
        }
        else
        {
            if let bgmediaurl = dicdata.value(forKey: "thumbnail") as? String
            {
                let url2 = URL(string: bgmediaurl)
                if url2 != nil {
                    cell.bgImage.sd_setImage(with: url2, placeholderImage: UIImage(named: "ic_feed_bg"))
                }
            }
        }
        cell.lblViewCount.text = "\(dicdata.value(forKey: "viewCount")!)"
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate Methods
extension UserProfileVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objViewPostVC = storyTab.instantiateViewController(withIdentifier: "ViewPostVC") as! ViewPostVC
        let dicdata = self.arrFeeds[indexPath.row] as! NSDictionary
        objViewPostVC.strPostID = "\(dicdata.value(forKey: "post_id")!)"
        self.navigationController?.pushViewController(objViewPostVC, animated: true)
    }
}
extension UserProfileVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
        
        switch indexPath.row
        {
        case 0:
            cell.imgIcon.image = #imageLiteral(resourceName: "ic_notification")
            cell.lblTitle.text = "Nofitications"
            break
        case 1:
            cell.imgIcon.image = #imageLiteral(resourceName: "ic_editprofile")
            cell.lblTitle.text = "Edit Profile"
            break
        case 2:
            cell.imgIcon.image = #imageLiteral(resourceName: "ic_settings")
            cell.lblTitle.text = "Settings"
            break
        case 3:
            cell.imgIcon.image = #imageLiteral(resourceName: "ic_logout")
            cell.lblTitle.text = "Logout"
            break
        default:
            break
        }
        
            return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vwSettings.isHidden = true
        switch indexPath.row
        {
        case 0:
            let storyTab = UIStoryboard(name: "Main", bundle: nil)
            let objNofiticationVC = storyTab.instantiateViewController(withIdentifier: "NofiticationVC")
            self.navigationController?.pushViewController(objNofiticationVC, animated: true)
            break
        case 1:
            let storyTab = UIStoryboard(name: "Main", bundle: nil)
            let objUpdateProfileVC = storyTab.instantiateViewController(withIdentifier: "UpdateProfileVC")
            self.navigationController?.pushViewController(objUpdateProfileVC, animated: true)
            break
        case 2:
            let storyTab = UIStoryboard(name: "Main", bundle: nil)
            let objSettingsVC = storyTab.instantiateViewController(withIdentifier: "SettingsVC")
            self.navigationController?.pushViewController(objSettingsVC, animated: true)
            break
        case 3:
            UserDefaults.standard.set(false, forKey: kkeyisUserLogin)
            UserDefaults.standard.synchronize()
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let nav = UINavigationController(rootViewController: homeViewController)
            nav.isNavigationBarHidden = true
            appDelegate.window!.rootViewController = nav
            break
        default:
            break
        }    }
}
