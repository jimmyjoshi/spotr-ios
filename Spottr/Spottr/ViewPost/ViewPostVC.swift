//
//  ViewPostVC.swift
//  Spottr
//
//  Created by Yash on 23/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewPostVC: UIViewController,UIWebViewDelegate
{
    @IBOutlet weak var tblPost : UITableView!
    var arrComments = NSMutableArray()
    @IBOutlet weak var vwCommentOption : UIView!
    var strPostID = String()
    var dictPost = NSDictionary()
    @IBOutlet weak var vwPostComment : UIView!
    @IBOutlet weak var txtvwComment : UITextView!
    var dictSelected = NSDictionary()
    var popover = DXPopover()
    @IBOutlet weak var lblPostUserName : UILabel!
    @IBOutlet weak var lblTaggedUserName : UILabel!
    @IBOutlet weak var vwImgFullScreen : UIView!
    @IBOutlet weak var wvImgFull : UIWebView!


    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblPost.estimatedRowHeight = 200
        self.tblPost.rowHeight = UITableViewAutomaticDimension
        
        self.tblPost.sectionHeaderHeight = UITableViewAutomaticDimension;
        self.tblPost.estimatedSectionHeaderHeight = 300;

        self.vwImgFullScreen.isHidden = true

        showProgress(inView: self.view)
        self.getUserPosts()
    }
    @IBAction func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func getUserPosts()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let url = kServerURL + "posts/show"
        let token = final .value(forKey: "token")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        let parameters: [String: Any] = ["post_id": strPostID]
        
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
                            self.dictPost = dictemp.value(forKey: "data") as! NSDictionary
                            self.lblPostUserName.text = "\(self.dictPost.value(forKey: "post_user_name")!)"
                            self.lblTaggedUserName.text = "\(self.dictPost.value(forKey: "tagged_user_name")!)"
                            self.arrComments = NSMutableArray(array: self.dictPost.value(forKey: "comments") as! NSArray)
                        }
                        self.tblPost.reloadData()
                        self.tblPost.delegate = self
                        self.tblPost.dataSource = self
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                self.tblPost.reloadData()
                self.tblPost.delegate = self
                self.tblPost.dataSource = self
                break
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openDeleteOptions(_ sender: Any, event: Any)
    {
        let touches = (event as AnyObject).allTouches!
        let touch = touches?.first!
        let currentTouchPosition = touch?.location(in: self.tblPost)
        let indexPath = self.tblPost.indexPathForRow(at: currentTouchPosition!)!
        
        self.dictSelected = self.arrComments[indexPath.row] as! NSDictionary
        let currentTouchPosition1 = touch?.location(in: self.view)
//        popover.show(at: self.vwCommentOption, withContentView: self.view)
//        popover.show(at: self.tblPost, withContentView: self.vwCommentOption, in: self.view)
//        popover.show(at: self.vwCommentOption, withContentView: self.vwCommentOption)
        popover.show(at: currentTouchPosition1!, popoverPostion:.up, withContentView: self.vwCommentOption, in: self.view)
        popover.didDismissHandler = {
        }
    }
    
     @objc func handleLongPress(sender: UILongPressGestureRecognizer)
     {
        if sender.state == UIGestureRecognizerState.began
        {
            let touchPoint = sender.location(in: self.tblPost)
            if let indexPath = self.tblPost.indexPathForRow(at: touchPoint)
            {
                // your code here, get the row for the indexPath or do whatever you want
                self.dictSelected = self.arrComments[indexPath.row] as! NSDictionary
                let currentTouchPosition1 = sender.location(in: self.view)
                popover.show(at: currentTouchPosition1, popoverPostion:.up, withContentView: self.vwCommentOption, in: self.view)
                popover.didDismissHandler = {
                }
            }
        }
    }

    
    @IBAction func deleteCommentAction()
    {
        self.popover.dismiss()
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let url = kServerURL + "comments/delete"
        let token = final .value(forKey: "token")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        let parameters: [String: Any] = ["comment_id": "\(self.dictSelected.value(forKey: "comment_id")!)"]
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
                            let msg = (temp.value(forKey: "message"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            

                            showProgress(inView: self.view)
                            self.getUserPosts()
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
    
    @IBAction func reportAbuseCommentAction()
    {
        self.popover.dismiss()
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let url = kServerURL + "comments/blocked"
        let token = final .value(forKey: "token")
        let headers = ["Authorization":"Bearer \(token!)"]
        let parameters: [String: Any] = ["comment_id": "\(self.dictSelected.value(forKey: "comment_id")!)"]
        
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
                            self.popover.didDismissHandler = {
                            }
                            showProgress(inView: self.view)
                            self.getUserPosts()
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
    @IBAction func btngotoUserProfile()
    {
        appDelegate.bUserProfile = false
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objUserProfileVC = storyTab.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        objUserProfileVC.userProfileID = "\(self.dictPost.value(forKey: "user_id")!)"
        self.navigationController?.pushViewController(objUserProfileVC, animated: true)
    }
    @IBAction func gotoOtherUserProfile()
    {
        appDelegate.bUserProfile = false
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objUserProfileVC = storyTab.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        objUserProfileVC.userProfileID = "\(self.dictPost.value(forKey: "tag_user_id")!)"
        self.navigationController?.pushViewController(objUserProfileVC, animated: true)
    }
    
    //MARK: Post Comment
    @IBAction func btnAddCommentAction()
    {
        vwPostComment.isHidden = false
    }
    
    @IBAction func btnPostCommentAction()
    {
        if (self.txtvwComment.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter comment", inView: self)
        }
        else
        {
            let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
            let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
            let url = kServerURL + "comments/create"
            let token = final .value(forKey: "token")
            let headers = ["Authorization":"Bearer \(token!)"]
            
            let parameters = [
                "comment" : "\(self.txtvwComment.text!)",
                "post_id" : strPostID
            ]
            
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
                                self.vwPostComment.isHidden = true
                                showProgress(inView: self.view)
                                self.getUserPosts()
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
    }
    
    @IBAction func btnPostViewCancel()
    {
        vwPostComment.isHidden = true
    }
    
    @IBAction func playVideoAction()
    {
        if let bgmediaurl = self.dictPost.value(forKey: "media") as? String
        {
            let url2 = URL(string: bgmediaurl)
            if url2 != nil
            {
                let player = AVPlayer(url: url2!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
        }
    }
    
    //MARK: Show image as Full Screen
    @objc func imgTapped(sender : UITapGestureRecognizer)
    {
        self.vwImgFullScreen.isHidden = false
        wvImgFull.isOpaque = false
        wvImgFull.backgroundColor = UIColor.clear

        if "\(self.dictPost.value(forKey: "is_image")!)" == "1"
        {
            if let bgmediaurl = self.dictPost.value(forKey: "media") as? String
            {
                let url2 = URL(string: bgmediaurl)
                if url2 != nil
                {
                    wvImgFull.loadRequest(URLRequest(url: url2!))
                }
            }
        }
    }
    @IBAction func closeImgFullScreen()
    {
        self.vwImgFullScreen.isHidden = true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        showProgress(inView: self.vwImgFullScreen)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        hideProgress()
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
extension ViewPostVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if UITableViewAutomaticDimension < 100
        {
            return 100
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if UITableViewAutomaticDimension < 70
        {
            return 70
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        let dicdata = self.arrComments[indexPath.row] as! NSDictionary
        if let bgmediaurl = dicdata.value(forKey: "profile_pic") as? String
        {
            let url2 = URL(string: bgmediaurl)
            if url2 != nil {
                cell.imgPost.sd_setImage(with: url2, placeholderImage: UIImage(named: "ic_feed_bg"))
            }
        }
        cell.imgPost.layer.masksToBounds = true
       // cell.lblComment.text = "\(dicdata.value(forKey: "comment")!)"
        cell.btnDeleteComment.tag = indexPath.row
        cell.btnDeleteComment.addTarget(self, action: #selector(self.openDeleteOptions(_:event:)), for: .touchUpInside)
        
        let attrs1 = [NSAttributedStringKey.font : cell.lblComment.font.withSize(15)
, NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let attrs2 = [NSAttributedStringKey.font : cell.lblComment.font.withSize(15), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        
        let attributedString1 = NSMutableAttributedString(string:"\(dicdata.value(forKey: "name")!)", attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:" \(dicdata.value(forKey: "comment")!)", attributes:attrs2)
        attributedString1.append(attributedString2)
        cell.lblComment.attributedText = attributedString1


        cell.selectionStyle = .none
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        cell.addGestureRecognizer(longPress)

        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrComments.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if dictPost.count > 0
        {
            return UITableViewAutomaticDimension
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell : ViewPostHeaderCell = tableView.dequeueReusableCell(withIdentifier: "ViewPostHeaderCell") as! ViewPostHeaderCell
        
        if "\(self.dictPost.value(forKey: "is_image")!)" == "1"
        {
            if let bgmediaurl = self.dictPost.value(forKey: "media") as? String
            {
                let url2 = URL(string: bgmediaurl)
                if url2 != nil
                {
                    cell.imgPost.sd_setImage(with: url2, placeholderImage: UIImage(named: "ic_feed_bg"))
                }
            }
            cell.btnPlayVideoIcon.isHidden = true
        }
        else
        {
            if let bgmediaurl = self.dictPost.value(forKey: "thumbnail") as? String
            {
                let url2 = URL(string: bgmediaurl)
                if url2 != nil {
                    cell.imgPost.sd_setImage(with: url2, placeholderImage: UIImage(named: "ic_feed_bg"))
                }
            }
            cell.btnPlayVideoIcon.isHidden = false
        }
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.imgTapped(sender:)))
        cell.imgPost.addGestureRecognizer(gesture)

        
        cell.btnPlayVideoIcon.addTarget(self, action: #selector(self.playVideoAction), for: .touchUpInside)

        cell.lblViewCount.text = "\(self.dictPost.value(forKey: "viewCount")!)"
        cell.lblCommentCount.text = "\(self.dictPost.value(forKey: "comments_count")!)"
        cell.lblPostDescription.text = "\(self.dictPost.value(forKey: "description")!)"
        cell.layoutIfNeeded()
        return cell.contentView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}
