//
//  appStartViewController.swift
//  Sampy
//
//  Created by Omar Abbas on 7/15/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import CHIPageControl

class appStartViewController: UIViewController, UIScrollViewDelegate{
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: CHIPageControlPaprika!
    @IBAction func unwindToLoginViewController(segue:UIStoryboardSegue){
        
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @IBOutlet weak var concertImage: UIImageView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var clothesImage: UIImageView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var phoneImage: UIImageView!
    
    @IBOutlet weak var concertView: UIView!
    @IBOutlet weak var foodView: UIView!
    @IBOutlet weak var clothesView: UIView!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var phoneView: UIView!
    override func viewDidLayoutSubviews() {
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 480:
                print("iPhone Classic")
            case 960:
                print("iPhone 4 or 4S")
                concertImage.contentMode = .scaleAspectFit
                foodImage.contentMode = .scaleAspectFit
                clothesImage.contentMode = .scaleAspectFit
                productImage.contentMode = .scaleAspectFit
                phoneImage.contentMode = .scaleAspectFit
                //reversed concert and phone background views
                concertView.center.x = phoneImage.center.x
                foodView.center.x = foodImage.center.x
                clothesView.center.x = clothesImage.center.x
                productView.center.x = productImage.center.x
                phoneView.center.x = concertImage.center.x
                
                
                
                
            case 1136:
                print("iPhone 5 or 5S or 5c")
            case 1334:
                print("iPhone 6 or 6s")
            case 2208:
                print("iPhone 6+ or 6S+")
            case 2436:
                print("this is te location of the login button \(loginButton.frame.origin.y)")
            default:
                print("unknown")
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 480:
                print("iPhone Classic")
            case 960:
                print("iPhone 4 or 4S")
              print(scrollView.frame.height)
                print(foodImage.frame.origin.y)
              concertImage.frame.size.height = 400
              foodImage.frame.origin.y = 100
              clothesImage.frame.origin.y = 50
              productImage.frame.size.height = 400
              phoneImage.frame.origin.y = 60
            case 1136:
                print("iPhone 5 or 5S or 5c")
            case 1334:
                print("iPhone 6 or 6s")
            case 2208:
                print("iPhone 6+ or 6S+")
            case 2436:
                print("this is te location of the login button \(loginButton.frame.origin.y)")
                loginButton.frame.origin.y = 734
                signUpButton.frame.origin.y = 734
                scrollView.frame.size.height = 727
                pageControl.frame.origin.y = 686
            default:
                print("unknown")
            }
        }
        concertView.isHidden = true
        foodView.isHidden = true
        clothesView.isHidden = true
        productView.isHidden = true
        phoneView.isHidden = true
        
        concertImage.clipsToBounds = true
        concertImage.contentMode = .scaleAspectFill
        
        foodImage.clipsToBounds = true
        foodImage.contentMode = .scaleAspectFill
        
        clothesImage.clipsToBounds = true
        clothesImage.contentMode = .scaleAspectFill
        
        productImage.clipsToBounds = true
        productImage.contentMode = .scaleAspectFill
        
        phoneImage.clipsToBounds = true
        phoneImage.contentMode = .scaleAspectFill
        
        
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        
        scrollView.delegate = self
        
        
        let screenHeight = scrollView.frame.height
        let screenWidth = UIScreen.main.bounds.width
        
        
        scrollView.contentSize.width = screenWidth * 5
        
        view.bringSubview(toFront: pageControl)
        
        concertImage.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        foodImage.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
        clothesImage.frame = CGRect(x: screenWidth * 2, y: 0, width: screenWidth, height: screenHeight)
        productImage.frame = CGRect(x: screenWidth * 3, y: 0, width: screenWidth, height: screenHeight)
        phoneImage.frame = CGRect(x: screenWidth * 4, y: 0, width: screenWidth, height: screenHeight)
        
        
        
        
        signUpButton.addTarget(self, action: #selector(signUserUp), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
    }
    
    func signUserUp(){
        performSegue(withIdentifier: "emailRegister", sender: self)
    }
    func goToLogin(){
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    func automaticScroll(){
         let screenWidth = UIScreen.main.bounds.width
        let point = CGPoint(x: scrollView.contentOffset.x  + screenWidth, y: 0)
        let pageNumber = round((scrollView.contentOffset.x / scrollView.frame.size.width) + 1)
        pageControl.set(progress: Int(pageNumber), animated: true)
        scrollView.setContentOffset(point, animated: true)
        if pageNumber == 5.0{
            let resetPoint = CGPoint(x: 0, y: 0)
            pageControl.set(progress: 0, animated: true)
            scrollView.setContentOffset(resetPoint, animated: true)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
     
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.set(progress: Int(pageNumber), animated: true)
     
    }
}
