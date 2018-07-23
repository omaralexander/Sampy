//
//  makeAPostImage.swift
//  Sampy
//
//  Created by Omar Abbas on 8/18/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

import NVActivityIndicatorView


class makeAPostViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
  
    
    @IBOutlet weak var makeAPostImage: UIImageView!
   
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBOutlet var noCameraAccessView: UIView!
    
    @IBOutlet weak var noCameraAccessSettings: UIButton!
    
    @IBOutlet weak var closeNoCameraView: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var retakePhoto: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBAction func unwindToPostImage(segue:UIStoryboardSegue){
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return statusBarShouldBeHidden
    }
    
    var effect: UIVisualEffect!
 
    var tag = Int()
  
    var shouldShowCamera = true
    var theSelectedCatagory = String()
    var descriptionString = String()
    var statusBarShouldBeHidden = Bool()
    var containerViewShouldBeHidden = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagToOpenCamera(number: 0)
    }
   

    override func viewDidAppear(_ animated: Bool) {
      
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.child("profileImageUrl").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() == false {
                let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
                let bc: UIViewController = storyboard.instantiateViewController(withIdentifier: "appStartViewController")
                self.present(bc, animated: true, completion: nil)
                
                
            } else {
                
                self.tagToOpenCamera(number: self.tag)
              
            }
        })

    }
    override func viewWillAppear(_ animated: Bool) {
        let viewController = self.parent as? tabBarViewController
        viewController?.statusBarShouldBeHidden = true
        viewController?.setNeedsStatusBarAppearanceUpdate()
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        tag = 0

    }
    override func viewWillDisappear(_ animated: Bool) {
        let viewController = self.parent as? tabBarViewController
        viewController?.statusBarShouldBeHidden = false
        viewController?.setNeedsStatusBarAppearanceUpdate()
    }

    func openCamera(){
        
        let cameraMediaType = AVMediaTypeVideo
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: cameraMediaType)
    
        switch cameraAuthorizationStatus {
        case .denied:
    
            print("it is denied")
        
            self.noCameraAccessView.layer.cornerRadius = 14
            effect = visualEffectView.effect
            
            visualEffectView.effect = nil
            
            self.noCameraAccessSettings.layer.cornerRadius = 5
            
            
            self.noCameraAccessSettings.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
            self.closeNoCameraView.addTarget(self, action: #selector(noCameraAccessAnimateOut), for: .touchUpInside)
            
            
            self.noCameraAccessAnimateIn()
            break
        case .authorized:
            print("it is authorized")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                DispatchQueue.main.async(execute: {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = true //originally is set as false
                self.present(imagePicker, animated: true, completion: nil)
                
            })
        }
            break
        case .restricted:
            print("it is restricted")
            
            self.noCameraAccessView.layer.cornerRadius = 14
            
            effect = visualEffectView.effect
            
            visualEffectView.effect = nil
            
            self.noCameraAccessSettings.layer.cornerRadius = 5
            
            
            self.noCameraAccessSettings.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
            self.closeNoCameraView.addTarget(self, action: #selector(noCameraAccessAnimateOut), for: .touchUpInside)
            
        
            self.noCameraAccessAnimateIn()
            break
            
        case .notDetermined:
            print("not determined we got a sich ")
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(forMediaType: cameraMediaType) { granted in
                if granted {
                    print("Granted access to \(cameraMediaType)")
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                        DispatchQueue.main.async(execute: {
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = self
                        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                        imagePicker.allowsEditing = true //originally is set as false
                        self.present(imagePicker, animated: true, completion: nil)
                    })
                    
                } else {
                    print("Denied access to \(cameraMediaType)")
                }
            }
        }
    }
}
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            makeAPostImage.image = selectedImage
            tag = 1
            tagToOpenCamera(number: 1)
         
            dismiss(animated:true, completion: nil)
            
            self.loadTheView()
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        tag = 2
        tagToOpenCamera(number: 2)
        
        self.loadTheView()
        dismiss(animated: true, completion: nil)
        }
    func unHideContainerView(){
        self.containerView.isHidden = false
    }

    func noCameraAccessAnimateIn(){
        self.view.addSubview(noCameraAccessView)
        noCameraAccessView.center = self.view.center
        noCameraAccessView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        noCameraAccessView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.noCameraAccessView.alpha = 1
            self.noCameraAccessView.transform = CGAffineTransform.identity
        }
    }
    
    func noCameraAccessAnimateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.noCameraAccessView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.noCameraAccessView.alpha = 0
            self.visualEffectView.effect = nil
            
        }){(success:Bool) in
            self.loadTheView()
            self.noCameraAccessView.removeFromSuperview()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDescription"{
            let viewController = segue.destination as! descriptionForPosting
            viewController.imagePassedOver = makeAPostImage.image
            viewController.theSelectedCategory = theSelectedCatagory
            viewController.passedOverDescription = descriptionString
        }
    }

    func goToSettings(){
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    func tagToOpenCamera(number: Int){
        if shouldShowCamera == true{
        switch tag {
        case 0:
            openCamera()
        break
        case 1:
        
          tag = 1
            break
        case 2:
           
        tag = 2
            break
        default:
            print("do nothing")
            
        }
    }
}

    func goToNextView(){
        if makeAPostImage.image != UIImage(named: "takeAPhoto"){
        alertLabel.isHidden = true
        performSegue(withIdentifier: "goToDescription", sender: self)
        } else{
        alertLabel.isHidden = false
        }
}

    func loadTheView(){
        self.containerView.isHidden = true
        self.statusBarShouldBeHidden = true
   
        
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 480:
                print("iPhone Classic")
            case 960:
                print("iPhone 4 or 4S")
            case 1136:
                print("iPhone 5 or 5S or 5c")
            case 1334:
                print("iPhone 6 or 6s")
            case 2208:
                print("iPhone 6+ or 6S+")
            case 2436:
                print("it is the iPhone X")
 
                nextButton.frame.origin.y = 40
               
                self.statusBarShouldBeHidden = false
                setNeedsStatusBarAppearanceUpdate()
                
            default:
                print("unknown")
            }
        }
            effect = visualEffectView.effect
            
            visualEffectView.effect = nil
            alertLabel.isHidden = true
            nextButton.layer.cornerRadius = 5
            nextButton.addTarget(self, action: #selector(goToNextView), for: .touchUpInside)


            self.makeAPostImage.contentMode = .scaleAspectFit
            self.makeAPostImage.layer.cornerRadius = 5
        
            self.noCameraAccessSettings.titleLabel?.adjustsFontSizeToFitWidth = true
        
            self.noCameraAccessSettings.layer.cornerRadius = 5

            self.noCameraAccessSettings.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
            self.closeNoCameraView.addTarget(self, action: #selector(noCameraAccessAnimateOut), for: .touchUpInside)
        
            self.retakePhoto.addTarget(self, action: #selector(self.openCamera), for: .touchUpInside)
        
    }
    func testSegue(){
        let viewController = self.parent as? tabBarViewController
        
        viewController?.goToADifferentFeed()
    }
}
