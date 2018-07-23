//
//  checkIfLoggedIn.swift
//  Sampy
//
//  Created by Omar Abbas on 5/26/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase

class checker: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                Database.database().reference().child("Users").child((user?.uid)!).child("password").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                
                let defaults = UserDefaults(suiteName: "group.username.SuitName")!
               
                        defaults.set( auth.currentUser?.refreshToken, forKey: "FAuthDataToken")
                        defaults.set(user?.email, forKey: "email")
                        defaults.set(snapshot.value, forKey: "password")
                        defaults.synchronize()
           
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let vc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "newNavigationController") as! UINavigationController
                self.present(vc, animated: true, completion: nil)
                })
            } else {
                // No user is signed in.
                let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
                let bc: UIViewController = storyboard.instantiateViewController(withIdentifier: "appStartViewController")
                self.present(bc, animated: true, completion: nil)
                print("user not signed in ")
                
                
            }
        }
    }
    var loginViewController: loginViewController?
    func checkVerifiedEmail(){
        let user = Auth.auth().currentUser
        if user?.isEmailVerified == true {
            
        } else{
            Auth.auth().currentUser?.sendEmailVerification(completion:{(error) in })
            
            
        }
    }

    }

