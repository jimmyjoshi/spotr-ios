//
//  ViewFriendsVC.swift
//  Spottr
//
//  Created by Yash on 26/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class ViewFriendsVC: UIViewController
{
    @IBOutlet weak var tblFriend : UITableView!
    var arrFriends = NSMutableArray()
    @IBOutlet weak var vwRemoveFriendOption : UIView!
    var userProfileID : String?
    var popover = DXPopover()
    var dictFriend = NSDictionary()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblFriend.estimatedRowHeight = 200
        self.tblFriend.rowHeight = UITableViewAutomaticDimension
        
        showProgress(inView: self.view)
        self.getUserConnections()        
    }
    func getUserConnections()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let url = kServerURL + "my-connections"
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
                            self.arrFriends = NSMutableArray(array: dictemp.value(forKey: "data") as! NSArray)
                        }
                        self.tblFriend.reloadData()
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                self.tblFriend.reloadData()
                break
            }
        }
    }
    
    @IBAction func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func openRemoveOptions(_ sender: Any, event: Any)
    {
        let touches = (event as AnyObject).allTouches!
        let touch = touches?.first!
        let currentTouchPosition = touch?.location(in: self.tblFriend)
        let indexPath = self.tblFriend.indexPathForRow(at: currentTouchPosition!)!
        self.dictFriend = self.arrFriends[indexPath.row] as! NSDictionary
        
        let currentTouchPosition1 = touch?.location(in: self.view)
        
        //        popover.show(at: self.vwCommentOption, withContentView: self.view)
        //        popover.show(at: self.tblPost, withContentView: self.vwCommentOption, in: self.view)
        //        popover.show(at: self.vwCommentOption, withContentView: self.vwCommentOption)
        popover.show(at: currentTouchPosition1!, popoverPostion:.up, withContentView: self.vwRemoveFriendOption, in: self.view)
        popover.didDismissHandler = {
        }
    }
    
    @IBAction func removeFriendAction()
    {
        self.popover.dismiss()
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let url = kServerURL + "connections/delete"
        let token = final .value(forKey: "token")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        let parameters: [String: Any] = ["user_id": "\(self.dictFriend.value(forKey: "user_id")!)"]
        showProgress(inView: self.view)
        
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
                            showProgress(inView: self.view)
                            self.getUserConnections()
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
    
    @IBAction func blockFriendAction()
    {
        self.popover.dismiss()
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let url = kServerURL + "connections/block"
        let token = final .value(forKey: "token")
        let headers = ["Authorization":"Bearer \(token!)"]
        let parameters: [String: Any] = ["user_id": "\(self.dictFriend.value(forKey: "user_id")!)"]
        
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
                            self.popover.didDismissHandler = {
                            }
                            showProgress(inView: self.view)
                            self.getUserConnections()
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
extension ViewFriendsVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell") as! FriendsTableViewCell
        
        cell.imgUserProfile.layer.masksToBounds = true
        
        let dicdata = self.arrFriends[indexPath.row] as! NSDictionary
        if let bgmediaurl = dicdata.value(forKey: "profile_pic") as? String
        {
            let url2 = URL(string: bgmediaurl)
            if url2 != nil {
                cell.imgUserProfile.sd_setImage(with: url2, placeholderImage: UIImage(named: "profile_pic"))
            }
        }
        cell.lblUserName.text = "\(dicdata.value(forKey: "name")!)"

        cell.btnRemoveFriend.tag = indexPath.row
        cell.btnRemoveFriend.addTarget(self, action: #selector(self.openRemoveOptions(_:event:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrFriends.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

