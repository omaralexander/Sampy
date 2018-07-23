//
//  reportAccountViewController.swift
//  Sampy
//
//  Created by Omar Abbas on 10/26/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import MessageUI
class reportAccountViewController: UIViewController,MFMailComposeViewControllerDelegate,UITextViewDelegate{
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var backButtonImage: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    var blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
    var userID = String()
    var statusBarShouldBeHidden = Bool()
    
    override var prefersStatusBarHidden: Bool{
        return statusBarShouldBeHidden
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                print("it is the iPhone X")
                submitButton.frame.origin.y = 40
                backButtonImage.frame.origin.y = 50
                dismissButton.frame.origin.y = 38
                self.statusBarShouldBeHidden = false
                setNeedsStatusBarAppearanceUpdate()
                
            default:
                print("unknown")
            }
        }
        self.statusBarShouldBeHidden = true
        setNeedsStatusBarAppearanceUpdate()
        self.textDescription.delegate = self
        submitButton.layer.cornerRadius = 5
        self.textDescription.text = "Your feedback is important to us,please write what the issue is so we can quickly resolve it."
        self.textDescription.textColor = UIColor.lightGray
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        textDescription.addGestureRecognizer(swipeDown)
        dismissButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result{
        case .cancelled:
            break
        case .saved:
            break
        case .sent:
            break
        case .failed:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }

    @IBAction func sendingEmail(_ sender: UIButton) {
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients(["sampyteam@gmail.com"])
            composer.setSubject("Report filed against user")
            composer.setMessageBody(self.textDescription.text + "                                                                                                                       " + "User: \(userID)", isHTML: false)
            self.present(composer, animated: true, completion: nil)
    }
    func dismissViewController(){
        dismiss(animated: true, completion: nil)
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
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "Your feedback is important to us,please write what the issue is so we can quickly resolve it"
            textView.textColor = UIColor.lightGray
        }
    }
}
