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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btngotoUserProfile()
    {
        appDelegate.bUserProfile = true
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objUserProfileVC = storyTab.instantiateViewController(withIdentifier: "UserProfileVC")
        self.navigationController?.pushViewController(objUserProfileVC, animated: true)
    }
    
    @IBAction func gotoOtherUserProfile(_ sender: Any, event: Any)
    {
        appDelegate.bUserProfile = false
        let touches = (event as AnyObject).allTouches!
        let touch = touches?.first!
        let currentTouchPosition = touch?.location(in: self.clFeeds)
        var indexPath = self.clFeeds.indexPathForItem(at: currentTouchPosition!)!

        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objUserProfileVC = storyTab.instantiateViewController(withIdentifier: "UserProfileVC")
        self.navigationController?.pushViewController(objUserProfileVC, animated: true)
    }
    @IBAction func gotoOtherUserProfileofHeaderCell(_ sender: Any, event: Any)
    {
        appDelegate.bUserProfile = false
        
        let touches = (event as AnyObject).allTouches!
        let touch = touches?.first!
        let currentTouchPosition = touch?.location(in: self.clHeader)
        var indexPath = self.clHeader.indexPathForItem(at: currentTouchPosition!)!

        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objUserProfileVC = storyTab.instantiateViewController(withIdentifier: "UserProfileVC")
        self.navigationController?.pushViewController(objUserProfileVC, animated: true)
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
            return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == clHeader
        {
            let identifier = "FeedHeaderCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! FeedHeaderCell
            cell.btnProfile.tag = indexPath.row
            cell.btnProfile.addTarget(self, action: #selector(FeedsVC.gotoOtherUserProfileofHeaderCell(_:event:)), for: .touchUpInside)

            return cell
        }
        else
        {
            let identifier = "FeedCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! FeedCell
            cell.btnProfile.tag = indexPath.row
            cell.btnProfile.addTarget(self, action: #selector(FeedsVC.gotoOtherUserProfile(_:event:)), for: .touchUpInside)

            return cell
        }
    }
}

// MARK:- UICollectionViewDelegate Methods

extension FeedsVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    }
}
