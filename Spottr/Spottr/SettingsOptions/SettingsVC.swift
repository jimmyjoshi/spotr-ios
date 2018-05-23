//
//  SettingsVC.swift
//  Spottr
//
//  Created by Kevin on 20/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController
{
    @IBOutlet weak var tblSetting : UITableView!
    @IBOutlet weak var csoftblSettingHieght : NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblSetting.estimatedRowHeight = 44
        self.tblSetting.rowHeight = UITableViewAutomaticDimension
        csoftblSettingHieght.constant = 47*3
        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
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
extension SettingsVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingOptionsCell") as! SettingOptionsCell
        
        switch indexPath.row
        {
        case 0:
            cell.lblTitle.text = "About Us"
            break
        case 1:
            cell.lblTitle.text = "Privacy & Policy"
            break
        case 2:
            cell.lblTitle.text = "Rate Us"
            break
        default:
            break
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
