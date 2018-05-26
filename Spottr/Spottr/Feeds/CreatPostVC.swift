//
//  CreatPostVC.swift
//  Spottr
//
//  Created by Kevin on 20/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class CreatPostVC: UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var txtSearch : UITextField!
    @IBOutlet weak var btnSearchIcon : UIButton!
    @IBOutlet weak var clUsers : UICollectionView!
    @IBOutlet weak var txtvwDescription : UITextView!
    var arrSelection = NSMutableArray()
    var arrUsersData = NSMutableArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnPostAction()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectUsertoSpot(_ sender: Any, event: Any)
    {
        let touches = (event as AnyObject).allTouches!
        let touch = touches?.first!
        let currentTouchPosition = touch?.location(in: self.clUsers)
        var indexPath = self.clUsers.indexPathForItem(at: currentTouchPosition!)!
        
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
extension CreatPostVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "CreatPostUserCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! CreatPostUserCell
        cell.btnSelectUser.tag = indexPath.row
        cell.btnSelectUser.addTarget(self, action: #selector(CreatPostVC.selectUsertoSpot(_:event:)), for: .touchUpInside)

        return cell
    }
}
// MARK:- UICollectionViewDelegate Methods
extension CreatPostVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    }
}
