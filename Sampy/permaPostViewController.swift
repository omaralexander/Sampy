//
//  permaPostViewController.swift
//  Sampy
//
//  Created by Omar Abbas on 7/16/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase

class permaPostViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imagePost: UIImageView!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet var progressView: UIView!
    
    @IBOutlet weak var addPhotolabel: UILabel!
   
    @IBOutlet weak var backButtonImage: UIButton!
    @IBOutlet weak var creditAmountLabel: UILabel!
    
    @IBOutlet weak var alertLabel: UILabel!
 
    @IBOutlet weak var closeCreditView: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    override var prefersStatusBarHidden: Bool{
        return statusBarShouldBeHidden
    }
    @IBAction func backToUploadAPic(segue:UIStoryboardSegue){
        
    }
    
    var effect: UIVisualEffect!
    var greenColor = UIColor(red: 52/255, green: 178/255, blue: 187/255, alpha: 1)
    
    var passedImage: UIImage!
    var passedName = String()
    var passedWebLink = String()
    var passedCategory = String()
    var passedAddress = String()
    var passedLat = String()
    var passedLong = String()
    var passedDescription = String()
    
    var statusBarShouldBeHidden = Bool()
    
    
    override func viewDidLoad() {
        self.statusBarShouldBeHidden = true
        
        super.viewDidLoad()
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
                backButtonImage.frame.origin.y = 50
                dismissButton.frame.origin.y = 38
                self.statusBarShouldBeHidden = false
                setNeedsStatusBarAppearanceUpdate()
                
            default:
                print("unknown")
            }
        }
      
        
        self.effect = self.visualEffectView.effect
        self.visualEffectView.effect = nil
        
        
        
        self.nextButton.layer.cornerRadius = 5
        self.progressView.layer.cornerRadius = 14
        closeCreditView.layer.cornerRadius = 5
        getCreditAmount()
        imagePost.layer.cornerRadius = 5
        
        addPhotolabel.layer.cornerRadius = 5
        addPhotolabel.layer.borderColor = greenColor.cgColor
        addPhotolabel.layer.borderWidth = 2
        
        
        alertLabel.isHidden = true
        
        imagePost.clipsToBounds = true
        imagePost.contentMode = .scaleAspectFit
        imagePost.image = UIImage(named: "noImageInHere")
        
        nextButton.addTarget(self, action: #selector(nextButtonFunction), for: .touchUpInside)
        imagePost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        closeCreditView.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        animateIn()
        
   
    }
    func getCreditAmount(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let dictionary = snapshot.value as! [String: AnyObject]
            let creditAmount = dictionary["postCredit"] as! NSNumber
            
             self.creditAmountLabel.text = "You have \(creditAmount) credits left. Your 5 credits are refreshed every Friday at 5 PM ET."
            
            if creditAmount == 0 {
                self.nextButton.isUserInteractionEnabled = false
                self.nextButton.backgroundColor = UIColor.lightGray
            } else {
                self.nextButton.isUserInteractionEnabled = true
                self.nextButton.backgroundColor = self.greenColor
            }
        })
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
                self.getCreditAmount()
            }
        })
    }

    func nextButtonFunction(){
        if imagePost.image != UIImage(named: "noImageInHere") {
            alertLabel.isHidden = true
    performSegue(withIdentifier: "moveToName", sender: self)
        } else {
            alertLabel.isHidden = false
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToName"{
            let viewController = segue.destination as! postName
            viewController.passedImage = imagePost.image
            viewController.passedName = passedName
            viewController.passedWebLink = passedWebLink
            viewController.passedCategory = passedCategory
            viewController.passedAddress = passedAddress
            viewController.passedLat = passedLat
            viewController.passedLong = passedLong
            viewController.passedDescription = passedDescription
            
        }
    }
    func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion:nil)
    }
    func imagePickerController(_ picker: UIImagePickerController,  didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker:UIImage?
        
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as?  UIImage{
            selectedImageFromPicker = editedImage
            
        }else if let originalImage =  info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
            
        }
        if let selectedImage = selectedImageFromPicker {
            imagePost.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }

   
    func animateIn(){
        self.view.addSubview(progressView)
        
        progressView.center = self.view.center
        progressView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        progressView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.progressView.alpha = 1
            self.progressView.transform = CGAffineTransform.identity
        }
        
    }
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.progressView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.progressView.alpha = 0
            self.visualEffectView.effect = nil
            
        }){(success:Bool) in
            self.progressView.removeFromSuperview()
       
        }

    }
}
