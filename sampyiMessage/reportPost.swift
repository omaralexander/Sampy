//
//  reportPost.swift
//  sampyiMessage
//
//  Created by Omar Abbas on 11/24/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import MessageUI

class reportPost: UIViewController, MFMailComposeViewControllerDelegate,UITextViewDelegate{
    
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    var blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
    var userID = String()
    let composer = MFMailComposeViewController()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.submitButton.layer.cornerRadius = 5
        self.textDescription.delegate = self
        self.textDescription.text = "Your feedback is important to us, please write what the issue is so we can quickly resolve it."
        self.textDescription.textColor = UIColor.lightGray
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        textDescription.addGestureRecognizer(swipeDown)
        dismissButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        
    }
  
    
    
    @IBAction func sendingEmail(_ sender: UIButton){
      performSegue(withIdentifier: "sendEmail", sender: self)
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
    override func viewDidLayoutSubviews() {
        self.view.frame.origin.y = self.topLayoutGuide.length * 4.5
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendEmail"{
        let viewController = segue.destination as? sendEmail
            viewController?.message = self.textDescription.text + "                                                                                                                       " + "User: \(userID)"
        }
    }
    func backToMain(){
        performSegue(withIdentifier: "backToMain", sender: self)
    }
    override func viewWillAppear(_ animated: Bool) {
   NotificationCenter.default.addObserver(self, selector: #selector(backToMain), name:NSNotification.Name(rawValue: "closeView"), object: nil)
    }
}
