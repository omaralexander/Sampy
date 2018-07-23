//
//  slideOutMenuViewController.swift
//  Sampy
//
//  Created by Omar Abbas on 5/28/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class slideOutMenuViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var userProfilePicture: UIImageView!
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var dismissButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.child("profileImageUrl").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() == false  {
                let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
                let bc: UIViewController = storyboard.instantiateViewController(withIdentifier: "appStartViewController")
                self.present(bc, animated: true, completion: nil)
          

            }
        })
    

        logOutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        if self.revealViewController() != nil {
            dismissButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.userProfilePicture.clipsToBounds = true
        self.userProfilePicture.contentMode = .scaleToFill
        self.userProfilePicture.layer.cornerRadius = userProfilePicture.frame.size.height / 2;
        self.userProfilePicture.layer.cornerRadius = userProfilePicture.frame.size.width / 2;
        
        self.userProfilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        
            ref.observe(.value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
            self.userProfilePicture.loadImageUsingCachWithUrlString(urlString: dictionary["profileImageUrl"] as! String, activityIndicator: self.activityIndicator)
            self.userName.text = dictionary["username"] as? String
                
            }

        }, withCancel: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.child("profileImageUrl").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() == false  {
                let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
                let bc: UIViewController = storyboard.instantiateViewController(withIdentifier: "appStartViewController")
                self.present(bc, animated: true, completion: nil)
       
                
            }
        })
        
    }
    func logout(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        performSegue(withIdentifier: "logOutSegue", sender: self)
    }
    func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController,  didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker:UIImage?
        
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as?  UIImage{
            selectedImageFromPicker = editedImage
            
        }else if let originalImage =  info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
            
        }
        if let selectedImage = selectedImageFromPicker {
            userProfilePicture.image = selectedImage
            updateProfileImageInFirebase(image: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    func updateProfileImageInFirebase(image: UIImage){
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else{
            return
        }
        if user != nil {
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("Profile_Images").child("\(imageName).jpg")
            if let uploadData = UIImagePNGRepresentation(image){
                storageRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
                    if error != nil{
                        print(error?.localizedDescription as Any)
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                        self.removeImageFromStorage()
                        Database.database().reference().child("Users").child(uid).updateChildValues(["profileImageUrl":profileImageUrl])
                        
                    
                    
                    
                    }
                })
            }
        }
    }
    func removeImageFromStorage(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            let dictionary = snapshot.value as? [String:AnyObject]
            let currentProfileImage = dictionary?["profileImageUrl"] as! String
        
            if currentProfileImage != "https://firebasestorage.googleapis.com/v0/b/sampy-bc84f.appspot.com/o/noProfilePicture.png?alt=media&token=f8b5b663-1fac-4007-80d2-e2637ad61261" {
        let removeProfileImageRef = Storage.storage().reference(forURL: currentProfileImage)
            removeProfileImageRef.delete(completion: {(error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                    }
                })
            }
        })
    }
}
