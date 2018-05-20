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

    override func viewDidLoad()
    {
        super.viewDidLoad()

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
    }

    @IBAction func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSettingsAction()
    {
        vwSettings.isHidden = false
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
            let identifier = "UserFeedsCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! UserFeedsCell
            return cell
    }
}

// MARK:- UICollectionViewDelegate Methods

extension UserProfileVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
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
            _ = self.navigationController?.popToRootViewController(animated: true)
            break
        default:
            break
        }    }
}
