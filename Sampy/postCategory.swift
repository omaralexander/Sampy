//
//  postCategory.swift
//  Sampy
//
//  Created by Omar Abbas on 10/11/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit

class postCategory: UIViewController {
    
    
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var productButton: UIButton!
    @IBOutlet weak var activityButton: UIButton!
    @IBOutlet weak var clothingButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var alertLabel: UILabel!
    override var prefersStatusBarHidden: Bool{
        return statusBarShouldBeHidden
    }
    @IBAction func backToWriteACategory(segue:UIStoryboardSegue){
        
    }
    
    var greenColor = UIColor(red: 52/255, green: 178/255, blue: 187/255, alpha: 1)
    var blackColor = UIColor(red: 59/255, green: 61/255, blue: 62/255, alpha: 1)
    
    
    var imagePassedOver: UIImage!
    var passedName = String()
    var passedWebLink = String()
    var theSelectedCategory = String()
    var passedAddress = String()
    var passedOverDescription = String()
    var passedLat = String()
    var passedLong = String()
    var statusBarShouldBeHidden = Bool()
    
    @IBOutlet weak var backButtonImage: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    
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
        nextButton.layer.cornerRadius = 5
        
        
        foodButton.backgroundColor = UIColor.lightGray
        foodButton.layer.opacity = 0.7
        
        productButton.backgroundColor = UIColor.lightGray
        productButton.layer.opacity = 0.7
        
        
        activityButton.backgroundColor = UIColor.lightGray
        activityButton.layer.opacity = 0.7
        
        clothingButton.backgroundColor = UIColor.lightGray
        clothingButton.layer.opacity = 0.7
        
        foodButton.addTarget(self, action: #selector(foodButtonSelected), for: .touchUpInside)
        productButton.addTarget(self, action: #selector(productButtonSelected), for: .touchUpInside)
        activityButton.addTarget(self, action: #selector(activityButtonSelected), for: .touchUpInside)
        clothingButton.addTarget(self, action: #selector(clothingButtonSelected), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonFunction), for: .touchUpInside)
        
        alertLabel.isHidden = true
        
        
        
        if theSelectedCategory == "Food" {
            clothingButton.layer.opacity = 0.7
            activityButton.layer.opacity = 0.7
            productButton.layer.opacity = 0.7
            foodButton.layer.opacity = 1
            
            foodButton.backgroundColor = greenColor
            productButton.backgroundColor = UIColor.lightGray
            activityButton.backgroundColor = UIColor.lightGray
            clothingButton.backgroundColor = UIColor.lightGray
        }
        if theSelectedCategory == "Product" {
            clothingButton.layer.opacity = 0.7
            activityButton.layer.opacity = 0.7
            productButton.layer.opacity = 1
            foodButton.layer.opacity = 0.7
            foodButton.backgroundColor = UIColor.lightGray
            productButton.backgroundColor = greenColor
            activityButton.backgroundColor = UIColor.lightGray
            clothingButton.backgroundColor = UIColor.lightGray
        }
        if theSelectedCategory == "Activity" {
            clothingButton.layer.opacity = 0.7
            activityButton.layer.opacity = 1
            productButton.layer.opacity = 0.7
            foodButton.layer.opacity = 0.7
            foodButton.backgroundColor = UIColor.lightGray
            productButton.backgroundColor = UIColor.lightGray
            activityButton.backgroundColor = greenColor
            clothingButton.backgroundColor = UIColor.lightGray
        }
        if theSelectedCategory == "Clothing" {
            clothingButton.layer.opacity = 1
            activityButton.layer.opacity = 0.7
            productButton.layer.opacity = 0.7
            foodButton.layer.opacity = 0.7
            foodButton.backgroundColor = UIColor.lightGray
            productButton.backgroundColor = UIColor.lightGray
            activityButton.backgroundColor = UIColor.lightGray
            clothingButton.backgroundColor = greenColor
        }
        
        
        
    }
    
    func nextButtonFunction(){
        if theSelectedCategory != ""{
            alertLabel.isHidden = true
        performSegue(withIdentifier: "moveToAddress", sender: self)
        } else {
            alertLabel.isHidden = false
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToWebLink" {
            let viewController = segue.destination as! postWebLink
          
            viewController.passedImage = imagePassedOver
            viewController.passedName = passedName
            viewController.passedWebLink = passedWebLink
            viewController.passedCategory = theSelectedCategory
            viewController.passedAddress = passedAddress
            viewController.passedLat = passedLat
            viewController.passedLong = passedLong
            viewController.passedDescription = passedOverDescription
        }
        if segue.identifier == "moveToAddress" {
            let viewController = segue.destination as! postAddress
            
            viewController.passedImage = imagePassedOver
            viewController.passedName = passedName
            viewController.passedWebLink = passedWebLink
            viewController.passedCategory = theSelectedCategory
            viewController.passedAddress = passedAddress
            viewController.passedLat = passedLat
            viewController.passedLong = passedLong
            viewController.passedDescription = passedOverDescription
            
        }
    }
    func foodButtonSelected(){
        clothingButton.layer.opacity = 0.7
        activityButton.layer.opacity = 0.7
        productButton.layer.opacity = 0.7
        foodButton.layer.opacity = 1
        
        
        
        foodButton.backgroundColor = greenColor
        productButton.backgroundColor = UIColor.lightGray
        activityButton.backgroundColor = UIColor.lightGray
        clothingButton.backgroundColor = UIColor.lightGray
        theSelectedCategory = "Food"
    }
    func productButtonSelected(){
        clothingButton.layer.opacity = 0.7
        activityButton.layer.opacity = 0.7
        productButton.layer.opacity = 1
        foodButton.layer.opacity = 0.7
        foodButton.backgroundColor = UIColor.lightGray
        productButton.backgroundColor = greenColor
        activityButton.backgroundColor = UIColor.lightGray
        clothingButton.backgroundColor = UIColor.lightGray
        theSelectedCategory = "Product"
    }
    func activityButtonSelected(){
        clothingButton.layer.opacity = 0.7
        activityButton.layer.opacity = 1
        productButton.layer.opacity = 0.7
        foodButton.layer.opacity = 0.7
        foodButton.backgroundColor = UIColor.lightGray
        productButton.backgroundColor = UIColor.lightGray
        activityButton.backgroundColor = greenColor
        clothingButton.backgroundColor = UIColor.lightGray
        theSelectedCategory = "Activity"
    }
    func clothingButtonSelected(){
        clothingButton.layer.opacity = 1
        activityButton.layer.opacity = 0.7
        productButton.layer.opacity = 0.7
        foodButton.layer.opacity = 0.7
        foodButton.backgroundColor = UIColor.lightGray
        productButton.backgroundColor = UIColor.lightGray
        activityButton.backgroundColor = UIColor.lightGray
        clothingButton.backgroundColor = greenColor
        theSelectedCategory = "Clothing"
    }
}
