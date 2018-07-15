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
import AVKit


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
    @IBOutlet weak var ctHeightofScrollView : NSLayoutConstraint!
    @IBOutlet weak var btnPlayVideoTaken : UIButton!
    var strVideoLink = NSURL()
    var arrUsersConnections = NSMutableArray()
    var arrSelectedUsers = NSMutableArray()
    var iSelectedUserID = String()

    //Custom Overlay for Camera
    @IBOutlet var overlayView: UIView?
    @IBOutlet weak var btnGallery : UIButton!
    @IBOutlet weak var btnCamera : UIButton!
    @IBOutlet weak var btnVideo : UIButton!
    var balreadyPresentedOverlay : Bool = false
    @IBOutlet var buttonCapture : DBCameraButton!
    var bSessionRunning : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.picker.delegate = self
        
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)

        self.ctHeightofScrollView.constant = MainScreen.height - (topBarHeight + 20)
        self.arrUsersConnections = NSMutableArray()
        self.arrSelectedUsers = NSMutableArray()
        
        showProgress(inView: self.view)
        self.GetUserConnectionsData()
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
    
    
    
    //MARK: Call to get User Connections
    func GetUserConnectionsData()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let url = kServerURL + "connections"
        let token = final .value(forKey: "token")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        self.arrUsersConnections = NSMutableArray()
        
        request(url, method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value!)
                    
                    if let json = response.result.value
                    {
                        let dictemp = json as! NSDictionary
                        print("dictemp :> \(dictemp)")
                        
                        if let temp = dictemp.value(forKey: "error") as? NSDictionary
                        {
                            let msg = (temp.value(forKey: "message"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            self.arrUsersConnections = NSMutableArray(array: dictemp.value(forKey: "data") as! NSArray)
                            for _ in 0..<self.arrUsersConnections.count
                            {
                                self.arrSelection.add(kNO)
                            }
                        }
                        self.clUsers.reloadData()
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                self.clUsers.reloadData()
                break
            }
        }
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
        self.btnPlayVideoTaken.isHidden = true
        self.videoData = Data()
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
        self.balreadyPresentedOverlay = false
        let mType: String? = (info[UIImagePickerControllerMediaType] as? String)
        
        if (mType! == kUTTypeMovie as String)
        {
            let selectedVideoURL: URL? = (info["UIImagePickerControllerMediaURL"] as? URL)
            let uploadUrl = NSURL.fileURL(withPath: NSTemporaryDirectory().appending("\(NSDate())").appending(".mov"))
            
            if let videoimag = self.getThumbnailFrom(path: selectedVideoURL!)
            {
                self.imgtaken.image = videoimag
                self.imgtaken.backgroundColor = UIColor.clear
                self.btnDeletePhoto.isHidden = false
                self.btnTakePhoto.isHidden = true
                self.btnPlayVideoTaken.isHidden = false
            }

            
            self.compressVideo(inputURL: selectedVideoURL! as NSURL, outputURL: uploadUrl as NSURL, handler: { (handler) -> Void in
                
                if handler.status == AVAssetExportSessionStatus.completed
                {
                    do {
                        self.strVideoLink = uploadUrl as NSURL
                        self.videoData = try Data(contentsOf: uploadUrl)
                        self.btnPlayVideoTaken.isHidden = false
                        self.isVideoUploaded = true
                        self.isImageUploaded = false
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
                self.btnPlayVideoTaken.isHidden = true
                self.isVideoUploaded = false
                self.isImageUploaded = true
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
        self.balreadyPresentedOverlay = false
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
    func getThumbnailFrom(path: URL) -> UIImage?
    {
        do
        {
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        }
        catch let error
        {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    // MARK: - CustomOverlay Camera Picker
    @IBAction func btnCameraCustomAction()
    {
        btnGallery.isSelected = false
        btnCamera.isSelected = true
        btnVideo.isSelected = false
        buttonCapture.circleColor = UIColor.white
        buttonCapture.squareColor = UIColor.white
        buttonCapture.isRecording = false
        self.picker.mediaTypes = [kUTTypeImage as String]

        if self.balreadyPresentedOverlay == true
        {
            
        }
        else
        {
            self.picker.modalPresentationStyle = .currentContext
            self.picker.sourceType = UIImagePickerControllerSourceType.camera
            self.picker.modalPresentationStyle =
                (self.picker.sourceType == UIImagePickerControllerSourceType.camera) ?
                    UIModalPresentationStyle.fullScreen : UIModalPresentationStyle.popover
            
            //        self.picker.mediaTypes = [kUTTypeImage as NSString as String]
            
            let presentationController = self.picker.popoverPresentationController
            presentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
            
            // The user wants to use the camera interface. Set up our custom overlay view for the camera.
            self.picker.showsCameraControls = false
            
            // Apply our overlay view containing the toolar to take pictures in various ways.
            overlayView?.frame = (self.picker.cameraOverlayView?.frame)!
            self.picker.cameraOverlayView = overlayView
            
            present(self.picker, animated: true, completion: {
                // Done presenting.
                self.balreadyPresentedOverlay = true
            })
        }
    }
    
    @IBAction func btnGalleryAction()
    {
        if self.balreadyPresentedOverlay == true
        {
            dismiss(animated: true, completion:nil)
        }
        btnGallery.isSelected = true
        btnCamera.isSelected = false
        btnVideo.isSelected = false
        
        self.picker.mediaTypes = ["public.image", "public.movie"]
        self.picker.allowsEditing = false
        self.picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        let presentationController = self.picker.popoverPresentationController
        presentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        
        present(self.picker, animated: true, completion:
            {
                self.balreadyPresentedOverlay = false
        })

    }
    @IBAction func btnVideoAction()
    {
        btnGallery.isSelected = false
        btnCamera.isSelected = false
        btnVideo.isSelected = true
        buttonCapture.circleColor = UIColor.red
        buttonCapture.squareColor = UIColor.red
        bSessionRunning = false
        self.picker.mediaTypes = [kUTTypeMovie as String]
        self.picker.videoMaximumDuration = 20

        if self.balreadyPresentedOverlay == true
        {
        }
        else
        {
            self.picker.modalPresentationStyle = .currentContext
            self.picker.sourceType = UIImagePickerControllerSourceType.camera
            self.picker.modalPresentationStyle =
                (self.picker.sourceType == UIImagePickerControllerSourceType.camera) ?
                    UIModalPresentationStyle.fullScreen : UIModalPresentationStyle.popover
            
            let presentationController = self.picker.popoverPresentationController
            presentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
            
            // The user wants to use the camera interface. Set up our custom overlay view for the camera.
            self.picker.showsCameraControls = false
            
            // Apply our overlay view containing the toolar to take pictures in various ways.
            overlayView?.frame = (self.picker.cameraOverlayView?.frame)!
            self.picker.cameraOverlayView = overlayView
            
            present(self.picker, animated: true, completion: {
                // Done presenting.
                self.balreadyPresentedOverlay = true
            })
        }
    }

    //  Converted to Swift 4 by Swiftify v4.1.6738 - https://objectivec2swift.com/
    @IBAction func captureAction(_ sender: UIButton?)
    {
        self.buttonCapture.isEnabled = true
        
        if btnCamera.isSelected == true
        {
            self.picker.takePicture()
        }
        else
        {
            if bSessionRunning == false
            {
                bSessionRunning = true
                self.picker.startVideoCapture()
            }
            else
            {
                self.picker.stopVideoCapture()
                dismiss(animated: true, completion:nil)
                bSessionRunning = false
            }
        }
    }

    @IBAction func btnFrontRearCameraACtion()
    {
        if self.picker.cameraDevice == .front
        {
            self.picker.cameraDevice = .rear
        }
        else
        {
            self.picker.cameraDevice = .front
        }
    }
    @IBAction func btnTourchAction()
    {
        if self.picker.cameraFlashMode == .on
        {
            self.picker.cameraFlashMode = .off
        }
        else
        {
            self.picker.cameraFlashMode = .on
        }
    }

    @IBAction func btnPhotoAction()
    {
        
    }

    @IBAction func btnPlayVidoAction()
    {
        let player = AVPlayer(url: strVideoLink as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    //MARK: Call to Create Post action
    @IBAction func btnPostAction()
    {
        if (self.txtvwDescription.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter post description", inView: self)
        }
        else if (iSelectedUserID.count == 0)
        {
            App_showAlert(withMessage: "Please select connection", inView: self)
        }
        
        else
        {
            self.view .endEditing(true)
            showProgress(inView: self.view)
            self.calltoCreatPost()
        }
    }
    
    func calltoCreatPost()
    {
        var strVideoattached = "0"
        var strImageattached = "0"
        if isVideoUploaded == true
        {
            strVideoattached = "1"
        }
        else if isImageUploaded == true
        {
            strImageattached = "1"
        }
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let token = final .value(forKey: "token")
        let headers = ["Authorization":"Bearer \(token!)"]

        let parameters = [
            "tag_user_id": "\(iSelectedUserID)",
            "description": "\(txtvwDescription.text!)",
            "is_video":"\(strVideoattached)",
            "is_image" : "\(strImageattached)"
        ]
        let url = kServerURL + "posts/create"
        
        upload(multipartFormData:
            { (multipartFormData) in
                
                if self.isVideoUploaded == true
                {
                    multipartFormData.append(self.videoData, withName: "media", fileName: "video.mp4", mimeType: "video/quicktime")
                 
                    if let imageData2 = UIImageJPEGRepresentation(self.imgtaken.image!, 1)
                    {
                        multipartFormData.append(imageData2, withName: "thumbnail", fileName: "media.png", mimeType: "image/jpeg")
                    }
                }
                else
                {
                    if let imageData2 = UIImageJPEGRepresentation(self.imgtaken.image!, 1)
                    {
                        multipartFormData.append(imageData2, withName: "media", fileName: "media.png", mimeType: "image/jpeg")
                    }
                }
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
        }, to: url, method: .post, headers: headers, encodingCompletion:
            {
                (result) in
                switch result
                {
                case .success(let upload, _, _):
                    upload.responseJSON
                        {
                            response in
                            hideProgress()
                            debugPrint(response)
                            
                            if let json = response.result.value
                            {
                                print("json :> \(json)")
                                let dictemp = json as! NSDictionary
                                print("dictemp :> \(dictemp)")
                                if dictemp.count > 0
                                {
                                    let alertView = UIAlertController(title: Application_Name, message: dictemp[kkeymessage]! as? String, preferredStyle: .alert)
                                    let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                                        self.backButtonPressed()
                                    }
                                    alertView.addAction(OKAction)
                                    self.present(alertView, animated: true, completion: nil)
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
        return self.arrUsersConnections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "CreatPostUserCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! CreatPostUserCell
//        cell.btnSelectUser.tag = indexPath.row
////        cell.btnSelectUser.addTarget(self, action: #selector(CreatPostVC.selectUsertoSpot(_:event:)), for: .touchUpInside)
        let dicdata = self.arrUsersConnections[indexPath.row] as! NSDictionary
        cell.imgUserProfile.layer.masksToBounds = true

        if let imgUserPic = dicdata.value(forKey: "profile_pic") as? String
        {
            let url2 = URL(string: imgUserPic)
            if url2 != nil {
                cell.imgUserProfile.sd_setImage(with: url2, placeholderImage: UIImage(named: "profile_pic_test"))
            }
        }
        cell.lblUserName.text = "\(dicdata.value(forKey: "name")!)"

        
        if (arrSelection[indexPath.row] as! String == kYES)
        {
            cell.imgUserSelected.isHidden = false
        }
        else
        {
            cell.imgUserSelected.isHidden = true
        }
        
        cell.imgUserProfile.backgroundColor = UIColor.clear
        
        return cell
    }
}
// MARK:- UICollectionViewDelegate Methods
extension CreatPostVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let dicdata = self.arrUsersConnections[indexPath.row] as! NSDictionary
        if (arrSelection[indexPath.row] as! String == kYES)
        {
            self.arrSelection.replaceObject(at: indexPath.row, with: kNO)
            self.iSelectedUserID = ""
        }
        else
        {
            self.arrSelection = NSMutableArray()
            for _ in 0..<self.arrUsersConnections.count
            {
                self.arrSelection.add(kNO)
            }
            self.arrSelection.replaceObject(at: indexPath.row, with: kYES)
            self.iSelectedUserID = "\(dicdata.value(forKey: "user_id")!)"
        }
        clUsers.reloadData()
    }
}
