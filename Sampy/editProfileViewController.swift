//
//  editProfileViewController.swift
//  Sampy
//
//  Created by Omar Abbas on 5/28/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import  UIKit
import Firebase
import GooglePlaces
import BEMCheckBox
import NVActivityIndicatorView

class editProfileViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate,GMSAutocompleteViewControllerDelegate,BEMCheckBoxDelegate {
    


    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var currentProfilePicture: UIImageView!
  
    @IBOutlet weak var currentUserName: UITextField!
    
    
    @IBOutlet weak var currentUserEmail: UITextField!
    
    @IBOutlet weak var changeCurrentPhoto: UIImageView!
    
    @IBOutlet weak var mainScroll: UIScrollView!
    
    @IBOutlet weak var buttonForCity: UIButton!
    
    @IBOutlet weak var userCity: UILabel!
    @IBOutlet weak var backButtonImage: UIButton!
    @IBOutlet weak var editButton: UILabel!
    @IBOutlet weak var aboutMe: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveNewUsername: UIButton!
    @IBOutlet var sucessUsername: UIView!
 
   
    @IBOutlet weak var dismissSuccessView: UIButton!
    @IBOutlet weak var checkBox: BEMCheckBox!

    @IBOutlet var errorUploadingPhotoView: UIView!
    @IBOutlet weak var closeErrorUploadingView: UIButton!

    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBAction func usernameEditingbegan(_ sender: UITextField) {
        
        
    }
    @IBAction func usernamePressed(_ sender: UITextField) {
      
    }
    
    
    var keyboardHeight = CGFloat()
    var greenColor = UIColor(red: 210/255, green: 224/255, blue: 195/255, alpha: 1)
    var redColor = UIColor(red: 139/255, green: 49/255, blue: 56/255, alpha: 1)
    var currentUsersName = String()
    
    
    var effect: UIVisualEffect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.child("profileImageUrl").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() == false {
                let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
                let bc: UIViewController = storyboard.instantiateViewController(withIdentifier: "appStartViewController")
                self.present(bc, animated: true, completion: nil)
                
                
            }
        })
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        checkBox.delegate = self
        
         checkBox.isSelected = true
        checkBox.onAnimationType = .oneStroke
   
        sucessUsername.layer.cornerRadius = 14
        sucessUsername.layer.shadowColor = UIColor.black.cgColor
        sucessUsername.layer.shadowOffset = CGSize(width: 3, height: 3)
        sucessUsername.layer.shadowOpacity = 0.3
        sucessUsername.layer.shadowRadius = 4

        mainScroll.keyboardDismissMode = .onDrag
        
        saveButton.layer.cornerRadius = 5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        setupKeyboardObservers()

        self.automaticallyAdjustsScrollViewInsets = false
        
        mainScroll.contentSize.height = aboutMe.frame.origin.y + aboutMe.frame.height * 2
        mainScroll.delegate = self
        
        aboutMe.delegate = self
        currentUserEmail.delegate = self
        
        dismissSuccessView.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        
        changeCurrentPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
       
        saveButton.addTarget(self, action: #selector(saveUpdatedFields), for: .touchUpInside)
        saveNewUsername.addTarget(self, action: #selector(usernameCheck), for: .touchUpInside)
        
        buttonForCity.addTarget(self, action: #selector(performSegueToGoogleSearch), for: .touchUpInside)
        currentProfilePicture.clipsToBounds = true
        currentProfilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        closeErrorUploadingView.addTarget(self, action: #selector(animateErrorOut), for: .touchUpInside)
        
        saveNewUsername.layer.cornerRadius = 5
        
        errorUploadingPhotoView.layer.cornerRadius = 14
        
        closeErrorUploadingView.layer.cornerRadius = 5
        
        closeErrorUploadingView.titleLabel?.adjustsFontSizeToFitWidth = true
        
        errorUploadingPhotoView.frame = CGRect(x: errorUploadingPhotoView.frame.origin.x, y: errorUploadingPhotoView.frame.origin.y, width: UIScreen.main.bounds.width - 15, height: errorUploadingPhotoView.frame.height)
     
       
        currentProfilePicture.contentMode = .scaleAspectFill
       
        
        currentUserEmail.adjustsFontSizeToFitWidth = true
        currentUserEmail.minimumFontSize = 5
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 2436:
               saveButton.frame.origin.y = 41
                editButton.frame.origin.y = 45
                backButtonImage.frame.origin.y = 45
                dismissButton.frame.origin.y = 45
            default:
                print("unknown")
            }
        }
        ref.observe(.value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
            self.currentUserName.text = dictionary["username"] as? String
            self.currentUserEmail.text = dictionary["email"] as? String
            self.aboutMe.text = dictionary["aboutMe"] as? String
            self.currentProfilePicture.loadImageUsingCachWithUrlString(urlString: dictionary["profileImageUrl"] as! String, activityIndicator: self.activityIndicator)
            self.userCity.text = dictionary["userCity"] as? String
            self.currentUsersName = (dictionary["username"] as? String)!
            }
            
        }, withCancel: nil)
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
                
                
            }
        })
    }
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func handleKeyboardWillHide(notification:NSNotification){
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: keyboardDuration, animations: {self.view.layoutIfNeeded()
            
        })
    }
    
    func handleKeyboardWillShow(notification:NSNotification){
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        keyboardHeight = (keyboardFrame?.height)!
        
        UIView.animate(withDuration: keyboardDuration, animations: {self.view.layoutIfNeeded()
        })
    }

    func hideKeyboard() {
        view.endEditing(true)
    }

    func usernameCheck(){

        getUsersLastUsernameUsed()
        let ref = Database.database().reference().child("Usernames").child("username")
        ref.queryOrdered(byChild: "username").queryEqual(toValue: self.currentUserName.text).observeSingleEvent(of: .value, with: {(snapshot) in
 
            if (snapshot.childrenCount == 0) || snapshot.exists() == false{
                self.deleteUsername()
                self.saveUsername()
            }else{
                self.currentUserName.backgroundColor = self.redColor
                self.currentUserName.tintColor = UIColor.white
                self.currentUserName.textColor = UIColor.white
            }
        })
    }
    func deleteUsername(){
         let usernameRemoveRef = Database.database().reference().child("Usernames").child("username")
        usernameRemoveRef.queryOrdered(byChild: "username").queryEqual(toValue: self.currentUsersName).observeSingleEvent(of: .childAdded, with: {(snapshot) in
            
            snapshot.ref.removeValue(completionBlock: {(error,ref) in
                if error != nil{
                    print("This is the error\(error?.localizedDescription as Any)")
                }
            })
        })
    }
    func saveUsername(){
        let usernameRef = Database.database().reference().child("Usernames").child("username").childByAutoId()
        let usernameValues = ["username":self.currentUserName.text as Any] as [String:Any]
        
        usernameRef.updateChildValues(usernameValues, withCompletionBlock: {(err,ref) in
            if err != nil{
                print("This was the error in uploading the new username\(err?.localizedDescription as Any)")
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else{
                return
            }
            let ref = Database.database().reference().child("Users").child(uid)
            ref.updateChildValues(usernameValues)
        })
        self.view.endEditing(true)
        self.animateIn()

    }
    func getUsersLastUsernameUsed(){
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let ref = Database.database().reference().child("Users").child(uid)
        ref.observeSingleEvent(of: .value, with: {(usernameSnapshot) in
            if let dictionary = usernameSnapshot.value as? [String:AnyObject]{
                self.currentUsersName = (dictionary["username"] as? String)!
            }
        })

        
    }

    func performSegueToGoogleSearch(){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
       
      
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        let values = ["userCity":place.formattedAddress as Any] as [String: Any]
        ref.updateChildValues(values, withCompletionBlock: {(err, ref) in
            if err != nil{
                print("This is the error when updating user location \(err?.localizedDescription as Any)")
                return
            }
        })
        
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error:\(error.localizedDescription)")
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    func animateErrorIn(){
        self.view.addSubview(errorUploadingPhotoView)
        errorUploadingPhotoView.center = self.view.center
        errorUploadingPhotoView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        errorUploadingPhotoView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.errorUploadingPhotoView.alpha = 1
            self.errorUploadingPhotoView.transform = CGAffineTransform.identity
        }

    }
    func animateErrorOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.errorUploadingPhotoView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.errorUploadingPhotoView.alpha = 0
            self.visualEffectView.effect = nil
            
        }){(success:Bool) in
            self.errorUploadingPhotoView.removeFromSuperview()
        }

    }
    func animateIn(){
        self.view.addSubview(sucessUsername)
        sucessUsername.center = self.view.center
        sucessUsername.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        sucessUsername.alpha = 0
              UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.sucessUsername.alpha = 1
            self.sucessUsername.transform = CGAffineTransform.identity
                Timer.scheduledTimer(timeInterval: 0.30, target: self, selector: #selector(self.animateCheckBox), userInfo: nil, repeats: false)
        }
        
    }
    func animateCheckBox(){
      checkBox.setOn(true, animated: true)
    }
    
    
    func saveUpdatedFields(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
       let values = ["email":currentUserEmail.text as Any,"aboutMe":aboutMe.text] as [String: Any]
        ref.updateChildValues(values, withCompletionBlock: {(err, ref) in
            if err != nil{
                print("The error when updating the values\(err?.localizedDescription as Any)")
                return
                }
            })
        dismiss(animated: true, completion: nil)
    }
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.checkBox.setOn(false, animated: true)
            self.sucessUsername.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.sucessUsername.alpha = 0
            self.visualEffectView.effect = nil
            
        }){(success:Bool) in
            self.sucessUsername.removeFromSuperview()
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
            currentProfilePicture.image = selectedImage
            updateProfileImageInFirebase(image: selectedImage)
        }
dismiss(animated: true, completion: nil)
}
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
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
                        
                        self.animateErrorIn()
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
                    self.animateErrorIn()
                    return
                    }
                })
            }
        })
    }
}
