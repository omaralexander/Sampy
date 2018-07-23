//
//  registerEmail.swift
//  Sampy
//
//  Created by Omar Abbas on 5/26/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit

class registerEmail: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBAction func unwindToRegisterEmailViewController(segue:UIStoryboardSegue){
        
    }

    @IBAction func editingDidBegin(_ sender: UITextField) {
        badlyFormatted.isHidden = true
    }
    
      @IBOutlet weak var badlyFormatted: UILabel!
    
    var enteredEmail: String?
    var enteredBirthday: String?
    var enteredPassword: String?
    var enteredUsername: String?
    
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
        badlyFormatted.isHidden = true
        
        
        let border = CALayer()

        let width = CGFloat(1.0)
        
        
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: emailTextField.frame.size.height - width, width:  emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        border.borderWidth = width
        emailTextField.tintColor = UIColor.white
        emailTextField.layer.addSublayer(border)
       
        if enteredEmail != nil {
            emailTextField.text = enteredEmail
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapFunction)))
        nextButton.addTarget(self, action: #selector(sendInformation), for: .touchUpInside)
    }
   
    func sendInformation(){
        if emailTextField.text! == "" || isValidEmail(testStr: emailTextField.text!) == false  {
            badlyFormatted.isHidden = false
            view.endEditing(true)
        }
        else{
            view.endEditing(true)
            performSegue(withIdentifier: "birthdayRegister", sender: self)
        }
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "birthdayRegister" {
                let navigationVC = segue.destination as? UINavigationController
                let viewController = navigationVC?.viewControllers.first as! registerBirthday
                viewController.enteredEmail = self.emailTextField.text
                viewController.enteredUsername = enteredUsername
                viewController.enteredPassword = enteredPassword
                viewController.enteredBirthday = enteredBirthday
                
            }
        }

    
    func tapFunction(){
        view.endEditing(true)
    }
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
        
    }
}
