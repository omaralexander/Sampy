//
//  compileAndPermaPost.swift
//  Sampy
//
//  Created by Omar Abbas on 10/11/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import BEMCheckBox
import CoreLocation
import NotificationBannerSwift

class compileAndPermaPost: UIViewController,BEMCheckBoxDelegate {
    
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var enteredWebLink: UITextField!
    @IBOutlet weak var enteredDescription: UITextView!
    @IBOutlet weak var enteredName: UITextField!
    @IBOutlet weak var enteredAddress: UITextField!
    @IBOutlet weak var enteredCategory: UITextField!
    
    @IBOutlet weak var uploadPost: UIButton!
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }

    
    @IBOutlet weak var backButtonImage: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    var passedImage: UIImage!
    var passedName = String()
    var passedWebLink = String()
    var passedCategory = String()
    var passedAddress = String()
    var passedDescription = String()
    var passedLat = String()
    var passedLong = String()
    var statusBarShouldBeHidden = Bool()
 
    
    @IBOutlet weak var scrollView: UIScrollView!
    
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
         
                backButtonImage.frame.origin.y = 50
                dismissButton.frame.origin.y = 38
                self.statusBarShouldBeHidden = false
                setNeedsStatusBarAppearanceUpdate()
                
            default:
                print("unknown")
            }
        }
       
        imagePost.layer.cornerRadius = 5
      
        imagePost.image = passedImage
        enteredWebLink.text = passedWebLink
        enteredDescription.text = passedDescription
        enteredName.text = passedName
        enteredAddress.text = passedAddress
        enteredCategory.text = passedCategory
        
        
        uploadPost.addTarget(self, action: #selector(sendPost), for: .touchUpInside)
   
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToStart" {
            let viewController = segue.destination as! permaPostViewController
            viewController.imagePost.image = UIImage(named: "noImageInHere")
            viewController.passedName = ""
            viewController.passedWebLink = ""
            viewController.passedCategory = ""
            viewController.passedAddress = ""
            viewController.passedLat = ""
            viewController.passedLong = ""
            viewController.passedDescription = ""
        }
        if segue.identifier == "backToDescription" {
            let viewController = segue.destination as! postDescription
            viewController.passedImage = passedImage
            viewController.passedName = passedName
            viewController.passedWebLink = passedWebLink
            viewController.passedCategory = passedCategory
            viewController.passedAddress = passedAddress
            viewController.passedLat = passedLat
            viewController.passedLong = passedLong
            viewController.passedDescription = passedDescription
        }
    }
    func sendPost(){
        
        let banner = StatusBarNotificationBanner(title: "Hang tight, we're uploading your post!", style: .warning)
        banner.show()
        banner.autoDismiss = false
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("PermaPost_Images").child("\(imageName).jpg")
       
                if let uploadData = UIImagePNGRepresentation(passedImage!){
                     self.performSegue(withIdentifier: "backToStart", sender: self)
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
                            
                            let ref = Database.database().reference().child("PermaPost").child("post")
                            let childRef = ref.childByAutoId()
                            let description = self.passedDescription
                            let lat = Double(self.passedLat)
                            let long = Double(self.passedLong)
                            let time = NSDate().timeIntervalSince1970
                            let website = self.passedWebLink
                            let name = self.passedName
                            let city = CLGeocoder()
                            let coordinates = CLLocation(latitude: lat!, longitude: long!)
                            city.reverseGeocodeLocation(coordinates, completionHandler: {(placemarks, error) -> Void in
                                if error != nil {
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
                                
                                var state = String()
                                var city = String()
                                var textArray = [String]()
                                
                                if lat == Double(0) && lat == Double(0){
                                    state = "only"
                                    city = "Online"
                                    textArray = [city," ",state]
                                }else{
                                    state = placeMark.addressDictionary?["State"] as! String
                                    city = placeMark.addressDictionary?["City"] as! String
                                    textArray = [city,", ",state]
                                }
                       
                                
                                
                                let location = textArray.joined()
                            
                                let type = self.passedCategory
                            
                                let deviceID = UIDevice.current.identifierForVendor?.uuidString
                            
                                
                                let values = ["type":type as Any,"location":location as Any,"companyName":name as Any,"companyWebsite":website as Any,"lat":lat as Any,"long":long as Any,"description":description as Any,"time":time,"companyImage":profileImageUrl,"deviceID":deviceID as Any] as [String: Any]
                            
                            childRef.updateChildValues(values, withCompletionBlock: {(error, ref) in
                                if error != nil{
                                    print(error?.localizedDescription as Any)
                                    let errorBanner = NotificationBanner(title: "Error uploading your post",
                                                                         subtitle: error?.localizedDescription,
                                                                         style: .danger)
                                    errorBanner.show()
                                    return
                                }
                                self.decreasePostCredits()
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
   
    override func viewDidLayoutSubviews() {
        let contentSize = self.enteredDescription.sizeThatFits(self.enteredDescription.bounds.size)
        var frame = self.enteredDescription.frame
        frame.size.height = contentSize.height
        self.enteredDescription.frame = frame
        self.enteredDescription.isScrollEnabled = false
        
        self.scrollView.contentSize.height = self.enteredDescription.frame.origin.y + self.enteredDescription.frame.height + self.uploadPost.frame.height
    }
    func decreasePostCredits(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in

            let dictionary = snapshot.value as? [String: AnyObject]
            let valString = dictionary?["postCredit"] as! NSNumber
            let number = valString
            var value = number.intValue
            value = value - 1
            let updateRef = Database.database().reference().child("Users").child(uid).child("postCredit")
            updateRef.setValue(value)
            
        })
    }
}
