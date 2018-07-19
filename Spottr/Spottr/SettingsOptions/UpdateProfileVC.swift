//
//  UpdateProfileVC.swift
//  Spottr
//
//  Created by Kevin on 20/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class UpdateProfileVC: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    @IBOutlet weak var lblFullName : UILabel!
    @IBOutlet weak var lblEmailAddress : UILabel!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var txtConfirmPassword : UITextField!
    @IBOutlet weak var lblAge : UILabel!
    @IBOutlet weak var lblGender : UILabel!
    var dictUserDetails = NSDictionary()
    @IBOutlet weak var imgProfile : UIImageView!
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    var image = UIImage()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imgProfile.layer.masksToBounds = true
        if let imgUserPic = self.dictUserDetails.value(forKey: "profile_pic") as? String
        {
            let url2 = URL(string: imgUserPic)
            if url2 != nil {
                imgProfile.sd_setImage(with: url2, placeholderImage: UIImage(named: "profile_pic"))
            }
        }
        // Do any additional setup after loading the view.
        lblFullName.text = "\(self.dictUserDetails.value(forKey: "name")!)"
        lblEmailAddress.text = "\(self.dictUserDetails.value(forKey: "email")!)"
        lblAge.text = "\(self.dictUserDetails.value(forKey: "dob")!)"
        if (lblAge.text?.count)! > 0
        {
            lblAge.text = "\(self.calcAge(birthday: lblAge.text!))"
        }
        lblGender.text = "\(self.dictUserDetails.value(forKey: "gender")!)"
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
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calcAge(birthday: String) -> Int
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
    //MARK: Updte Profile
    @IBAction func btnUpdateProfileAction(_ sender: UIButton)
    {
        
    }
    
    //MARK: Select Age and Gender
    @IBAction func btnSelectGenderPressed(_ sender: UIButton)
    {
        ActionSheetStringPicker.show(withTitle: "Select Gender", rows: ["Male", "Female"], initialSelection: 0, doneBlock: {
            picker, value, index in
            self.lblGender.text = "\(index!)"
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
            formatter.dateFormat = "yyyy-MM-dd"
            let myStringafd = formatter.string(from: yourDate!)
            self.lblAge.text = myStringafd
            self.lblAge.text = "\(self.calcAge(birthday: self.lblAge.text!))"

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
        self.imgProfile.image = image
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("picker cancel.")
        dismiss(animated: true, completion: nil)
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
