//
//  SignUpLastStepVC.swift
//  Spottr
//
//  Created by Kevin on 19/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class SignUpLastStepVC: UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var txtGender : UITextField!
    @IBOutlet weak var txtBirthday : UITextField!
    @IBOutlet weak var txtPhone : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK : Button Click Actions
    @IBAction func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSignupPressed()
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objFeedsVC = storyTab.instantiateViewController(withIdentifier: "FeedsVC")
        self.navigationController?.pushViewController(objFeedsVC, animated: true)
    }
    @IBAction func btngotoLoginPressed()
    {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        textField.resignFirstResponder()
        return true
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
