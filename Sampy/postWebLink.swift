//
//  postWebLink.swift
//  Sampy
//
//  Created by Omar Abbas on 10/11/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class postWebLink: UIViewController,UITextFieldDelegate, WKNavigationDelegate {
    
    var passedImage: UIImage!
    var passedName = String()
    var passedWebLink = String()
    var passedCategory = String()
    var passedAddress = String()
    var passedDescription = String()
    var passedLat = String()
    var passedLong = String()
    var statusBarShouldBeHidden = Bool()
    var webView: WKWebView?
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    @IBAction func backToWriteAWebLink(segue:UIStoryboardSegue){
        
    }
    
    @IBOutlet weak var backButtonImage: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    
    @IBAction func editingChanged(_ sender: UITextField) {
        
        if (sender.text?.hasPrefix("https://"))!{
        alertLabel.isHidden = false
           
            alertLabel.isHidden = true
            view.bringSubview(toFront: activityIndicator)
           activityIndicator.startAnimating()
            let url = URL(string: sender.text!)
            let request = URLRequest(url: url!)
            webView?.load(request)
            
        
        } else{
            alertLabel.isHidden = false
        alertLabel.text = "Missing https://"
    }
}
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var webLinkTextField: UITextField!
    @IBOutlet weak var viewForWebKit: UIView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
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
        webView = WKWebView()
        
        let webViewFrame = CGRect(x: viewForWebKit.frame.origin.x, y: viewForWebKit.frame.origin.y, width: viewForWebKit.frame.width, height: viewForWebKit.frame.height)
        
        webView?.navigationDelegate = self
   
        webView?.frame = webViewFrame
        
        view.addSubview(webView!)
        view.bringSubview(toFront: webView!)
        
        nextButton.layer.cornerRadius = 5
        webLinkTextField.delegate = self
        
        nextButton.addTarget(self, action: #selector(nextButtonFunction), for: .touchUpInside)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        if passedWebLink != ""{
            webLinkTextField.text = passedWebLink
        }
    }
    func nextButtonFunction(){
        //check first if weblink is empty
        if webLinkTextField.text == "" {
            alertLabel.isHidden = false
            alertLabel.text = "You need to enter a link to continue"
        } else{
            //it is not empty so we check if the prefix is https://
            
            if (webLinkTextField.text?.hasPrefix("https://"))!{
                alertLabel.isHidden = true
                performSegue(withIdentifier: "moveToCategory", sender: self)
            }else{
                //it doesn't have a https:// prefix
            alertLabel.isHidden = false
            alertLabel.text = "Make sure your link has https:// in the beginning to continue "
            }
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("did finish loading the link")
        activityIndicator.stopAnimating()
        view.sendSubview(toBack: activityIndicator)
        
    }
    func hideKeyboard(){
        view.endEditing(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToName"{
            let viewController = segue.destination as! postName
            viewController.passedImage = passedImage
            viewController.passedName = passedName
            viewController.passedWebLink = passedWebLink
            viewController.passedCategory = passedCategory
            viewController.passedAddress = passedAddress
            viewController.passedLat = passedLat
            viewController.passedLong = passedLong
            viewController.passedDescription = passedDescription
        }
        if segue.identifier == "moveToCategory" {
            let viewController = segue.destination as! postCategory
            
            viewController.imagePassedOver = passedImage
            viewController.passedName = passedName
            viewController.passedWebLink = webLinkTextField.text!
            viewController.theSelectedCategory = passedCategory
            viewController.passedAddress = passedAddress
            viewController.passedLat = passedLat
            viewController.passedLong = passedLong
            viewController.passedOverDescription = passedDescription
        }
    }
}
