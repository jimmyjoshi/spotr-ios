//
//  FeedsVC.swift
//  Spottr
//
//  Created by Kevin on 20/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class FeedsVC: UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var txtSearch : UITextField!
    @IBOutlet weak var clHeader : UICollectionView!
    @IBOutlet weak var clFeeds : UICollectionView!
    var arrFeeds = NSMutableArray()
    var arrUnreadUserFeeds = NSMutableArray()
    @IBOutlet weak var lblNoData : UILabel!
    @IBOutlet weak var vwHeader : UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        showProgress(inView: self.view)
        lblNoData.isHidden = true
        self.getUserPosts()
    }

    func getUserPosts()
    {
        arrFeeds = NSMutableArray()
        arrUnreadUserFeeds = NSMutableArray()

        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let url = kServerURL + "posts"
        let token = final .value(forKey: "token")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        request(url, method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
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
//                            App_showAlert(withMessage: msg as! String, inView: self)
                            self.vwHeader.isHidden = true
                            self.clFeeds.isHidden = true
                            self.lblNoData.isHidden = false
                            self.lblNoData.text = msg as? String
                        }
                        else
                        {
                            let data  = dictemp.value(forKey: "data") as! NSDictionary
                            if data.count > 0
                            {
                                self.arrUnreadUserFeeds = NSMutableArray(array: data.value(forKey: "unread") as! NSArray)
                                self.arrFeeds = NSMutableArray(array: data.value(forKey: "read") as! NSArray)
                            }
                            else
                            {
                                self.vwHeader.isHidden = true
                                self.clFeeds.isHidden = true
                                self.lblNoData.isHidden = false
                                self.vwHeader.isHidden = true
                                self.clFeeds.isHidden = true
                                self.lblNoData.isHidden = false
                                let msg = (data.value(forKey: "message"))
                                self.lblNoData.text = msg as? String
                            }
                        }
                        self.clHeader.reloadData()
                        self.clFeeds.reloadData()
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                self.clHeader.reloadData()
                self.clFeeds.reloadData()
                break
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btngotoUserProfile()
    {
        appDelegate.bUserProfile = true
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary

        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objUserProfileVC = storyTab.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        objUserProfileVC.userProfileID = "\(final.value(forKey: "user_id")!)"
        self.navigationController?.pushViewController(objUserProfileVC, animated: true)
    }
    
    @IBAction func btngotoCreatPostVC()
    {
        appDelegate.bUserProfile = true
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objCreatPostVC = storyTab.instantiateViewController(withIdentifier: "CreatPostVC")
        self.navigationController?.pushViewController(objCreatPostVC, animated: true)
    }
    
    @IBAction func gotoOtherUserProfile(_ sender: Any, event: Any)
    {
        appDelegate.bUserProfile = false
        let touches = (event as AnyObject).allTouches!
        let touch = touches?.first!
        let currentTouchPosition = touch?.location(in: self.clFeeds)
        let indexPath = self.clFeeds.indexPathForItem(at: currentTouchPosition!)!
        let dicdata = self.arrFeeds[indexPath.row] as! NSDictionary
        
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objUserProfileVC = storyTab.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        objUserProfileVC.userProfileID = "\(dicdata.value(forKey: "user_id")!)"
        self.navigationController?.pushViewController(objUserProfileVC, animated: true)
    }
    @IBAction func gotoOtherUserProfileofHeaderCell(_ sender: Any, event: Any)
    {
        appDelegate.bUserProfile = false
        
        let touches = (event as AnyObject).allTouches!
        let touch = touches?.first!
        let currentTouchPosition = touch?.location(in: self.clHeader)
        let indexPath = self.clHeader.indexPathForItem(at: currentTouchPosition!)!
        let dicdata = self.arrUnreadUserFeeds[indexPath.row] as! NSDictionary
        
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objUserProfileVC = storyTab.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        objUserProfileVC.userProfileID = "\(dicdata.value(forKey: "user_id")!)"
        self.navigationController?.pushViewController(objUserProfileVC, animated: true)
    }

    @IBAction func gotoUserPost(_ sender: Any, event: Any)
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objViewPostVC = storyTab.instantiateViewController(withIdentifier: "ViewPostVC")
        self.navigationController?.pushViewController(objViewPostVC, animated: true)

    }
    
    override func didReceiveMemoryWarning()
    {
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
extension FeedsVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == clHeader
        {
            return arrUnreadUserFeeds.count
        }
        return arrFeeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == clHeader
        {
            let identifier = "FeedHeaderCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! FeedHeaderCell
            let dicdata = self.arrUnreadUserFeeds[indexPath.row] as! NSDictionary

            if let bgmediaurl = dicdata.value(forKey: "media") as? String
            {
                let url2 = URL(string: bgmediaurl)
                if url2 != nil {
                    cell.bgImage.sd_setImage(with: url2, placeholderImage: UIImage(named: "ic_feed_bg"))
                }
            }
            cell.btnUserName.setTitle("\(dicdata.value(forKey: "name")!)", for: .normal)
            cell.lblViewCount.text = "\(dicdata.value(forKey: "viewCount")!)"

            if let imgUserPic = dicdata.value(forKey: "profile_pic") as? String
            {
                let url2 = URL(string: imgUserPic)
                if url2 != nil {
                    cell.imgUser.sd_setImage(with: url2, placeholderImage: UIImage(named: "profile_pic_test"))
                }
            }
            cell.btnProfile.tag = indexPath.row
            cell.btnProfile.addTarget(self, action: #selector(FeedsVC.gotoOtherUserProfileofHeaderCell(_:event:)), for: .touchUpInside)
            cell.btnProfile.addTarget(self, action: #selector(FeedsVC.gotoOtherUserProfileofHeaderCell(_:event:)), for: .touchUpInside)

            return cell
        }
        else
        {
            let identifier = "FeedCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! FeedCell
            cell.bgImage.layer.masksToBounds = true
            let dicdata = self.arrFeeds[indexPath.row] as! NSDictionary

            if let bgmediaurl = dicdata.value(forKey: "media") as? String
            {
                let url2 = URL(string: bgmediaurl)
                if url2 != nil {
                    cell.bgImage.sd_setImage(with: url2, placeholderImage: UIImage(named: "ic_feed_bg"))
                }
            }
            
            if let imgUserPic = dicdata.value(forKey: "profile_pic") as? String
            {
                let url2 = URL(string: imgUserPic)
                if url2 != nil {
                    cell.imgUser.sd_setImage(with: url2, placeholderImage: UIImage(named: "profile_pic"))
                }
            }
            
            cell.btnUserName.setTitle("\(dicdata.value(forKey: "name")!)", for: .normal)
            cell.lblViewCount.text = "\(dicdata.value(forKey: "viewCount")!)"

            cell.btnProfile.tag = indexPath.row
            cell.btnProfile.addTarget(self, action: #selector(FeedsVC.gotoOtherUserProfile(_:event:)), for: .touchUpInside)
            cell.btnUserName.tag = indexPath.row
            cell.btnUserName.addTarget(self, action: #selector(FeedsVC.gotoOtherUserProfile(_:event:)), for: .touchUpInside)
            return cell
        }
    }
}

// MARK:- UICollectionViewDelegate Methods
extension FeedsVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objViewPostVC = storyTab.instantiateViewController(withIdentifier: "ViewPostVC") as! ViewPostVC
        var dicdata = NSDictionary()
        if collectionView == clHeader
        {
            dicdata = self.arrUnreadUserFeeds[indexPath.row] as! NSDictionary
        }
        else
        {
             dicdata = self.arrFeeds[indexPath.row] as! NSDictionary
        }
        objViewPostVC.strPostID = "\(dicdata.value(forKey: "post_id")!)"
        self.navigationController?.pushViewController(objViewPostVC, animated: true)
    }
}
