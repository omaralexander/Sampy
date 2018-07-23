//
//  compileAndPost.swift
//  Sampy
//
//  Created by Omar Abbas on 10/7/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import NVActivityIndicatorView
import BEMCheckBox
import NotificationBannerSwift

class compileAndPost: UIViewController,CLLocationManagerDelegate{
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var uploadPost: UIButton!
    
    @IBOutlet var noLocationErrorView: UIView!
    @IBOutlet weak var goToSettingsButton: UIButton!
    
    @IBOutlet weak var alertLabel: UILabel!
  
    @IBOutlet weak var scrollView: UIScrollView!
 
    @IBOutlet weak var closeNoLocationErrorView: UIButton!
    
    let manager = CLLocationManager()
    var user = String()
    
    var imagePassedOver: UIImage!
    var theSelectedCategory = String()
    var descriptionString = String()
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.loadTheView()
    }
    func loadTheView(){
        self.manager.delegate = self
        
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                print("")
                   uploadPost.frame.origin.y = 707
           
            default:
                print("unknown")
            }
        }
        switch CLLocationManager.authorizationStatus(){
            
        case.authorizedWhenInUse:
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest;
            manager.startUpdatingLocation()
            
            self.noLocationErrorView.frame = CGRect(x: noLocationErrorView.frame.origin.x, y: noLocationErrorView.frame.origin.y, width: UIScreen.main.bounds.width - 16, height: noLocationErrorView.frame.height)
            
            self.noLocationErrorView.layer.cornerRadius = 14
         
            self.imagePost.contentMode = .scaleAspectFit
            self.imagePost.layer.cornerRadius = 5
    
            self.imagePost.image = imagePassedOver
            self.categoryLabel.text = "This is a \(theSelectedCategory)"
            self.descriptionTextView.text = descriptionString
            
            goToSettingsButton.titleLabel?.adjustsFontSizeToFitWidth = true
            
            self.goToSettingsButton.layer.cornerRadius = 5
            closeNoLocationErrorView.addTarget(self, action: #selector(goBack), for: .touchUpInside)
           
            
            
            self.goToSettingsButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
            self.uploadPost.addTarget(self, action: #selector(sendPost), for: .touchUpInside)
         
            
            
            break
        case.notDetermined:
            self.noLocationErrorView.layer.cornerRadius = 14
            
             closeNoLocationErrorView.addTarget(self, action: #selector(goBack), for: .touchUpInside)
            self.goToSettingsButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
            
            manager.delegate = self
            manager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            manager.delegate = self
            
             self.noLocationErrorView.layer.cornerRadius = 14
             closeNoLocationErrorView.addTarget(self, action: #selector(goBack), for: .touchUpInside)
            self.goToSettingsButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
            self.animateNoLocation()
            break
        default:print("nothing to do here")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.manager.delegate = self
        
        switch status {
        case.authorizedWhenInUse:
            
            self.animateNoLocationOut()
            self.loadTheView()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest;
            manager.startUpdatingLocation()
            
            if self.manager.location == nil{
                self.manager.requestLocation()
            }else{
                
                //what to put here if location comes up good
                
            }
            break
        case.notDetermined:
            self.manager.delegate = self
            self.manager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
           closeNoLocationErrorView.addTarget(self, action: #selector(goBack), for: .touchUpInside)
            self.animateNoLocation()
            
            break
        default: self.manager.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.first != nil{
            manager.requestLocation()
        } else {
            
            manager.desiredAccuracy = kCLLocationAccuracyBest;
            manager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    func goBack(){
        performSegue(withIdentifier: "backToWriteMore", sender: self)
    }
    func animateNoLocation(){
        self.view.addSubview(noLocationErrorView)
        noLocationErrorView.center = self.view.center
        noLocationErrorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        noLocationErrorView.alpha = 0
        UIView.animate(withDuration: 0.4){
           
            self.noLocationErrorView.alpha = 1
            self.noLocationErrorView.transform = CGAffineTransform.identity
        }
        
    }
    func animateNoLocationOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.noLocationErrorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.noLocationErrorView.alpha = 0
            
        }){(success:Bool) in
            self.noLocationErrorView.removeFromSuperview()
        }
    }
    func goToSettings(){
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    func updateUserLocationForPost(){
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestLocation()
    }
    func getUserName(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.observeSingleEvent(of:.value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                self.user = dictionary["username"] as! String
            }
        }, withCancel: nil)
    }

    func sendPost(){
  
        updateUserLocationForPost()
        let defaultImage = UIImage(named: "takeAPhoto")
        if imagePost.image == defaultImage{
            
        alertLabel.text = "An image is required to post"
        } else{
         if descriptionString == "The greatest post in the history of all posts can be the one you write in here" || descriptionString == "" || theSelectedCategory == "" {
            if theSelectedCategory == "" {
                alertLabel.text = "You have to select a category"
            }else{
            
          alertLabel.text = "You have to write a description"
            
            }
         }
         else{
       
            getUserName()
            let banner = StatusBarNotificationBanner(title: "Hang tight, we're uploading your post!", style: .warning)
            banner.show()
            banner.autoDismiss = false
     
            
           let currentcoordinate = manager.location
          let city = CLGeocoder()
           
            let imageName = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("Post_Images").child("\(imageName).jpg")
            self.performSegue(withIdentifier: "backToTakePhoto", sender: self)
            
            
            if let uploadData = UIImagePNGRepresentation(imagePost.image!){
                storageRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
                    if error != nil{
                        print(error?.localizedDescription as Any)
                        
                        let errorBanner = NotificationBanner(title: "Error uploading your post",
                                                             subtitle: error?.localizedDescription,
                                                             style: .danger)
                        errorBanner.show()
                        
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                        guard let uid = Auth.auth().currentUser?.uid else{
                            return
                        }
                        
                        city.reverseGeocodeLocation(currentcoordinate!, completionHandler: {(placemarks, error) -> Void in
                            
                            if error != nil{
                                print(error?.localizedDescription as Any)
                                let errorBanner = NotificationBanner(title: "Error uploading your post",
                                                                subtitle: error?.localizedDescription,
                                                                style: .danger)
                                errorBanner.show()
                                return
                            }
                            
                            let placeArray = placemarks as [CLPlacemark]!
                            var placeMark: CLPlacemark
                            placeMark = (placeArray?[0])!
                            
                            let ref = Database.database().reference().child("SamplePost").child("post")
                            let userRef = Database.database().reference().child("HistoryOfPosts").child("post")
                            let childRef = ref.childByAutoId()
                            let userChildRef = userRef.childByAutoId()
                            let caption = self.descriptionString
                            let category = self.theSelectedCategory
                            let time = NSDate().timeIntervalSince1970
                            let city = placeMark.addressDictionary?["City"] as! String
                            let state = placeMark.addressDictionary?["State"] as! String
                            //let country = placeMark.addressDictionary?["Country"] as! String
                            let textArray = [city,", ",state]
                            let userAddress = textArray.joined()
                            let latAsString:Double? = self.manager.location?.coordinate.latitude
                            let longAsString:Double? = self.manager.location?.coordinate.longitude
                            let userUid = uid
                            let viewCount = 0
                            
                            let values = ["text":caption as Any,"lat":latAsString,"long":longAsString,"image":profileImageUrl,"user":self.user,"postCity":userAddress,"time":time,"userUid":userUid,"viewCount":viewCount,"type":category] as [String: Any]
                            childRef.updateChildValues(values, withCompletionBlock: {(error, ref) in
                                if error != nil{
                                    print(error?.localizedDescription as Any)
                                    return
                                }
                                let sampleRecipientRef = Database.database().reference().child("user-posts").child(uid)
                                let sampleId = childRef.key
                                sampleRecipientRef.updateChildValues([sampleId:1])
                                
                            })
                            userChildRef.updateChildValues(values, withCompletionBlock: {(error, ref) in
                                if error != nil {
                                    print(error?.localizedDescription as Any)
                                    let errorBanner = NotificationBanner(title: "Error uploading your post",
                                                                         subtitle: error?.localizedDescription,
                                                                         style: .danger)
                                    errorBanner.show()
                                    return
                                }
                                let historyRef = Database.database().reference().child("user-history-posts").child(uid)
                                let historyId = userChildRef.key
                                historyRef.updateChildValues([historyId:1])
                                banner.dismiss()
                   
                                let greenBanner = NotificationBanner(title: "Post successfully uploaded!",
                                                                subtitle: "You can see your post in the feed",
                                                                style: .success)
                                greenBanner.show()
                                
                            })
                        })
                    }
                })
            }
        }
    }
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToTakePhoto" {
            let viewController = segue.destination as! makeAPostViewController
            viewController.descriptionString = ""
            viewController.theSelectedCatagory = ""
            viewController.makeAPostImage.image = UIImage(named: "takeAPhoto")
            viewController.tag = 1
            
        }
        if segue.identifier == "backToWriteMore"{
            let viewController = segue.destination as! writeABitMore
            viewController.theSelectedCategory = theSelectedCategory
            viewController.descriptionString = descriptionString
            viewController.imagePassedOver = imagePassedOver
        }
    }
    override func viewDidLayoutSubviews() {
        let contentSize = self.descriptionTextView.sizeThatFits(self.descriptionTextView.bounds.size)
        var frame = self.descriptionTextView.frame
        frame.size.height = contentSize.height
        self.descriptionTextView.frame = frame
        self.descriptionTextView.isScrollEnabled = false
        
        self.scrollView.contentSize.height = self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.height + self.uploadPost.frame.height
    }
}
