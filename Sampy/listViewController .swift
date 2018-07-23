//
//  listViewController .swift
//  Sampy
//
//  Created by Omar Abbas on 6/4/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import NVActivityIndicatorView



class listViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UITextFieldDelegate, UIScrollViewDelegate {
    
    
        
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var activityCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var clothesAndSalesCollectionView: UICollectionView!
    
    @IBOutlet weak var viewForCell: UIView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var borderForButtons: UITextField!
    
    @IBOutlet weak var seeMoreFood: UIButton!
    @IBOutlet weak var seeMoreActivites: UIButton!
    @IBOutlet weak var seeMoreProducts: UIButton!
    @IBOutlet weak var seeMoreClothesAndSales: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var hrfeedbutton: UIButton!
    @IBOutlet weak var lockedFeedButton: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var clothesLabel: UILabel!
    @IBOutlet weak var activitiesLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    
    
    
    
    @IBOutlet weak var clothesBlackArrow: UIImageView!
    var foodArray = [MapPoints]()
    var activityArray = [MapPoints]()
    var productArray = [MapPoints]()
    var clothesandSalesArray = [MapPoints]()
    var seeMoreType = String()

   
    let Cell = "Cell"
    var selectedCollectionView = Int()
  
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.default
    }
   
    
    override func viewDidLoad() {
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
        
        containerView.isHidden = true
        
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 480:
                print("iPhone Classic")
            case 960:
                print("iPhone 4 or 4S")
              
                
                print(foodLabel.frame)
                print(foodCollectionView)
                print("now comes activites")
                print(activitiesLabel.frame)
                print(activityCollectionView.frame)
             // 36
                viewForCell.frame.size.width = 132
                viewForCell.frame.size.height = 187.5
             
                foodCollectionView.frame.size.height = 562.5
                activityCollectionView.frame.size.height = 562.5
                productCollectionView.frame.size.height = 562.5
                clothesAndSalesCollectionView.frame.size.height = 562.5
               // 15
                activitiesLabel.frame.origin.y = 658
                productLabel.frame.origin.y = 1271.5
                clothesLabel.frame.origin.y = 1885
                
                activityCollectionView.frame.origin.y = 694
                productCollectionView.frame.origin.y = 1307.5
                clothesAndSalesCollectionView.frame.origin.y = 1921
                
                seeMoreProducts.frame.origin.y = 658
                seeMoreActivites.frame.origin.y = 1271.5
                seeMoreClothesAndSales.frame.origin.y = 1885
                
            case 1136:
                print("iPhone 5 or 5S or 5c")
              
                viewForCell.frame.size.height = 187.5
                viewForCell.frame.size.width = 132.5
            case 1334:
                print("iPhone 6 or 6s")
            case 2208:
                print("iPhone 6+ or 6S+")
            
            case 2436:
                print("it is the iPhone X")

            viewForCell.frame.size.height = 205 //230
 
                self.hrfeedbutton.frame.origin.y = 45
                self.lockedFeedButton.frame.origin.y = 45
                self.borderForButtons.frame.origin.y = 45
                self.topView.frame.size.height = 75
                
              
            default:
                print("unknown")
            }
        }
        
        foodCollectionView.isScrollEnabled = false
        activityCollectionView.isScrollEnabled = false
        productCollectionView.isScrollEnabled = false
        clothesAndSalesCollectionView.isScrollEnabled = false
        lockedFeedButton.titleLabel?.adjustsFontSizeToFitWidth = true
        hrfeedbutton.titleLabel?.adjustsFontSizeToFitWidth = true
        let border = CALayer()
        
        let width = CGFloat(1.5) //1.5
        let greenColor = UIColor(red: 52/255, green: 179/255, blue: 187/255, alpha: 1)
        border.borderColor = greenColor.cgColor
        border.frame = CGRect(x: 0, y: borderForButtons.frame.size.height - width, width:  borderForButtons.frame.size.width, height: borderForButtons.frame.size.height)
        border.borderWidth = width
        
        borderForButtons.layer.addSublayer(border)

        definesPresentationContext = true
        
    
        //    let viewController = self.navigationController?.parent as? tabBarViewController
    
   
        hrfeedbutton.addTarget(self, action: #selector(hourFeedButtonPressed), for: .touchUpInside)
        lockedFeedButton.addTarget(self, action: #selector(lockedFeedButtonPressed), for: .touchUpInside)
     
        seeMoreFood.addTarget(self, action: #selector(seeMoreFoodFunction), for: .touchUpInside)
        seeMoreActivites.addTarget(self, action: #selector(seeMoreActivitesFunction), for: .touchUpInside)
        seeMoreProducts.addTarget(self, action: #selector(seeMoreProductsFunction), for: .touchUpInside)
        seeMoreClothesAndSales.addTarget(self, action: #selector(seeMoreClothesAndSalesFunction), for: .touchUpInside)
        
       
        foodCollectionView.register(PostCell.self, forCellWithReuseIdentifier: Cell)
        activityCollectionView.register(PostCell.self, forCellWithReuseIdentifier: Cell)
        productCollectionView.register(PostCell.self, forCellWithReuseIdentifier: Cell)
        clothesAndSalesCollectionView.register(PostCell.self, forCellWithReuseIdentifier: Cell)
        
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        
        activityCollectionView.delegate = self
        activityCollectionView.dataSource = self
        
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        clothesAndSalesCollectionView.delegate = self
        clothesAndSalesCollectionView.dataSource = self
        
        scrollView.contentSize.height = self.clothesAndSalesCollectionView.frame.origin.y + self.clothesAndSalesCollectionView.frame.height / 1.5
        scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        scrollView.delegate = self

        foodCollectionView.tag = 1
        activityCollectionView.tag = 2
        productCollectionView.tag = 3
        clothesAndSalesCollectionView.tag = 4
        
        
        
       
        foodArray.removeAll()
        activityArray.removeAll()
        productArray.removeAll()
        clothesandSalesArray.removeAll()
        
        foodCollectionView.reloadData()
        activityCollectionView.reloadData()
        productCollectionView.reloadData()
        clothesAndSalesCollectionView.reloadData()
        
        fetchUser()
        observeRemovedPosts()
  
    }
    func refreshProfile(){
        foodArray.removeAll()
        productArray.removeAll()
        activityArray.removeAll()
        clothesandSalesArray.removeAll()
        
        foodCollectionView.reloadData()
        activityCollectionView.reloadData()
        productCollectionView.reloadData()
        clothesAndSalesCollectionView.reloadData()
        
        fetchUser()
    }
   
    func loadTheView(){
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
  
       containerView.isHidden = true
        
        definesPresentationContext = true
       
       scrollView.contentSize.height = self.clothesAndSalesCollectionView.frame.origin.y + self.clothesAndSalesCollectionView.frame.height / 4
        scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        scrollView.delegate = self
        lockedFeedButton.titleLabel?.adjustsFontSizeToFitWidth = true
        hrfeedbutton.titleLabel?.adjustsFontSizeToFitWidth = true
    
        let border = CALayer()
        
        let width = CGFloat(1.5) //1.5
        let greenColor = UIColor(red: 52/255, green: 179/255, blue: 187/255, alpha: 1)
        border.borderColor = greenColor.cgColor
        border.frame = CGRect(x: 0, y: borderForButtons.frame.size.height - width, width:  borderForButtons.frame.size.width, height: borderForButtons.frame.size.height)
        border.borderWidth = width
        
        borderForButtons.layer.addSublayer(border)
        
        foodCollectionView.isScrollEnabled = false
        foodCollectionView.register(PostCell.self, forCellWithReuseIdentifier: Cell)
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        
        activityCollectionView.isScrollEnabled = false
        activityCollectionView.register(PostCell.self, forCellWithReuseIdentifier: Cell)
        activityCollectionView.delegate = self
        activityCollectionView.dataSource = self
        
        productCollectionView.isScrollEnabled = false
        productCollectionView.register(PostCell.self, forCellWithReuseIdentifier: Cell)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        clothesAndSalesCollectionView.isScrollEnabled = false
        clothesAndSalesCollectionView.register(PostCell.self, forCellWithReuseIdentifier: Cell)
        clothesAndSalesCollectionView.delegate = self
        clothesAndSalesCollectionView.dataSource = self
        
        seeMoreFood.addTarget(self, action: #selector(seeMoreFoodFunction), for: .touchUpInside)
        seeMoreActivites.addTarget(self, action: #selector(seeMoreActivitesFunction), for: .touchUpInside)
        seeMoreProducts.addTarget(self, action: #selector(seeMoreProductsFunction), for: .touchUpInside)
        seeMoreClothesAndSales.addTarget(self, action: #selector(seeMoreClothesAndSalesFunction), for: .touchUpInside)
        
        foodCollectionView.tag = 1
        activityCollectionView.tag = 2
        productCollectionView.tag = 3
        clothesAndSalesCollectionView.tag = 4
        
        foodArray.removeAll()
        activityArray.removeAll()
        productArray.removeAll()
        clothesandSalesArray.removeAll()
        
        foodCollectionView.reloadData()
        activityCollectionView.reloadData()
        productCollectionView.reloadData()
        clothesAndSalesCollectionView.reloadData()
        fetchUser()
        observeRemovedPosts()

    }
    func observeRemovedPosts(){
        
        let ref = Database.database().reference().child("SamplePost").child("post")
        // to limit it use this ref.queryLimited(toLast: 6)
        ref.queryOrdered(byChild: "post").observe(.childRemoved, with: {(snapshot) in
     self.refreshProfile()
        
        }, withCancel: nil)
    }
    func fetchUser(){
        foodCollectionView.reloadData()
        activityCollectionView.reloadData()
        productCollectionView.reloadData()
        clothesAndSalesCollectionView.reloadData()
    let ref = Database.database().reference().child("SamplePost").child("post")
      // to limit it use this ref.queryLimited(toLast: 6)
        ref.queryOrdered(byChild: "post").observe(.childAdded, with: {(snapshot) in
         
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let lat = dictionary["lat"] as! Double
                let long = dictionary["long"] as! Double
                let image = dictionary["image"] as! String
                let text = dictionary["text"] as! String
                let user = dictionary["user"] as! String
                let address = dictionary["postCity"] as! String
                let time = dictionary["time"] as! NSNumber
                let uid = dictionary["userUid"] as! String
                let viewCount = dictionary["viewCount"] as! NSNumber
                let type = dictionary["type"] as! String
                
                let structure = MapPoints(Latitude: lat, Longitude: long, Image: image, Text: text, User: user, PostCity: address, Time: time, userUID: uid, ViewCount: viewCount, Type: type)
                
                if structure.type == "Food"{
                    self.foodArray.append(structure)
                    self.foodArray.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                }
                
                if structure.type == "Activity"{
                    self.activityArray.append(structure)
                    self.activityArray.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                }
                
                if structure.type == "Product"{
                    self.productArray.append(structure)
                    self.productArray.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                }
                
                if structure.type == "Clothing"{
                    self.clothesandSalesArray.append(structure)
                    self.clothesandSalesArray.sort(by:{(message1, message2) -> Bool in
                        return (message1.time?.intValue)! > (message2.time?.intValue)!
                    })
                }
            
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
              //  self.refreshControl.endRefreshing()
                }
            }, withCancel: nil)
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
    func increaseArray(increaseAmountBy: Int ) -> Int{
         let emptyStructure = MapPoints(Latitude: 0, Longitude: 0, Image: "test", Text: "test", User: "test", PostCity: "test", Time: 0, userUID: "test", ViewCount: 0, Type: "test")
        for _ in 0..<(increaseAmountBy){
        
        foodArray.append(emptyStructure)
   
        }
        return foodArray.count
    }
    func increaseActivityArray(increaseAmountBy: Int ) -> Int{
        let emptyStructure = MapPoints(Latitude: 0, Longitude: 0, Image: "test", Text: "test", User: "test", PostCity: "test", Time: 0, userUID: "test", ViewCount: 0, Type: "test")
        for _ in 0..<(increaseAmountBy){
 
            activityArray.append(emptyStructure)
  
        }
        return activityArray.count
    }
    func increaseProductArray(increaseAmountBy: Int ) -> Int{
        let emptyStructure = MapPoints(Latitude: 0, Longitude: 0, Image: "test", Text: "test", User: "test", PostCity: "test", Time: 0, userUID: "test", ViewCount: 0, Type: "test")
        for _ in 0..<(increaseAmountBy){
         
            productArray.append(emptyStructure)
     
        }
        return productArray.count
    }
    func increaseClothesAndSalesArray(increaseAmountBy: Int ) -> Int{
        let emptyStructure = MapPoints(Latitude: 0, Longitude: 0, Image: "test", Text: "test", User: "test", PostCity: "test", Time: 0, userUID: "test", ViewCount: 0, Type: "test")
        for _ in 0..<(increaseAmountBy){
        
            clothesandSalesArray.append(emptyStructure)
            
        }
        return clothesandSalesArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        var count:Int?
        if collectionView == self.foodCollectionView {
            if foodArray.count < 6 {
                let amount = 6-foodArray.count
                count = increaseArray(increaseAmountBy: amount)
            }
         count = foodArray.count
        }
        if collectionView == self.activityCollectionView {
            if activityArray.count < 6 {
                let amount = 6-activityArray.count
                count = increaseActivityArray(increaseAmountBy: amount)
            }
           count = activityArray.count
        }
        if collectionView == self.productCollectionView{
            if productArray.count < 6 {
                let amount = 6-productArray.count
                count = increaseProductArray(increaseAmountBy: amount)
            }
            count = productArray.count
        }
        if collectionView == self.clothesAndSalesCollectionView{
            if clothesandSalesArray.count < 6 {
                let amount = 6-clothesandSalesArray.count
                count = increaseClothesAndSalesArray(increaseAmountBy: amount)
            }
            count = clothesandSalesArray.count
        }
        return count!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: viewForCell.frame.width, height: viewForCell.frame.height )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 31)
        return UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 36) //16
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PostCell
        
        if collectionView == self.foodCollectionView{
            
            let postInformation: MapPoints
        
            postInformation = foodArray[indexPath.row]
            if postInformation.text == "test"{
                cell.isUserInteractionEnabled = false
                
                cell.postImage.image = UIImage(named:"noPostToShow")
                cell.userCity.text = "Anywhere"
                cell.userDescription.text = "Click on the post button below!"
                cell.postTime.text = "Anytime"
                
            }else{
     
            cell.isUserInteractionEnabled = true
            cell.userDescription.text = postInformation.text
            cell.userCity.text = postInformation.postCity
            
            let time = postInformation.time?.doubleValue
            let postTimeInterval = Date(timeIntervalSince1970: time!)
            cell.activityIndicator.frame.origin.x = cell.center.x
            cell.activityIndicator.frame.origin.y = cell.postImage.center.y
                
            cell.postTime.text = self.timeAgoStringFromDate(date: postTimeInterval)!
            cell.postImage.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: cell.activityIndicator)
            }
        }
        if collectionView == self.activityCollectionView{
    
            let postInformation: MapPoints
           
            postInformation = activityArray[indexPath.row]
            if postInformation.text == "test"{
                cell.isUserInteractionEnabled = false
                
                cell.postImage.image = UIImage(named:"noPostToShow")
                cell.userCity.text = "Anywhere"
                cell.userDescription.text = "Click on the post button below!"
                cell.postTime.text = "Anytime"
                
            }else{
            cell.isUserInteractionEnabled = true
            cell.userDescription.text = postInformation.text
            cell.userCity.text = postInformation.postCity
            
            let time = postInformation.time?.doubleValue
            let postTimeInterval = Date(timeIntervalSince1970: time!)
            
            cell.postTime.text = self.timeAgoStringFromDate(date: postTimeInterval)!
            cell.postImage.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: cell.activityIndicator)
           
            }
        }
        if collectionView == self.productCollectionView{
     
            let postInformation: MapPoints
            
            postInformation = productArray[indexPath.row]
            if postInformation.text == "test"{
                cell.isUserInteractionEnabled = false
                
                cell.postImage.image = UIImage(named:"noPostToShow")
                cell.userCity.text = "Anywhere"
                cell.userDescription.text = "Click on the post button below!"
                cell.postTime.text = "Anytime"
                
            }else{
            cell.isUserInteractionEnabled = true
            cell.userDescription.text = postInformation.text
            cell.userCity.text = postInformation.postCity
            
            let time = postInformation.time?.doubleValue
            let postTimeInterval = Date(timeIntervalSince1970: time!)
            
            cell.postTime.text = self.timeAgoStringFromDate(date: postTimeInterval)!
            cell.postImage.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: cell.activityIndicator)
            
            }
        }
        if collectionView == self.clothesAndSalesCollectionView {
            let postInformation: MapPoints
            
                postInformation = clothesandSalesArray[indexPath.row]
            if postInformation.text == "test"{
                cell.isUserInteractionEnabled = false
                
                cell.postImage.image = UIImage(named:"noPostToShow")
                cell.userCity.text = "Anywhere"
                cell.userDescription.text = "Click on the post button below!"
                cell.postTime.text = "Anytime"
                
            }else{
            cell.isUserInteractionEnabled = true
            cell.userDescription.text = postInformation.text
            cell.userCity.text = postInformation.postCity
            
            let time = postInformation.time?.doubleValue
            let postTimeInterval = Date(timeIntervalSince1970: time!)
            
            cell.postTime.text = self.timeAgoStringFromDate(date: postTimeInterval)!
            cell.postImage.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: cell.activityIndicator)
          
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        if collectionView == self.foodCollectionView {
            
            self.selectedCollectionView = foodCollectionView.tag
            Answers.logCustomEvent(withName: "user selected 24hr sample of food for more information inside listViewController", customAttributes: [:])
            performSegue(withIdentifier: "openPost", sender: self)
        }
        
        if collectionView == self.activityCollectionView {
            
            self.selectedCollectionView = activityCollectionView.tag
            Answers.logCustomEvent(withName: "user selected 24hr sample of activites for more information inside listViewController", customAttributes: [:])
            performSegue(withIdentifier: "openPost", sender: self)
        }
        
        if collectionView == self.productCollectionView{
            
            self.selectedCollectionView = productCollectionView.tag
            Answers.logCustomEvent(withName: "user selected 24hr sample of products for more information inside listViewController", customAttributes: [:])
            performSegue(withIdentifier: "openPost", sender: self)
        }
        
        if collectionView == self.clothesAndSalesCollectionView{
            
            self.selectedCollectionView = clothesAndSalesCollectionView.tag
            Answers.logCustomEvent(withName: "user selected 24hr sample of clothes & sales for more information inside listViewController", customAttributes: [:])
            performSegue(withIdentifier: "openPost", sender: self)
        }
    }
      var timer: Timer?
    func handleReloadTable(){
        self.foodCollectionView.reloadData()
        self.activityCollectionView.reloadData()
        self.productCollectionView.reloadData()
        self.clothesAndSalesCollectionView.reloadData()
    }
    
  
    func hideKeyboardOnSwipeUp(){
        view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if segue.identifier == "openPost" {
            
            if self.selectedCollectionView == 1{
              self.selectedCollectionView = 0
              let indexPath = foodCollectionView.indexPathsForSelectedItems?.last
              let selectedInformation: MapPoints
                
                selectedInformation = foodArray[(indexPath?.row)!]
            
              let viewController = segue.destination as! openingPostViewController
              viewController.selectedInformation = selectedInformation
            }
            if self.selectedCollectionView == 2{
                self.selectedCollectionView = 0
                let indexPath = activityCollectionView.indexPathsForSelectedItems?.last
                let selectedInformation: MapPoints
                
                selectedInformation = activityArray[(indexPath?.row)!]
                
                let viewController = segue.destination as! openingPostViewController
                viewController.selectedInformation = selectedInformation
            }
            if self.selectedCollectionView == 3{
                self.selectedCollectionView = 0
                let indexPath = productCollectionView.indexPathsForSelectedItems?.last
                let selectedInformation: MapPoints
                
                selectedInformation = productArray[(indexPath?.row)!]
                
                let viewController = segue.destination as! openingPostViewController
                viewController.selectedInformation = selectedInformation
            }
            if self.selectedCollectionView == 4{
                self.selectedCollectionView = 0
                let indexPath = clothesAndSalesCollectionView.indexPathsForSelectedItems?.last
                let selectedInformation: MapPoints
                
                selectedInformation = clothesandSalesArray[(indexPath?.row)!]
                
                let viewController = segue.destination as! openingPostViewController
                viewController.selectedInformation = selectedInformation
                
            }
        }
        if segue.identifier == "showMore"{
        
            let viewController = segue.destination as! seeMore
            viewController.filterType = seeMoreType
           
            viewController.heightForViewForCell = viewForCell.frame.height
            viewController.widthForViewForCell = viewForCell.frame.width
            
            
        }
    }
    func lockedFeedButtonPressed(){
 
        UIView.animate(withDuration: 0.35){
            self.containerView.isHidden = false
            self.borderForButtons.center.x = self.lockedFeedButton.center.x
        }
    }

    func hourFeedButtonPressed(){
          UIView.animate(withDuration: 0.35){
           self.containerView.isHidden = true
           self.borderForButtons.center.x = self.hrfeedbutton.center.x
        }
    }
    
    func seeMoreFoodFunction(){
         seeMoreType = "Food"
    performSegue(withIdentifier: "showMore", sender: self)
       
    }
    func seeMoreActivitesFunction(){
        seeMoreType = "Activity"
        performSegue(withIdentifier: "showMore", sender: self)
  
    }
    func seeMoreProductsFunction(){
        seeMoreType = "Product"
        performSegue(withIdentifier: "showMore", sender: self)

    }
    func seeMoreClothesAndSalesFunction(){
        seeMoreType = "Clothing"
        performSegue(withIdentifier: "showMore", sender: self)

    }
    
    func increaseViewCount(postUid: String, time: NSNumber){
       
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
            if postUid == uid {
       
            }else{
            let postRef = Database.database().reference().child("HistoryOfPosts").child("post")
                postRef.queryOrdered(byChild: "time").queryEqual(toValue: time).observeSingleEvent(of: .childAdded, with: {(snapshot) in
                    let id = snapshot.key
                    let dictionary = snapshot.value as? [String: AnyObject]
                    let valString = dictionary?["viewCount"] as! NSNumber
                    let number = valString 
                    var value = number.intValue
                    value = value + 1
                    let updateRef = Database.database().reference().child("HistoryOfPosts").child("post").child(id).child("viewCount")
                    updateRef.setValue(value)
                        
                    
                })
            }
    }
   
  func timeAgoStringFromDate(date: Date) -> String? {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .full
    
    let now = Date()
    
    let calendar = Calendar.current
    
    let components = calendar.dateComponents([.year,.month,.weekOfMonth,.day,.hour,.minute,.second], from: date, to: now)
  
    
    
    if components.year! > 0 {
    formatter.allowedUnits = .year
    } else if components.month! > 0 {
    formatter.allowedUnits = .month
    } else if components.weekOfMonth! > 0 {
    formatter.allowedUnits = .weekOfMonth
    } else if components.day! > 0 {
    formatter.allowedUnits = .day
    } else if components.hour! > 0 {
    formatter.allowedUnits = .hour
    } else if components.minute! > 0 {
    formatter.allowedUnits = .minute
    } else {
    formatter.allowedUnits = .second
    }
    
    let formatString = NSLocalizedString("%@ ago", comment: "Used to say how much time has passed. e.g. '2 hours ago'")
    
    guard let timeString = formatter.string(from: components) else {
    return nil
    }
    return String(format: formatString, timeString)
        }
    }

