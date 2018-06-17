//
//  FogrotPasswordVC.swift
//  Spottr
//
//  Created by Yash on 13/06/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class FogrotPasswordVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var txtUsername : UITextField! 

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    @IBAction func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDonePressed()
    {
        if (self.txtUsername.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter email address", inView: self)
        }
        else
        {
            self.view .endEditing(true)
            let url = kServerURL + "forgotpassword"
            let parameters: [String: Any] = ["email": self.txtUsername.text!]
            
            showProgress(inView: self.view)
            print("parameters:>\(parameters)")
            request(url, method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
                
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
                            
                            if dictemp.count > 0
                            {
                                if let err  =  dictemp.value(forKey: kkeyError)
                                {
                                    App_showAlert(withMessage: err as! String, inView: self)
                                }
                                else
                                {
                                    let alertView = UIAlertController(title: Application_Name, message: (dictemp.value(forKey: "data") as! NSDictionary).value(forKey: kkeymessage) as? String, preferredStyle: .alert)
                                    let OKAction = UIAlertAction(title: "OK", style: .default)
                                    { (action) in
                                        _ =  self.navigationController?.popViewController(animated: true)
                                    }
                                    alertView.addAction(OKAction)
                                    self.present(alertView, animated: true, completion: nil)
                                }
                            }
                            else
                            {
                                App_showAlert(withMessage: dictemp[kkeyError]! as! String, inView: self)
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
            /*request("\(kServerURL)login.php", method: .post, parameters:parameters).responseString{ response in
             debugPrint(response)
             }*/
        }
    }
    
    func gotoLoginPage()
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
