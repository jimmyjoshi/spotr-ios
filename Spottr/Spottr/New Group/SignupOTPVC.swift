//
//  SignupOTPVC.swift
//  Spottr
//
//  Created by Kevin on 19/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Firebase

class SignupOTPVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtOTP : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func btnVerifyPressed()
    {
        if (txtOTP.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter OTP", inView: self)
        }
        else
        {
            showProgress(inView: self.view)
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            let verificationCode = txtOTP.text!
            
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
                verificationCode: verificationCode)
            
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error
                {
                    hideProgress()
                    App_showAlert(withMessage: "\(error.localizedDescription)", inView: self)
                    return
                }
                else
                {
                    hideProgress()
                    let storyTab = UIStoryboard(name: "Main", bundle: nil)
                    let objSignUpAccountVC = storyTab.instantiateViewController(withIdentifier: "SignUpAccountVC")
                    self.navigationController?.pushViewController(objSignUpAccountVC, animated: true)
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
