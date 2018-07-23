//
//  helpPage.swift
//  Sampy
//
//  Created by Omar Abbas on 6/13/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase

class helppage:UIViewController {
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var emailImage: UIImageView!
    
    
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var twitterImage: UIImageView!
    
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var instagramImage: UIImageView!
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var facebookImage: UIImageView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.child("profileImageUrl").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() == false {
                let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
                let bc: UIViewController = storyboard.instantiateViewController(withIdentifier: "appStartViewController")
                self.present(bc, animated: true, completion: nil)
            
                
            }
        })
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                
                helpLabel.frame.origin.y = 40
                imageButton.frame.origin.y = 45
                dismissButton.frame.origin.y = 32
            default:
                print("unknown")
            }
        }
        facebookButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(facebookHyperLink)))
        twitterButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(twitterHyperLink)))
        instagramButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(instagramHyperLink)))
        emailButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emailApplicationLink)))
        
        dismissButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        
        twitterImage.contentMode = .scaleAspectFill
        emailImage.contentMode = .scaleAspectFill
        instagramImage.contentMode = .scaleAspectFill
        facebookImage.contentMode = .scaleAspectFill
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.child("profileImageUrl").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() == false {
                let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
                let bc: UIViewController = storyboard.instantiateViewController(withIdentifier: "appStartViewController")
                self.present(bc, animated: true, completion: nil)
               
                
            }
        })
    }
    func dismissViewController(){
        dismiss(animated: true, completion: nil)
    }
    func facebookHyperLink(){
        if let url = URL(string: "https://www.facebook.com/sampy-app/"){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    func twitterHyperLink(){
        if let url = URL(string: "https://twitter.com/sampy_app"){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
        
        
    }
    func instagramHyperLink(){
        if let url = URL(string: "https://www.instagram.com/sampy_app/"){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
        
        
    }
    func emailApplicationLink(){
        let email = "sampy_app@gmail.com"
        let urlEmail = NSURL(string: "mailto:\(email)")
        
        if UIApplication.shared.canOpenURL(urlEmail! as URL){
            UIApplication.shared.openURL(urlEmail! as URL)
        } else{
            
        }
    }
    
}
