//
//  SignUpAccountVC.swift
//  Spottr
//
//  Created by Kevin on 19/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class SignUpAccountVC: UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var txtFullName : UITextField!
    @IBOutlet weak var txtEmailAddress : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var txtConfirmPassword : UITextField!
    @IBOutlet weak var txtGender : UITextField!
    @IBOutlet weak var txtBirthday : UITextField!

    
    override func viewDidLoad()
    {
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
    @IBAction func btnNextPressed()
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objFeedsVC = storyTab.instantiateViewController(withIdentifier: "FeedsVC")
        self.navigationController?.pushViewController(objFeedsVC, animated: true)
    }
    @IBAction func btngotoLoginPressed()
    {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btnSelectGenderPressed(_ sender: UIButton)
    {
        ActionSheetStringPicker.show(withTitle: "Select Gender", rows: ["Male", "Female"], initialSelection: 0, doneBlock: {
            picker, value, index in
            self.txtGender.text = "\(index!)"
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func btnSelectDatePressed(_ sender: UIButton)
    {
        let datePicker = ActionSheetDatePicker(title: "Select Date", datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            let aDate = value! as! Date

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myString = formatter.string(from: aDate) // string purpose I add here
            let yourDate = formatter.date(from: myString)
            formatter.dateFormat = "dd MMM yyyy"
            let myStringafd = formatter.string(from: yourDate!)
            self.txtBirthday.text = myStringafd
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        datePicker?.maximumDate = Date()
        datePicker?.show()
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
