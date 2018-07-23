//
//  finishedRegistering.swift
//  Sampy
//
//  Created by Omar Abbas on 5/26/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase
import BEMCheckBox

class finishedRegistering: UIViewController {
    @IBOutlet weak var closeErrorView: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var checkMarkFrame: UIView!
    @IBOutlet var errorView: UIView!
    @IBOutlet weak var errorDescription: UILabel!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }

    var enteredEmail: String?
    var enteredBirthday: String?
    var enteredPassword: String?
    var enteredUsername: String?
    let checkBox = BEMCheckBox()
    
    @IBOutlet weak var termsAndConditionsButton: UIButton!
    var effect: UIVisualEffect!
    
    @IBOutlet weak var backButtonImage: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    override func viewDidLoad() {
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
                
                
                backButtonImage.frame.origin.y = 50
                dismissButton.frame.origin.y = 38
                
            default:
                print("unknown")
            }
        }
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        errorView.layer.cornerRadius = 34
        errorView.backgroundColor = UIColor.white
        
        
        checkBox.isSelected = false
        checkBox.frame = checkMarkFrame.frame
        checkBox.lineWidth = 3
        checkBox.onTintColor = UIColor.white
        checkBox.onCheckColor = UIColor.white
        checkBox.backgroundColor = UIColor.clear
        checkBox.onAnimationType = .oneStroke
        view.addSubview(checkBox)
        view.bringSubview(toFront: checkBox)
        
        
        
        
        createAccountButton.layer.cornerRadius = 14
        createAccountButton.layer.borderColor = UIColor.white.cgColor
        createAccountButton.layer.borderWidth = 3
        createAccountButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        
        closeErrorView.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        termsAndConditionsButton.addTarget(self, action: #selector(goToTermsAndConditions), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        Timer.scheduledTimer(timeInterval: 0.30, target: self, selector: #selector(self.animateCheckMark), userInfo: nil, repeats: false)
    }
    func animateCheckMark(){
        checkBox.setOn(true, animated: true)
    }
    func createUser(){
        guard let email = enteredEmail, let password = enteredPassword, let username = enteredUsername , let birthday = enteredBirthday
            else{
                
                return
        }
        let theUser: User?
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {(theUser, error)
            in
            
            if error != nil {
                print(self.enteredEmail as Any)
                print(self.enteredBirthday as Any)
                print(self.enteredPassword as Any)
                print(self.enteredUsername as Any)
                self.animateIn()
                self.errorDescription.text = error?.localizedDescription
                return
            }
            guard let uid = theUser?.uid else{
                return
            }
            let ref = Database.database().reference()
            let usersReference = ref.child("Users").child(uid)
            let distance = "5"
            let distanceNumber = (distance as NSString).integerValue
            let deviceID = UIDevice.current.identifierForVendor?.uuidString
            let credit = "5"
            let creditAmount = (credit as NSString).integerValue
            
            let values = ["email":email,"password":password,"username":username,"birthday":birthday,"profileImageUrl":"https://firebasestorage.googleapis.com/v0/b/sampy-bc84f.appspot.com/o/noProfilePicture.png?alt=media&token=f8b5b663-1fac-4007-80d2-e2637ad61261","aboutMe":"This is the chance for you to show the world who you are in here","radiusDistance":distanceNumber,"userCity":"Earth","token":"","deviceID":deviceID as Any,"doNotShow":"false","access":"false","postCredit":creditAmount] as [String: Any];
            usersReference.updateChildValues(values, withCompletionBlock: {(err, ref) in
                
                if err != nil{
                   
                    self.animateIn()
                    self.errorDescription.text = err as! String?
               
                    return
                }
                
                let usernameRef = Database.database().reference().child("Usernames").child("username").childByAutoId()
                let usernameValue = ["username":username] as [String: Any]
                usernameRef.updateChildValues(usernameValue, withCompletionBlock: {(error, ref) in
                 
                    if error != nil{
                        print(error?.localizedDescription as Any)
                        
                        return
                    }
  
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "checker") as! UINavigationController
                self.present(vc, animated: true, completion: nil)
                })
            })
            
        })
    }
    func goToTermsAndConditions(){
        if let url = URL(string: ("https://sampyapp.wixsite.com/appwebsite/terms")){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    func animateIn(){
        self.view.addSubview(errorView)
        errorView.center = self.view.center
        errorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        errorView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.errorView.alpha = 1
            self.errorView.transform = CGAffineTransform.identity
        }

    }
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.errorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.errorView.alpha = 0
            self.visualEffectView.effect = nil
            
        }){(success:Bool) in
            self.errorView.removeFromSuperview()
        }
    }
    func sendBackInformation(){
        performSegue(withIdentifier: "backToPassword", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToPassword" {
            
            let viewController = segue.destination as! registerPassword
            viewController.enteredEmail = enteredEmail
            viewController.enteredBirthday = enteredBirthday
            viewController.enteredUsername = enteredUsername
            viewController.enteredPassword = enteredPassword
            
        
        }
    }

    
    
}
