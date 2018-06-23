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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblFriend.estimatedRowHeight = 200
        self.tblFriend.rowHeight = UITableViewAutomaticDimension
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
        let cell = tblFriend.cellForRow(at: indexPath)
        
        let currentTouchPosition1 = touch?.location(in: self.view)
        let popover = DXPopover()
        //        popover.show(at: self.vwCommentOption, withContentView: self.view)
        //        popover.show(at: self.tblPost, withContentView: self.vwCommentOption, in: self.view)
        //        popover.show(at: self.vwCommentOption, withContentView: self.vwCommentOption)
        popover.show(at: currentTouchPosition1!, popoverPostion:.up, withContentView: self.vwRemoveFriendOption, in: self.view)
        popover.didDismissHandler = {
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
        cell.btnRemoveFriend.tag = indexPath.row
        cell.btnRemoveFriend.addTarget(self, action: #selector(self.openRemoveOptions(_:event:)), for: .touchUpInside)

        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

