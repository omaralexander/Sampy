//
//  registerBirthday.swift
//  Sampy
//
//  Created by Omar Abbas on 5/26/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit

class registerBirthday: UIViewController{
    
    @IBOutlet weak var nextButton: UIButton!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    @IBOutlet weak var backButtonImage: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBAction func birthdayTextField(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.backgroundColor = UIColor.white
        
        datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
    
        
        
        
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    @IBOutlet weak var TheBirthdayTextField: UITextField!

    var enteredEmail: String?
    var enteredBirthday: String?
    var enteredPassword: String?
    var enteredUsername: String?
    
    var legalAge:Bool?
    
    @IBAction func unwindToRegisterBirthdayViewController(segue:UIStoryboardSegue){
        
    }
    
    
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
        let border = CALayer()
        
        let width = CGFloat(1.0)
        
        if enteredBirthday != nil {
            TheBirthdayTextField.text = enteredBirthday
        }
        
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: TheBirthdayTextField.frame.size.height - width, width:  TheBirthdayTextField.frame.size.width, height: TheBirthdayTextField.frame.size.height)
        border.borderWidth = width
        
        TheBirthdayTextField.layer.addSublayer(border)

        TheBirthdayTextField.tintColor = UIColor.white
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapFunction)))
        
        nextButton.addTarget(self, action: #selector(sendInformation), for: .touchUpInside)
        
        
    }
    
    func tapFunction(){
        view.endEditing(true)
    }
    
    
    func sendInformation(){
        
        if TheBirthdayTextField.text == "" || legalAge == false {
         
        }
        else{
            performSegue(withIdentifier: "usernameRegister", sender: self)
        }
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "usernameRegister" {
                let navigationVC = segue.destination as? UINavigationController
                let viewController = navigationVC?.viewControllers.first as! registerUsername
                viewController.enteredEmail = enteredEmail
                viewController.enteredBirthday = enteredBirthday
                viewController.enteredPassword = enteredPassword
                viewController.enteredUsername = enteredUsername
            }
            if segue.identifier == "backToEmail" {
                
                let viewController = segue.destination as! registerEmail
                viewController.enteredEmail = enteredEmail
                viewController.enteredBirthday = enteredBirthday
                viewController.enteredUsername = enteredUsername
                viewController.enteredPassword = enteredPassword
                
                
            }

        }
        func datePickerValueChanged(sender:UIDatePicker) {
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "MMMM dd YYYY"
            TheBirthdayTextField.text = dateFormatter.string(from: sender.date)
            enteredBirthday = dateFormatter.string(from: sender.date)
 
            
        }


}
