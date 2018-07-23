//
//  registerPassword.swift
//  Sampy
//
//  Created by Omar Abbas on 5/26/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit


class registerPassword: UIViewController {
    @IBOutlet weak var showPassword: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var passwordNotLongEnough: UILabel!
    
    @IBOutlet weak var closeErrorView: UIButton!
    
    
    @IBOutlet var errorView: UIView!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var enteredEmail: String?
    var enteredBirthday: String?
    var enteredPassword: String?
    var enteredUsername: String?
    @IBOutlet weak var backButtonImage: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func unwindToRegisterPasswordViewController(segue:UIStoryboardSegue){
        
    }
    
    var effect: UIVisualEffect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 480:
                print("iPhone Classic")
            case 960:
                print("iPhone 4 or 4S")
                nextButton.frame.origin.y = 265
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
        
        if enteredPassword != nil {
            passwordTextField.text = enteredPassword
        }
        
        let border = CALayer()
        
        let width = CGFloat(1.0)
        
        errorView.layer.cornerRadius = 14
        errorView.backgroundColor = UIColor.white
        
        closeErrorView.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - width, width:  passwordTextField.frame.size.width, height: passwordTextField.frame.size.height)
        border.borderWidth = width
        
        passwordTextField.layer.addSublayer(border)
        passwordTextField.tintColor = UIColor.white
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapFunction)))
        showPassword.addTarget(self, action: #selector(showEnteredPassword), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(sendInformation), for: .touchUpInside)
    }
    func sendInformation(){
        if passwordTextField.text! == "" || (passwordTextField.text?.characters.count)! < 6 {
          animateIn()
        }
        else{
            performSegue(withIdentifier: "compileInformation", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "compileInformation" {
            let navigationVC = segue.destination as? UINavigationController
            let viewController = navigationVC?.viewControllers.first as! finishedRegistering
           
            viewController.enteredEmail = enteredEmail
            viewController.enteredPassword = self.passwordTextField.text
            viewController.enteredUsername = self.enteredUsername
            viewController.enteredBirthday = self.enteredBirthday
            
        }
        if segue.identifier == "backToUsername" {
            let viewController = segue.destination as! registerUsername
           
            viewController.enteredEmail = enteredEmail
            viewController.enteredBirthday = enteredBirthday
            viewController.enteredUsername = enteredUsername
            viewController.enteredPassword = enteredPassword
            
            
        }

    }
    func showEnteredPassword(){
        if self.passwordTextField.isSecureTextEntry == true {
            self.passwordTextField.isSecureTextEntry = false
            self.showPassword.setTitle("Hide", for: .normal)
        } else {
            self.passwordTextField.isSecureTextEntry = true
            self.showPassword.setTitle("Show", for: .normal)
        }
    }
    func tapFunction(){
        view.endEditing(true)
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


}
