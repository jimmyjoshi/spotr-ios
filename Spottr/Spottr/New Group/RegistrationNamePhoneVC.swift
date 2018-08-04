//
//  RegistrationNamePhoneVC.swift
//  Spottr
//
//  Created by Kevin on 19/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Firebase

class RegistrationNamePhoneVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtUsername : UITextField!
    @IBOutlet weak var txtPhone : UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        appDelegate.dicRegisterParameters = NSMutableDictionary()
//        Auth.auth().languageCode = "IN";

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

    @IBAction func btnNextPressed()
    {
        if (self.txtUsername.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter username", inView: self)
        }
        else if (self.txtPhone.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter phone number", inView: self)
        }
        else
        {
            appDelegate.dicRegisterParameters.setValue(txtUsername.text!, forKey: "username")
            appDelegate.dicRegisterParameters.setValue(txtPhone.text!, forKey: "phone")
            
            showProgress(inView: self.view)

            PhoneAuthProvider.provider().verifyPhoneNumber(txtPhone.text!, uiDelegate: nil) { (verificationID, error) in
                if let error = error
                {
                    hideProgress()
                    App_showAlert(withMessage: "\(error.localizedDescription)", inView: self)
                    return
                }
                else
                {
                    hideProgress()
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")

                    let storyTab = UIStoryboard(name: "Main", bundle: nil)
                    let objSignupOTPVC = storyTab.instantiateViewController(withIdentifier: "SignupOTPVC")
                    self.navigationController?.pushViewController(objSignupOTPVC, animated: true)
                }
            }
        }
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
