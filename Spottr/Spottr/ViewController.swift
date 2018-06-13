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
        let objFeedsVC = storyTab.instantiateViewController(withIdentifier: "FeedsVC")
        self.navigationController?.pushViewController(objFeedsVC, animated: true)

       // }
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
