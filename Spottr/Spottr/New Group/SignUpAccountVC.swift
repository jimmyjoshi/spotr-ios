//
//  SignUpAccountVC.swift
//  Spottr
//
//  Created by Kevin on 19/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class SignUpAccountVC: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    @IBOutlet weak var txtFullName : UITextField!
    @IBOutlet weak var txtEmailAddress : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var txtConfirmPassword : UITextField!
    @IBOutlet weak var txtGender : UITextField!
    @IBOutlet weak var txtBirthday : UITextField!
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    var image = UIImage()
    @IBOutlet weak var btnImageofUser : UIButton!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        btnImageofUser.layer.masksToBounds = true
        
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
        if (self.txtFullName.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter full name", inView: self)
        }
        else if (self.txtEmailAddress.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter email address", inView: self)
        }
        else if (self.txtBirthday.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please select birthday", inView: self)
        }
        else if (self.txtGender.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please select gender", inView: self)
        }
        else if (self.txtPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter password", inView: self)
        }
        else if (self.txtConfirmPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter confirm password", inView: self)
        }
        else if (self.txtPassword.text! != self.txtConfirmPassword.text!)
        {
            App_showAlert(withMessage: "Password and confirm password must be same", inView: self)
        }
        else
        {
            self.view .endEditing(true)
            self.callSignupProcess()
        }
    }
    
    func callSignupProcess()
    {
        appDelegate.dicRegisterParameters.setValue(txtFullName.text!, forKey: "name")
        appDelegate.dicRegisterParameters.setValue(txtEmailAddress.text!, forKey: "email")
        appDelegate.dicRegisterParameters.setValue(txtPassword.text!, forKey: "password")
        appDelegate.dicRegisterParameters.setValue(txtBirthday.text!, forKey: "dob")
        appDelegate.dicRegisterParameters.setValue(txtGender.text!, forKey: "gender")
        appDelegate.dicRegisterParameters.setValue(appDelegate.strDeviceToken, forKey: "device_token")
       
        let parameters = [
            "name": "\(txtFullName.text!)",
            "email": "\(txtEmailAddress.text!)",
            "password" : "\(txtPassword.text!)",
            "dob":"\(appDelegate.strDeviceToken)",
            "gender" : "\(txtGender.text!)",
            "device_token" : "\(appDelegate.strDeviceToken)",
            "username" : "\(appDelegate.dicRegisterParameters.value(forKey: "username")!)",
            "phone" : "\(appDelegate.dicRegisterParameters.value(forKey: "phone")!)"
        ]
        
        upload(multipartFormData:
            { (multipartFormData) in
                
                if let imageData2 = UIImageJPEGRepresentation(self.image, 1)
                {
                    multipartFormData.append(imageData2, withName: "profile_pic", fileName: "profile_pic.png", mimeType: "File")
                }
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
        }, to: "\(kServerURL)register.php", method: .post, headers: ["Content-Type": "application/x-www-form-urlencoded"], encodingCompletion:
            {
                (result) in
                switch result
                {
                case .success(let upload, _, _):
                    upload.responseJSON
                        {
                            response in
                            hideProgress()
                            
                            print(response.request) // original URL request
                            print(response.response) // URL response
                            print(response.data) // server data
                            print(response.result) // result of response serialization
                            
                            /*  if let JSON = response.result.value
                             {
                             print("JSON: \(JSON)")
                             }
                             do {
                             let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments)
                             print(json)
                             //Why don't you use decoded JSON object? (`json` may not be a `String`)
                             } catch {
                             print("error serializing JSON: \(error)")
                             }*/
                            
                            
                            if let json = response.result.value
                            {
                                print("json :> \(json)")
                                let dictemp = json as! NSDictionary
                                print("dictemp :> \(dictemp)")
                                if dictemp.count > 0
                                {
                                    if  let dictemp2 = dictemp["data"] as? NSDictionary
                                    {
                                        print("dictemp :> \(dictemp2)")
                                        
                                        appDelegate.arrLoginData = dictemp2
                                        
                                        let data = NSKeyedArchiver.archivedData(withRootObject: appDelegate.arrLoginData)
                                        UserDefaults.standard.set(data, forKey: kkeyLoginData)
                                        UserDefaults.standard.set(true, forKey: kkeyisUserLogin)
                                        
                                        let alertView = UIAlertController(title: Application_Name, message: "Signup Successfully", preferredStyle: .alert)
                                        let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                                            let storyTab = UIStoryboard(name: "Tabbar", bundle: nil)
                                            let tabbar = storyTab.instantiateViewController(withIdentifier: "TabBarViewController")
                                            self.navigationController?.pushViewController(tabbar, animated: true)
                                        }
                                        alertView.addAction(OKAction)
                                        self.present(alertView, animated: true, completion: nil)
                                    }
                                    else
                                    {
                                        App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                                    }
                                }
                                else
                                {
                                    App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                                }
                            }
                    }
                case .failure(let encodingError):
                    hideProgress()
                    print(encodingError)
                }
        })
    }
    
    func gotoFeeds()
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

    //MARK: Select Image
    @IBAction func SelectImage()
    {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            App_showAlert(withMessage: "You don't have camera", inView: self)
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        image = resize(chosenImage)
        btnImageofUser.setImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("picker cancel.")
        dismiss(animated: true, completion: nil)
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
