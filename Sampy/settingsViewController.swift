UI//
//  settingsViewController.swift
//  Sampy
//
//  Created by Omar Abbas on 5/29/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class settingsViewController: UIViewController{
    
    @IBOutlet var newPasswordSignInView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var sendEmailAndPassword: UIButton!
    
    @IBOutlet weak var forgotPassword: UIButton!
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var closePasswordAndEmailView: UIButton!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    @IBOutlet weak var forSecurityReasonsLabel: UILabel!
    
    @IBOutlet weak var yourEmailLabel: UILabel!
    
    @IBOutlet weak var yourpasswordLabel: UILabel!
    
    @IBOutlet weak var helpButton: UIButton!

    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmNewPassword: UITextField!
    
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var confirmChangeLabel: UILabel!
    @IBOutlet weak var saveNewPassword: UIButton!
    
    @IBOutlet weak var radiusLabel: UILabel!

    @IBOutlet weak var permaPost: UIButton!
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        radiusLabel.text = "\(currentValue)"
        let user = Auth.auth().currentUser
        
        guard let uid = user?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.updateChildValues(["radiusDistance":sender.value])
    }
    
   
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    var greenColor = UIColor(red: 210/255, green: 224/255, blue: 195/255, alpha: 1)
    
    @IBAction func confirmPasswordEditingChangeed(_ sender: UITextField) {
        if sender.text == newPassword.text {
            confirmNewPassword.backgroundColor = greenColor
            
        } else{
            confirmNewPassword.backgroundColor = UIColor.white
        }
    }
    
    var retrivedPassword: String?
    var radiusDistanceNumber = NSNumber()
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
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                
               settingsLabel.frame.origin.y = 45
                helpButton.frame.origin.y = 42
                permaPost.frame.origin.y = 45
    
            default:
                print("unknown")
            }
        }
       self.loadTheView()
}
   
    override func viewDidAppear(_ animated: Bool) {
        let viewController = self.parent as! tabBarViewController
        viewController.statusBarStyle = .default
        viewController.setNeedsStatusBarAppearanceUpdate()
        isPermaPostHidden()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        let viewController = self.parent as! tabBarViewController
        viewController.statusBarStyle = .default
        viewController.setNeedsStatusBarAppearanceUpdate()
    }
    func radiusValue(){
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.observeSingleEvent(of: .value, with: {snapshot in
            if snapshot.exists() == true{
            if let dictionary = snapshot.value as? [String: Any] {
                self.radiusDistanceNumber = (dictionary["radiusDistance"] as? NSNumber)!
                var testValue: Int?
                testValue = self.radiusDistanceNumber.intValue
                if testValue == nil {
                    //add timer function to try again
                    let alertController = UIAlertController(
                        title: "Error",
                        message: "Data not loading properly, make sure you have a strong connection and try again", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)

                } else{
                    let formatter = NumberFormatter()
                    formatter.minimumFractionDigits = 0
                    formatter.maximumFractionDigits = 0
                    self.radiusSlider.value = self.radiusDistanceNumber.floatValue
                    self.radiusLabel.text = formatter.string(from: self.radiusDistanceNumber)
                   
                    }
                }
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        radiusValue()
    }
    func savePassword(){
    view.endEditing(true)
        activityIndicator.isHidden = true
        animateIn()
    }
    func saveTheNewPassword(){
        guard let user = Auth.auth().currentUser else{
            return
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        sendEmailAndPassword.isHidden = true
        forSecurityReasonsLabel.isHidden = true
        yourEmailLabel.isHidden = true
        yourpasswordLabel.isHidden = true
        
        
        
        let credential = EmailAuthProvider.credential(withEmail: self.emailTextField.text!, password: passwordTextField.text!)
        user.reauthenticate(with: credential, completion:{ loginError in
            
            if loginError != nil {
                self.activityIndicator.stopAnimating()
                
                self.animateOut()
                
                self.emailTextField.isHidden = false
                self.passwordTextField.isHidden = false
                self.sendEmailAndPassword.isHidden = false
                self.forSecurityReasonsLabel.isHidden = false
                self.yourEmailLabel.isHidden = false
                self.yourpasswordLabel.isHidden = false
                self.activityIndicator.isHidden = true
                

                print("this was the error logging the user in  \(loginError as Any)")
                self.confirmNewPassword.backgroundColor = UIColor.white
               
                self.confirmChangeLabel.text = loginError?.localizedDescription
                    self.confirmChangeLabel.isHidden = false
                
            } else {
    if self.confirmNewPassword.text == self.newPassword.text&&self.confirmNewPassword.text != ""&&self.newPassword.text != ""{
  
    let password = self.confirmNewPassword.text! as String
    user.updatePassword(to: password, completion: {error in
    
    if error != nil{
    print("there was an error\(error as Any) ")
    self.activityIndicator.stopAnimating()
    self.animateOut()
        self.emailTextField.isHidden = false
        self.passwordTextField.isHidden = false
        self.sendEmailAndPassword.isHidden = false
        self.forSecurityReasonsLabel.isHidden = false
        self.yourEmailLabel.isHidden = false
        self.yourpasswordLabel.isHidden = false
        self.activityIndicator.isHidden = true
        

    self.confirmNewPassword.backgroundColor = UIColor.white
    self.confirmChangeLabel.text = error?.localizedDescription
    self.confirmChangeLabel.isHidden = false
    } else {
    let ref = Database.database().reference().child("Users").child(user.uid)
    ref.updateChildValues(["password":password])
    //animate out
    self.activityIndicator.stopAnimating()
    self.animateOut()
        self.emailTextField.isHidden = false
        self.passwordTextField.isHidden = false
        self.sendEmailAndPassword.isHidden = false
        self.forSecurityReasonsLabel.isHidden = false
        self.yourEmailLabel.isHidden = false
        self.yourpasswordLabel.isHidden = false
        self.activityIndicator.isHidden = true
    self.newPassword.text = ""
    self.confirmNewPassword.text = ""
    
    self.confirmChangeLabel.text = "It's changed! R.I.P old password"
    self.confirmChangeLabel.isHidden = false
    self.confirmNewPassword.backgroundColor = UIColor.white
    
                            }
                        })
            } else {
            self.activityIndicator.stopAnimating()
            self.animateOut()
            self.emailTextField.isHidden = false
            self.passwordTextField.isHidden = false
            self.sendEmailAndPassword.isHidden = false
            self.forSecurityReasonsLabel.isHidden = false
            self.yourEmailLabel.isHidden = false
            self.yourpasswordLabel.isHidden = false
            self.activityIndicator.isHidden = true
            self.confirmNewPassword.backgroundColor = UIColor.white
            self.confirmChangeLabel.text = "There was an error in changing your password"
            self.confirmChangeLabel.isHidden = false
                    }
                }
            })
        }

    func animateIn(){
    //we would bring in the view
        self.view.addSubview(newPasswordSignInView)
        
        
        newPasswordSignInView.center = self.view.center
        newPasswordSignInView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        newPasswordSignInView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.newPasswordSignInView.alpha = 1
            self.newPasswordSignInView.transform = CGAffineTransform.identity
        }

    }
    func animateOut(){
    //we would bring out the view
        UIView.animate(withDuration: 0.3, animations: {
            self.newPasswordSignInView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.newPasswordSignInView.alpha = 0
            self.visualEffectView.effect = nil
            
        }){(success:Bool) in
            self.newPasswordSignInView.removeFromSuperview()
        }

    }
    func userForgotPassword(){
        guard let user = Auth.auth().currentUser?.email else{
            return
        }
        Auth.auth().sendPasswordReset(withEmail: user, completion: {result in
            self.animateOut()
            self.confirmChangeLabel.isHidden = false
            self.confirmChangeLabel.text = "Link to change your password has been sent to your email"
            
            })
    }
    
    func goToHelp(){
        performSegue(withIdentifier: "goToHelp", sender: self)
    }
    func loadTheView(){
        
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
        permaPost.isHidden = true
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        permaPost.titleLabel?.adjustsFontSizeToFitWidth = true
        newPasswordSignInView.frame = CGRect(x: newPasswordSignInView.frame.origin.x, y: newPasswordSignInView.frame.origin.y, width: UIScreen.main.bounds.width - 14, height: newPasswordSignInView.frame.height)
        
        forgotPassword.titleLabel?.adjustsFontSizeToFitWidth = true
        closePasswordAndEmailView.titleLabel?.adjustsFontSizeToFitWidth = true
        helpButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        saveNewPassword.layer.cornerRadius = 5
        
        let border = CALayer()
        
        let width = CGFloat(1.0)
        
        let blackColor = UIColor(red: 223/255, green: 231/255, blue: 228/255, alpha: 1)
        
        border.borderColor = blackColor.cgColor
        border.frame = CGRect(x: 0, y: emailTextField.frame.size.height - width, width:  emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        border.borderWidth = width
        
        
        
        emailTextField.layer.addSublayer(border)
        
        let passwordTextBorder = CALayer()
        
        passwordTextBorder.borderColor = blackColor.cgColor
        passwordTextBorder.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - width, width:  passwordTextField.frame.size.width, height: passwordTextField.frame.size.height)
        passwordTextBorder.borderWidth = width
        
        
        
        passwordTextField.layer.addSublayer(passwordTextBorder)
        
        
        isPermaPostHidden()
        permaPost.addTarget(self, action: #selector(goToPermaPost), for: .touchUpInside)
        
        
        
        forgotPassword.addTarget(self, action: #selector(userForgotPassword), for: .touchUpInside)
        closePasswordAndEmailView.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        sendEmailAndPassword.addTarget(self, action: #selector(saveTheNewPassword), for: .touchUpInside)
        
        newPasswordSignInView.layer.cornerRadius = 14
        sendEmailAndPassword.layer.cornerRadius = 5
        
        
        saveNewPassword.addTarget(self, action: #selector(savePassword), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        confirmChangeLabel.isHidden = true
        
        helpButton.addTarget(self, action: #selector(goToHelp), for: .touchUpInside)
        
        
        //viewForItems.layer.shadowColor = UIColor.black.cgColor
        //viewForItems.layer.shadowOffset = CGSize(width: 3, height: 3)
        //viewForItems.layer.cornerRadius = 14
        //viewForItems.layer.shadowOpacity = 0.3 //0.7
        //viewForItems.layer.shadowRadius = 4
        
        radiusSlider.minimumValue = 1
        radiusSlider.maximumValue = 30
        radiusValue()

    }
    func isPermaPostHidden(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
          
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let access = dictionary["access"] as! String
                
                if access == "false" || access == "False" {
                    self.permaPost.isHidden = true
                } else {
                    self.permaPost.isHidden = false
                }
            }
        })
    }
    func goToPermaPost(){
        performSegue(withIdentifier: "permaPostSegue", sender: self)
    }
    func hideKeyboard(){
        view.endEditing(true)
    }
}

