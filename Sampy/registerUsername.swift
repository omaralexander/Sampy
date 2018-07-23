//
//  registerUsername.swift
//  Sampy
//
//  Created by Omar Abbas on 5/26/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase

class registerUsername: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var usernameTakenLabel: UILabel!
    
    var enteredEmail: String?
    var enteredBirthday: String?
    var enteredPassword: String?
    var enteredUsername: String?
    
    @IBOutlet weak var backButtonImage: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    var users = [String]()
    var filteredUsers = [User]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    
    @IBAction func unwindToRegisterUsernameViewController(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func editingDidBegin(_ sender: UITextField) {
        
        self.userNameTextField.backgroundColor = UIColor.clear
        self.userNameTextField.textColor = UIColor.white
        self.userNameTextField.tintColor = UIColor.white
        self.usernameTakenLabel.isHidden = true

    }
    var redColor = UIColor(red: 139/255, green: 49/255, blue: 56/255, alpha: 1)
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
        setupButton()
        setupKeyboardObservers()
        
        let border = CALayer()
        
        let width = CGFloat(1.0)
        
        usernameTakenLabel.isHidden = true
        
        if enteredUsername != nil {
            userNameTextField.text = enteredUsername
        }
        
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: userNameTextField.frame.size.height - width, width:  userNameTextField.frame.size.width, height: userNameTextField.frame.size.height)
        border.borderWidth = width
        
       userNameTextField.layer.addSublayer(border)
        userNameTextField.tintColor = UIColor.white
        
        nextButton.addTarget(self, action: #selector(checkIfUserNameIsTaken), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapFunction)))
    }
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func handleKeyboardWillHide(notification:NSNotification){
        buttonViewBottomAnchor?.constant = 0
        
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: keyboardDuration, animations: {self.view.layoutIfNeeded()
        })
    }
    func handleKeyboardWillShow(notification:NSNotification){
        
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        buttonViewBottomAnchor?.constant = -(((keyboardFrame?.height)!) + 10)
        
        UIView.animate(withDuration: keyboardDuration, animations: {self.view.layoutIfNeeded()
        })
    }
    var buttonViewBottomAnchor: NSLayoutConstraint?
    
    func setupButton(){
        buttonViewBottomAnchor = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        buttonViewBottomAnchor?.isActive = true
        
    }
    func tapFunction(){
        view.endEditing(true)
    }
    func sendInformation(){
        if userNameTextField.text == "" {

            self.userNameTextField.backgroundColor = self.redColor
            self.userNameTextField.textColor = UIColor.white
            self.userNameTextField.tintColor = UIColor.white
            self.usernameTakenLabel.isHidden = false
            self.usernameTakenLabel.text = "This field can't be empty"
        }
        else{
            self.usernameTakenLabel.isHidden = true
            performSegue(withIdentifier: "passwordRegister", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passwordRegister" {
            let navigationVC = segue.destination as? UINavigationController
            let viewController = navigationVC?.viewControllers.first as! registerPassword
            viewController.enteredEmail = enteredEmail
            viewController.enteredBirthday = enteredBirthday
            viewController.enteredUsername = userNameTextField.text
            viewController.enteredPassword = enteredPassword
        }
        if segue.identifier == "backToBirthday" {
            
            let viewController = segue.destination as! registerBirthday
            viewController.enteredEmail = enteredEmail
            viewController.enteredBirthday = enteredBirthday
            viewController.enteredUsername = enteredUsername
            viewController.enteredPassword = enteredPassword
            
            
        }

    }
    func checkIfUserNameIsTaken(){
        tapFunction()
let ref = Database.database().reference().child("Usernames").child("username")
        ref.queryOrdered(byChild: "username").queryEqual(toValue: self.userNameTextField.text).observeSingleEvent(of: .value, with: {(snapshot) in
            if (snapshot.childrenCount == 0 || snapshot.exists() == false){

                self.sendInformation()
            } else {

                self.userNameTextField.backgroundColor = self.redColor
                self.userNameTextField.textColor = UIColor.white
                self.userNameTextField.tintColor = UIColor.white
                self.usernameTakenLabel.isHidden = false
                
            }
        })
    }
}
