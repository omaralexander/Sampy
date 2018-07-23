//
//  writeABitMore.swift
//  Sampy
//
//  Created by Omar Abbas on 10/6/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit


class writeABitMore: UIViewController, UITextViewDelegate, UIScrollViewDelegate {
    
    var imagePassedOver: UIImage!
    var theSelectedCategory = String()
    var descriptionString = String()
    var statusBarShouldBeHidden = Bool()
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var backButtonImage: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var noWritingLabel: UILabel!
    var blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBAction func unwindToWriteABitMore(segue:UIStoryboardSegue){
        
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
        if descriptionString.isEmpty == false && descriptionString != "The greatest post in the history of all posts can be the one you write in here" {
            textView.delegate = self
            scrollView.keyboardDismissMode = .onDrag
            nextButton.layer.cornerRadius = 5
            self.scrollView.contentSize.height = textView.frame.origin.y + textView.frame.height
            
             textView.text = descriptionString
             textView.textColor = blackColor
            self.nextButton.addTarget(self, action: #selector(goToNext), for: .touchUpInside)
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(endEditing))
            swipeDown.direction = .down
            self.view.addGestureRecognizer(swipeDown)
            self.textView.addGestureRecognizer(swipeDown)
            noWritingLabel.isHidden = true
            
            
        } else {
        textView.delegate = self
        scrollView.keyboardDismissMode = .onDrag
        nextButton.layer.cornerRadius = 5
        
        self.textView.text = "The greatest post in the history of all posts can be the one you write in here"
        self.textView.textColor = UIColor.lightGray
        self.scrollView.contentSize.height = textView.frame.origin.y + textView.frame.height
            self.nextButton.addTarget(self, action: #selector(goToNext), for: .touchUpInside)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(endEditing))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        self.textView.addGestureRecognizer(swipeDown)
        noWritingLabel.isHidden = true
            
        }
    }
    func endEditing(){
    view.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToCategory" {
            let viewController = segue.destination as! descriptionForPosting
            viewController.imagePassedOver = imagePassedOver
            viewController.passedOverDescription = descriptionString
            
        }
        if segue.identifier == "compile" {
            let viewController = segue.destination as! compileAndPost
            viewController.descriptionString = descriptionString
            viewController.imagePassedOver = imagePassedOver
            viewController.theSelectedCategory = theSelectedCategory
            
        }
    }
    func goToNext(){
        if textView.text != "" && textView.text != "The greatest post in the history of all posts can be the one you write in here" {
        performSegue(withIdentifier: "compile", sender: self)
        } else {
            noWritingLabel.isHidden = false
        }
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
    
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = blackColor
        }
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        descriptionString = textView.text
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
descriptionString = textView.text
        if textView.text.isEmpty{
            textView.text = "The greatest post in the history of all posts can be the one you write in here"
            textView.textColor = UIColor.lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        let wordList =  textView.text.components(separatedBy: .punctuationCharacters).joined().components(separatedBy: " ").filter{!$0.isEmpty}
        
        switch wordList.count {
        case 3..<5 :
            alertLabel.isHidden = false
            alertLabel.text = "You're off to a great start"
            break
        case 5..<670:
            alertLabel.isHidden = false
            alertLabel.text = "Looks good so far, anything else?"
            break
        default:alertLabel.isHidden = true
        }
    }
}
