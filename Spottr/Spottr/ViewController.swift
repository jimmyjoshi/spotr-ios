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
      /*
        if (self.txtUsername.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter username", inView: self)
        }
        else if (self.txtPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter password", inView: self)
        }
        else
        {*/
            let storyTab = UIStoryboard(name: "Main", bundle: nil)
            let objRegistrationNamePhoneVC = storyTab.instantiateViewController(withIdentifier: "RegistrationNamePhoneVC")
            self.navigationController?.pushViewController(objRegistrationNamePhoneVC, animated: true)
       // }
    }
    
    @IBAction func btnSignupPressed()
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let tabbar = storyTab.instantiateViewController(withIdentifier: "SignUpVC")
        self.navigationController?.pushViewController(tabbar, animated: true)
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
}
