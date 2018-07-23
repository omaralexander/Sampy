//
//  loginViewController.swift
//  Sampy
//
//  Created by Omar Abbas on 5/26/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Canvas

class loginViewController: UIViewController {
    
    @IBOutlet var forgotPasswordView: UIView!
    
    @IBOutlet var errorLogInView: UIView!
    
    @IBOutlet weak var closeErrorView: UIButton!
    
    @IBOutlet weak var closeForgotPasswordView: UIButton!
    
    @IBOutlet weak var sendNewPasswordButton: UIButton!

    @IBOutlet weak var forgotPasswordEmail: UITextField!
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!

    @IBOutlet weak var loginButton: UIButton!
   
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
  
    @IBOutlet weak var visualEffectView: UIVisualEffectView!

    @IBOutlet weak var passwordAnimationView: CSAnimationView!
    
    @IBOutlet weak var emailAnimationView: CSAnimationView!

    
    @IBOutlet weak var dismissButton: UIButton!
    
    
    @IBOutlet weak var errorViewDescription: UITextView!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    func closeKeyboard(){
        self.view.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeKeyboard()
    }
    
    var effect: UIVisualEffect!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                imageButton.frame.origin.y = 53
                dismissButton.frame.origin.y = 53
                forgotPasswordButton.frame.origin.y = 45
            default:
                print("unknown")
            }
        }
        setupButton()
        setupKeyboardObservers()
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 2.5
        
        
      
        loginButton.addTarget(self, action: #selector(logUserIn), for: .touchUpInside)
        
        emailTextField.tintColor = UIColor.white
        passwordTextField.tintColor = UIColor.white
        
        let border = CALayer()
        let passwordBorder = CALayer()
        let width = CGFloat(1.0)
        
        
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: emailTextField.frame.size.height - width, width:  emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        border.borderWidth = width
        
        emailTextField.layer.addSublayer(border)
     
        passwordBorder.borderColor = UIColor.white.cgColor
        passwordBorder.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - width, width:  passwordTextField.frame.size.width, height: passwordTextField.frame.size.height)
        passwordBorder.borderWidth = width
        
        passwordTextField.layer.addSublayer(passwordBorder)
        
        
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordAnimateIn), for: .touchUpInside)
       
        forgotPasswordView.layer.cornerRadius = 14
        
        forgotPasswordView.backgroundColor = UIColor.white
        
        errorLogInView.layer.cornerRadius = 14
        errorLogInView.backgroundColor = UIColor.white
        
        closeErrorView.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        sendNewPasswordButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        closeForgotPasswordView.addTarget(self, action: #selector(forgotPasswordAnimateOut), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissFunction), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        passwordAnimationView.startCanvasAnimation()
        emailAnimationView.startCanvasAnimation()
    }
    func logUserIn(){
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, let password = passwordTextField.text
            else{
    
                return
        }
        let theUser: User?
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(theUser, error) in
            if error != nil{
                self.errorViewDescription.text = error?.localizedDescription
                self.animateIn()
                return
            }
            

            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "newNavigationController") as!
            UINavigationController
            self.present(vc, animated: true, completion: nil)
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            
    })
}
    func dismissFunction(){
        dismiss(animated: true, completion: nil)
    }
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    func handleKeyboardWillHide(notification:NSNotification){
        
        self.loginButtonBottomAnchor?.constant = 0
        self.signupButtonBottomAnchor?.constant = 0
      
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: keyboardDuration, animations: {self.view.layoutIfNeeded()
 
        })
    }
    
    func handleKeyboardWillShow(notification:NSNotification){
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        loginButtonBottomAnchor?.constant = -(((keyboardFrame?.height)!) + 2)
        signupButtonBottomAnchor?.constant = -(((keyboardFrame?.height)!) + 40)
        
        UIView.animate(withDuration: keyboardDuration, animations: {self.view.layoutIfNeeded()
        })
    }
    
    var loginButtonBottomAnchor: NSLayoutConstraint?
    var signupButtonBottomAnchor: NSLayoutConstraint?
    func setupButton(){
        
        loginButtonBottomAnchor = loginButton.bottomAnchor.constraint(equalTo: (view?.bottomAnchor)!, constant: -145)
        loginButtonBottomAnchor?.isActive = true
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func animateIn(){
        self.view.addSubview(errorLogInView)
        errorLogInView.center = self.view.center
        errorLogInView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        errorLogInView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.errorLogInView.alpha = 1
            self.errorLogInView.transform = CGAffineTransform.identity
        }
    }
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.errorLogInView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.errorLogInView.alpha = 0
            self.visualEffectView.effect = nil
            
        }){(success:Bool) in
            self.errorLogInView.removeFromSuperview()
        }
    }

    func forgotPasswordAnimateIn(){
        self.view.addSubview(forgotPasswordView)
        

        forgotPasswordView.center = self.view.center
        forgotPasswordView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        forgotPasswordView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.forgotPasswordView.alpha = 1
            self.forgotPasswordView.transform = CGAffineTransform.identity
        }
       
    }
    func forgotPasswordAnimateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.forgotPasswordView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.forgotPasswordView.alpha = 0
            self.visualEffectView.effect = nil
            
        }){(success:Bool) in
            self.forgotPasswordView.removeFromSuperview()
        }
    }
    
    
    func endEditing(){
        view.endEditing(true)
    }
    
    func signUserUp(){
        performSegue(withIdentifier: "emailRegister", sender: self)
    }
    func forgotPassword(){
        Auth.auth().sendPasswordReset(withEmail: self.forgotPasswordEmail.text!, completion: {result in
         
            self.forgotPasswordAnimateOut()
        })
    }
}
