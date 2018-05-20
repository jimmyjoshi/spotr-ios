//
//  SignupOTPVC.swift
//  Spottr
//
//  Created by Kevin on 19/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class SignupOTPVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtOTP1 : UITextField!
    @IBOutlet weak var txtOTP2 : UITextField!
    @IBOutlet weak var txtOTP3 : UITextField!
    @IBOutlet weak var txtOTP4 : UITextField!

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
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objSignUpAccountVC = storyTab.instantiateViewController(withIdentifier: "SignUpAccountVC")
        self.navigationController?.pushViewController(objSignUpAccountVC, animated: true)
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
