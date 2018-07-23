//
//  postDescription.swift
//  Sampy
//
//  Created by Omar Abbas on 10/11/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit

class postDescription: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var postDescription: UITextView!
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    @IBOutlet weak var alertLabel: UILabel!
    var passedImage: UIImage!
    var passedName = String()
    var passedWebLink = String()
    var passedCategory = String()
    var passedAddress = String()
    var passedDescription = String()
    var passedLat = String()
    var passedLong = String()
    var statusBarShouldBeHidden = Bool()
    var blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
    
    @IBOutlet weak var backButtonImage: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    
    @IBAction func backToWriteADescription(segue:UIStoryboardSegue){
        
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
        nextButton.layer.cornerRadius = 5
        nextButton.addTarget(self, action: #selector(nextButtonFunction), for: .touchUpInside)
        postDescription.delegate = self
       
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        self.postDescription.addGestureRecognizer(swipeDown)
        
        self.postDescription.text = "Talk about what your post is about in here"
        self.postDescription.textColor = UIColor.lightGray
        
        if passedDescription != "" {
            self.postDescription.textColor = blackColor
            self.postDescription.text = passedDescription
            
        }
    }
    
    func hideKeyboard(){
        view.endEditing(true)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = blackColor
        }
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
       // descriptionString = textView.text
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
       // descriptionString = textView.text
        if textView.text.isEmpty{
            textView.text = "Talk about what your post is about in here"
            textView.textColor = UIColor.lightGray
        }
    }
    func nextButtonFunction(){
        if postDescription.text != "" && postDescription.text != "Talk about what your post is about in here" {
        alertLabel.isHidden = true
        performSegue(withIdentifier: "moveToCompileAndPost", sender: self)
            
        } else {
        alertLabel.isHidden = false
        
            }
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToAddress"{
            let viewController = segue.destination as! postAddress
            viewController.passedImage = passedImage
            viewController.passedName = passedName
            viewController.passedWebLink = passedWebLink
            viewController.passedCategory = passedCategory
            viewController.passedAddress = passedAddress
            viewController.passedLat = passedLat
            viewController.passedLong = passedLong
            viewController.passedDescription = passedDescription
        }
        if segue.identifier == "moveToCompileAndPost" {
            let viewController = segue.destination as! compileAndPermaPost
            
            viewController.passedImage = passedImage
            viewController.passedName = passedName
            viewController.passedWebLink = passedWebLink
            viewController.passedCategory = passedCategory
            viewController.passedAddress = passedAddress
            viewController.passedLat = passedLat
            viewController.passedLong = passedLong
            viewController.passedDescription = postDescription.text
            }
        }
    }
