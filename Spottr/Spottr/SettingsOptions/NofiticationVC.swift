//
//  NofiticationVC.swift
//  Spottr
//
//  Created by Kevin on 20/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class NofiticationVC: UIViewController {

    @IBOutlet weak var tblNofitications : UITableView!
    var arrNotifications = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tblNofitications.estimatedRowHeight = 200
        self.tblNofitications.rowHeight = UITableViewAutomaticDimension

        self.getUserNotifications()
    }

    func getUserNotifications()
    {
        arrNotifications = NSMutableArray()
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let url = kServerURL + "notifications"
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
                        print("dicNotifications :> \(dictemp)")
                        
                        if let temp = dictemp.value(forKey: "error") as? NSDictionary
                        {
                            let msg = (temp.value(forKey: "message"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            self.arrNotifications = NSMutableArray(array: dictemp.value(forKey: "data") as! NSArray)
                        }
                        self.tblNofitications.reloadData()
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                self.tblNofitications.reloadData()
                break
            }
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension NofiticationVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NofiticationCell") as! NofiticationCell
        let dicdata = self.arrNotifications[indexPath.row] as! NSDictionary
        if let bgmediaurl = dicdata.value(forKey: "profile_pic") as? String
        {
            let url2 = URL(string: bgmediaurl)
            if url2 != nil {
                cell.imgProfile.sd_setImage(with: url2, placeholderImage: UIImage(named: "profile_pic"))
            }
        }
        cell.lblTitle.text = "\(dicdata.value(forKey: "description")!)"
        cell.lblTime.text = "\(dicdata.value(forKey: "created_at")!)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrNotifications.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
