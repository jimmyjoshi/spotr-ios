//
//  ViewPostVC.swift
//  Spottr
//
//  Created by Yash on 23/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class ViewPostVC: UIViewController
{
    @IBOutlet weak var tblPost : UITableView!
    var arrPosts = NSMutableArray()
    @IBOutlet weak var vwCommentOption : UIView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblPost.estimatedRowHeight = 200
        self.tblPost.rowHeight = UITableViewAutomaticDimension
    }
    @IBAction func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
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
        let cell = tblPost.cellForRow(at: indexPath)
        
        let currentTouchPosition1 = touch?.location(in: self.view)
        let popover = DXPopover()
//        popover.show(at: self.vwCommentOption, withContentView: self.view)
//        popover.show(at: self.tblPost, withContentView: self.vwCommentOption, in: self.view)
//        popover.show(at: self.vwCommentOption, withContentView: self.vwCommentOption)
        popover.show(at: currentTouchPosition1!, popoverPostion:.up, withContentView: self.vwCommentOption, in: self.view)
        popover.didDismissHandler = {
        }
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
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        cell.btnDeleteComment.tag = indexPath.row
        cell.btnDeleteComment.addTarget(self, action: #selector(self.openDeleteOptions(_:event:)), for: .touchUpInside)

        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 375
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell : ViewPostHeaderCell = tableView.dequeueReusableCell(withIdentifier: "ViewPostHeaderCell") as! ViewPostHeaderCell
        return cell.contentView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
