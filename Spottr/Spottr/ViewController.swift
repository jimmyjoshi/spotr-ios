//
//  ViewController.swift
//  Spottr
//
//  Created by Kevin on 16/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var txtUsername : UITextField!
    @IBOutlet weak var txtPassword : UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.isHidden = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnLoginNowPressed()
    {
        if (self.txtUsername.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter username", inView: self)
        }
        else if (self.txtPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter password", inView: self)
        }
        else
        {
            self.view .endEditing(true)
            self.callLoginAPI()
        }
    }
    
    func callLoginAPI()
    {
        let url = kServerURL + "login"
        let parameters: [String: Any] = ["username": self.txtUsername.text!, "password": self.txtPassword.text! ,"device_token" : appDelegate.strDeviceToken]
        
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
                                appDelegate.arrLoginData = dictemp.value(forKey: "data") as! NSDictionary
                                let data = NSKeyedArchiver.archivedData(withRootObject: appDelegate.arrLoginData)
                                UserDefaults.standard.set(data, forKey: kkeyLoginData)
                                UserDefaults.standard.set(true, forKey: kkeyisUserLogin)
                                UserDefaults.standard.synchronize()
                                self.gotoDashboard()
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
    
    func gotoDashboard()
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objFeedsVC = storyTab.instantiateViewController(withIdentifier: "FeedsVC")
        self.navigationController?.pushViewController(objFeedsVC, animated: true)
    }
    
    @IBAction func btnSignupPressed()
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objRegistrationNamePhoneVC = storyTab.instantiateViewController(withIdentifier: "RegistrationNamePhoneVC")
        self.navigationController?.pushViewController(objRegistrationNamePhoneVC, animated: true)
    }
    
    @IBAction func btnFogotPassword()
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objRegistrationNamePhoneVC = storyTab.instantiateViewController(withIdentifier: "FogrotPasswordVC")
        self.navigationController?.pushViewController(objRegistrationNamePhoneVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat
        {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
