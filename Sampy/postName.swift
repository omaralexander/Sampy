//
//  postName.swift
//  Sampy
//
//  Created by Omar Abbas on 10/11/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit

class postName: UIViewController {
    var passedImage: UIImage!
    var passedName = String()
    var passedWebLink = String()
    var passedCategory = String()
    var passedAddress = String()
    var passedLat = String()
    var passedLong = String()
    var passedDescription = String()
    
    var statusBarShouldBeHidden = Bool()
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
     @IBOutlet weak var backButtonImage: UIButton!
     @IBOutlet weak var dismissButton: UIButton!
    
    @IBAction func backToWriteAName(segue:UIStoryboardSegue){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusBarShouldBeHidden = true
        
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
        alertLabel.isHidden = true
        
        nextButton.addTarget(self, action: #selector(nextButtonFunction), for: .touchUpInside)
        nextButton.layer.cornerRadius = 5
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        if passedName != "" {
            nameTextField.text = passedName
        }
        
    }
    func hideKeyboard(){
        view.endEditing(true)
    }
    func nextButtonFunction(){
        if nameTextField.text != ""{
            alertLabel.isHidden = true
        performSegue(withIdentifier: "moveToWebLink", sender: self)
        } else {
            alertLabel.isHidden = false
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToImage"{
            let viewController = segue.destination as! permaPostViewController
            viewController.passedImage = passedImage
            viewController.passedName = passedName
            viewController.passedWebLink = passedWebLink
            viewController.passedCategory = passedCategory
            viewController.passedAddress = passedAddress
            viewController.passedLat = passedLat
            viewController.passedLong = passedLong
            viewController.passedDescription = passedDescription
        }
        if segue.identifier == "moveToWebLink"{
            let viewController = segue.destination as! postWebLink
            viewController.passedImage = passedImage
            viewController.passedName = nameTextField.text!
            viewController.passedWebLink = passedWebLink
            viewController.passedCategory = passedCategory
            viewController.passedAddress = passedAddress
            viewController.passedLat = passedLat
            viewController.passedLong = passedLong
            viewController.passedDescription = passedDescription
        }
    }
}
