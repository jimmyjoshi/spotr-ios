//
//  CreatPostVC.swift
//  Spottr
//
//  Created by Kevin on 20/05/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class CreatPostVC: UIViewController,UITextFieldDelegate,IQMediaPickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    @IBOutlet weak var txtSearch : UITextField!
    @IBOutlet weak var btnSearchIcon : UIButton!
    @IBOutlet weak var clUsers : UICollectionView!
    @IBOutlet weak var txtvwDescription : UITextView!
    var arrSelection = NSMutableArray()
    var arrUsersData = NSMutableArray()
    var mediaInfo = NSDictionary()
    var picker = UIImagePickerController()
    var isImageUploaded : Bool = false
    var isVideoUploaded : Bool = false
    var videoData = Data()
    @IBOutlet weak var imgtaken : UIImageView!
    @IBOutlet weak var btnTakePhoto : UIButton!
    @IBOutlet weak var btnDeletePhoto : UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnPostAction()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Camera Action
    @IBAction func btnCameraAction()
    {
        let uiAlert = UIAlertController(title: Application_Name, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        self.present(uiAlert, animated: true, completion: nil)
        uiAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
            {
                let controller = IQMediaPickerController()
                controller.delegate = self
                //Set additional settings if you would like to
                //[controller setSourceType:IQMediaPickerControllerSourceTypeCameraMicrophone];//or IQMediaPickerControllerSourceTypeLibrary
                //[controller setMediaTypes:@[@(IQMediaPickerControllerMediaTypeAudio),@(IQMediaPickerControllerMediaTypeAudio),@(IQMediaPickerControllerMediaTypeAudio)]];
                //controller.captureDevice = IQMediaPickerControllerCameraDeviceRear;//orIQMediaPickerControllerCameraDeviceFront
                //controller.allowsPickingMultipleItems = YES;//or NO
                //        controller.allowedVideoQualities = @[@(IQMediaPickerControllerQualityType1920x1080),@(IQMediaPickerControllerQualityTypeHigh)];
                var mediaTypesArr = [NSNumber]()
                mediaTypesArr.append(NSNumber(value: IQMediaPickerControllerMediaType.photo.rawValue))
                mediaTypesArr.append(NSNumber(value: IQMediaPickerControllerMediaType.video.rawValue))
                controller.mediaTypes = mediaTypesArr
                
                controller.captureDevice = IQMediaPickerControllerCameraDevice.rear
                var qualityArr = [NSNumber]()
                qualityArr.append(NSNumber(value: IQMediaPickerControllerQualityType.typeHigh.rawValue))
                qualityArr.append(NSNumber(value: IQMediaPickerControllerQualityType.type1920x1080.rawValue))
                controller.allowedVideoQualities = qualityArr
                controller.sourceType = IQMediaPickerControllerSourceType.cameraMicrophone
                
                self.present(controller, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
            
            self.picker.mediaTypes = ["public.image", "public.movie"]
            self.picker.mediaTypes = [kUTTypeMovie as NSString as String]
            self.picker.allowsEditing = false
            self.present(self.picker, animated: true, completion: nil)
        }))
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
        
       /* picker = UIImagePickerController() //make a clean controller
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.cameraCaptureMode = .photo
        picker.showsCameraControls = false
        
        self.vwCustomOverlay.isHidden = false
        vwCustomOverlay.frame = self.picker.view.frame
        self.picker.cameraOverlayView = self.vwCustomOverlay

        self.picker.cameraOverlayView?.backgroundColor = UIColor.red
        //picker.delegate = self  //uncomment if you want to take multiple pictures.
        
        //presentation of the camera
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)*/
    }
    
    @IBAction func selectUsertoSpot(_ sender: Any, event: Any)
    {
        let touches = (event as AnyObject).allTouches!
        let touch = touches?.first!
        let currentTouchPosition = touch?.location(in: self.clUsers)
        var indexPath = self.clUsers.indexPathForItem(at: currentTouchPosition!)!
    }
    
    func mediaPickerController(_ controller: IQMediaPickerController, didFinishMediaWithInfo info: [AnyHashable : Any]) {
        
        print("Info: \(info)")
        
        mediaInfo = info as NSDictionary!
//        mediaInfo = info.copy()
        
        let key = mediaInfo.allKeys[0] as? String
        let arrtemp = mediaInfo[key!] as? NSArray
        let dictemp = arrtemp![0] as! NSDictionary
        let url = dictemp[IQMediaURL] as? URL
        // define the block to call when we get the asset based on the url (below)

        if (url?.absoluteString.contains(".jpg"))!
        {
            do {
                self.videoData = try Data(contentsOf: url!)
                self.imgtaken.backgroundColor = UIColor.clear
                self.imgtaken.image = UIImage(data: self.videoData)
                self.btnDeletePhoto.isHidden = false
                self.btnTakePhoto.isHidden = true
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        else
        {
            let uploadUrl = NSURL.fileURL(withPath: NSTemporaryDirectory().appending("\(NSDate())").appending(".mov"))
            self.compressVideo(inputURL: url! as NSURL, outputURL: uploadUrl as NSURL, handler: { (handler) -> Void in
                
                if handler.status == AVAssetExportSessionStatus.completed
                {
                    do {
                        self.videoData = try Data(contentsOf: uploadUrl)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                else if handler.status == AVAssetExportSessionStatus.failed
                {
                    App_showAlert(withMessage: "There was a problem compressing the video maybe you can try again later. Error: \(handler.error?.localizedDescription ?? "")", inView: self)
                }
            })

        }
    }
    
    func mediaPickerControllerDidCancel(_ controller: IQMediaPickerController) {
        

    }
    
    @IBAction func deletePhoto(_ sender: UIButton)
    {
        self.imgtaken.backgroundColor = UIColor.cameraBGCOLOR()
        self.imgtaken.image = nil
        self.btnDeletePhoto.isHidden = true
        self.btnTakePhoto.isHidden = false
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Custom Overlay View methods
    @IBAction func selectphoto(_ sender: UIButton)
    {
      /*  switch sender.tag
        {
        case 1:  //Gallery
                picker = UIImagePickerController() //make a clean controller
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                picker.cameraCaptureMode = .photo
                picker.showsCameraControls = false
                //picker.delegate = self  //uncomment if you want to take multiple pictures.
            
                //presentation of the camera
                picker.modalPresentationStyle = .fullScreen
                present(picker,
                                      animated: true,
                                      completion: {
                                        self.vwCustomOverlay.isHidden = false
                                        self.picker.cameraOverlayView = self.vwCustomOverlay
                })
            break
        case 2: //Photo
            picker = UIImagePickerController() //make a clean controller
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.showsCameraControls = false
            //picker.delegate = self  //uncomment if you want to take multiple pictures.
            
            //presentation of the camera
            picker.modalPresentationStyle = .fullScreen
            present(picker,
                    animated: true,
                    completion: {
                        self.vwCustomOverlay.isHidden = false
                        self.picker.cameraOverlayView = self.vwCustomOverlay
            })
            break
        case 3: // Video
            picker = UIImagePickerController() //make a clean controller
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .video
            picker.showsCameraControls = false
            //picker.delegate = self  //uncomment if you want to take multiple pictures.
            
            //presentation of the camera
            picker.modalPresentationStyle = .fullScreen
            present(picker,
                    animated: true,
                    completion: {
                        self.vwCustomOverlay.isHidden = false
                        self.picker.cameraOverlayView = self.vwCustomOverlay
            })
            break
        default:
            break
        }*/
    }

    @IBAction func didCancel(_ sender: UIButton)
    {
        picker.dismiss(animated: true,completion: nil)
        print("dismissed!!")
    }
    @IBAction func didShoot(_ sender: UIButton)
    {
        picker.takePicture()
        print("Shot Photo")
    }
    //MARK: Image Picker Controller Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let mType: String? = (info[UIImagePickerControllerMediaType] as? String)
        
        if (mType! == kUTTypeMovie as String)
        {
            let selectedVideoURL: URL? = (info["UIImagePickerControllerMediaURL"] as? URL)
            let uploadUrl = NSURL.fileURL(withPath: NSTemporaryDirectory().appending("\(NSDate())").appending(".mov"))
            self.compressVideo(inputURL: selectedVideoURL! as NSURL, outputURL: uploadUrl as NSURL, handler: { (handler) -> Void in
                
                if handler.status == AVAssetExportSessionStatus.completed
                {
                    do {
                        self.videoData = try Data(contentsOf: uploadUrl)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                else if handler.status == AVAssetExportSessionStatus.failed
                {
                    App_showAlert(withMessage: "There was a problem compressing the video maybe you can try again later. Error: \(handler.error?.localizedDescription ?? "")", inView: self)
                }
            })
            
            /*  do {
             videoData = try Data(contentsOf: selectedVideoURL!)
             // do something with data
             // if the call fails, the catch block is executed
             } catch {
             print(error.localizedDescription)
             }*/
        }
        else
        {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                self.imgtaken.image = image
                self.imgtaken.backgroundColor = UIColor.clear
                self.btnDeletePhoto.isHidden = false
                self.btnTakePhoto.isHidden = true
            }
            else
            {
                print("Something went wrong")
            }
        }
        self.dismiss(animated:true, completion: nil)
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true,completion: nil)
        print("Canceled!!")
    }
    func openonlyGallery()
    {
        self.picker.mediaTypes = ["public.image", "public.movie"]
        self.picker.sourceType = .savedPhotosAlbum
        self.picker.allowsEditing = false
        self.picker.videoMaximumDuration = 60.0
        self.present(self.picker, animated: true, completion: nil)
    }
    func compressVideo(inputURL: NSURL, outputURL: NSURL, handler:@escaping (_ session: AVAssetExportSession)-> Void)
    {
        let urlAsset = AVURLAsset(url: inputURL as URL, options: nil)
        
        let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality)
        exportSession?.outputURL = outputURL as URL
        exportSession?.outputFileType = AVFileType.mov
        exportSession?.shouldOptimizeForNetworkUse = true
        exportSession?.exportAsynchronously { () -> Void in
            handler(exportSession!)
        }
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
extension CreatPostVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "CreatPostUserCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! CreatPostUserCell
        cell.btnSelectUser.tag = indexPath.row
        cell.btnSelectUser.addTarget(self, action: #selector(CreatPostVC.selectUsertoSpot(_:event:)), for: .touchUpInside)
        return cell
    }
}
// MARK:- UICollectionViewDelegate Methods
extension CreatPostVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    }
}
