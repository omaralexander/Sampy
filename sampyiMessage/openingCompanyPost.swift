//
//  openingCompanyPost.swift
//  sampyiMessage
//
//  Created by Omar Abbas on 11/20/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import Firebase
import Canvas
import Messages
import WebKit
import CoreLocation

class openingCompanyPost: MSMessagesAppViewController,UIScrollViewDelegate, WKNavigationDelegate {
    @IBOutlet weak var glanceView: UIView!
    @IBOutlet weak var borderAboveDescription: UITextField!
    @IBOutlet weak var borderBelowMap: UITextField!
 
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var activityIndicatorSelectedImage: NVActivityIndicatorView!
    @IBOutlet weak var userNameSelected: UILabel!
    @IBOutlet weak var userPostDescription: UITextView!
    @IBOutlet weak var locationOfPost: UILabel!
    @IBOutlet weak var aboutUsersPost: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var selectedScrollView: UIScrollView!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var activityIndicatorProfilepicture: NVActivityIndicatorView!
    @IBOutlet weak var glanceLabel: UILabel!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var viewForSelectedPost: UIView!
    
    @IBOutlet weak var mainView: UIView!
    
   
    @IBAction func dismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    var selectedInformation: CompanyValues?
    var locationTextArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.layer.cornerRadius = 5
        let border = CALayer()
        
        let width = CGFloat(1.0) //1.5
        
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: borderAboveDescription.frame.size.height - width, width:  borderAboveDescription.frame.size.width, height: borderAboveDescription.frame.size.height)
        border.borderWidth = width
        border.opacity = 0.7
        borderAboveDescription.layer.addSublayer(border)
        
        let belowMap = CALayer()
        let belowMapWidth = CGFloat(1.0)
        
        belowMap.borderColor = UIColor.lightGray.cgColor
        belowMap.frame = CGRect(x: 0, y: borderBelowMap.frame.size.height - belowMapWidth, width:  borderBelowMap.frame.size.width, height: borderBelowMap.frame.size.height)
        belowMap.borderWidth = belowMapWidth
        belowMap.opacity = 0.7
        borderBelowMap.layer.addSublayer(belowMap)
        
       
        shareButton.addTarget(self, action: #selector(sharePost), for: .touchUpInside)
        
        if selectedInformation?.location == "Online only" {
    
            activityIndicator.isHidden = false
       

            let webView = WKWebView()
            
            glanceLabel.text = "Web glance: "
            webView.frame = glanceView.frame
            webView.navigationDelegate = self
            selectedScrollView.addSubview(webView)
            selectedScrollView.bringSubview(toFront: webView)
            selectedScrollView.bringSubview(toFront: activityIndicator)
            activityIndicator.startAnimating()
            let url = URL(string: (selectedInformation?.companyWebsite)!)
            let request = URLRequest(url: url!)
            webView.load(request)
            
        }else{
            activityIndicator.isHidden = true
           
            let lat = selectedInformation?.lat
            let long = selectedInformation?.long
            let city = CLGeocoder()
            let coordinates = CLLocation(latitude: lat!, longitude: long!)
            city.reverseGeocodeLocation(coordinates, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }
                let placeArray = placemarks as [CLPlacemark]!
                var placeMark: CLPlacemark
                placeMark = (placeArray?[0])!
                
                var state = String()
                var city = String()
                var name = String()
                
                state = placeMark.addressDictionary?["State"] as! String
                city = placeMark.addressDictionary?["City"] as! String
                name = placeMark.addressDictionary?["Name"] as! String
                
                self.locationTextArray = [name,", ",city,", ",state]
                self.locationOfPost.text = self.locationTextArray.joined()
                if self.selectedInformation?.companyWebsite != "" {
                    self.activityIndicator.isHidden = false
                    
                    
                    let webView = WKWebView()
                    
                    self.glanceLabel.text = "Web glance: "
                    webView.frame = self.glanceView.frame
                    webView.navigationDelegate = self
                    self.selectedScrollView.addSubview(webView)
                    self.selectedScrollView.bringSubview(toFront: webView)
                    self.selectedScrollView.bringSubview(toFront: self.activityIndicator)
                    self.activityIndicator.startAnimating()
                    let url = URL(string: (self.selectedInformation?.companyWebsite)!)
                    let request = URLRequest(url: url!)
                    webView.load(request)
                }
            
            })}
    self.userProfilePicture.loadImageUsingCachWithUrlString(urlString: (selectedInformation?.companyImage)!, activityIndicator: self.activityIndicatorProfilepicture)
        self.userProfilePicture.clipsToBounds = true
        self.userProfilePicture.contentMode = .scaleAspectFill
        self.userProfilePicture.layer.cornerRadius = userProfilePicture.frame.size.height / 2;
        self.userProfilePicture.layer.cornerRadius = userProfilePicture.frame.size.width / 2;
        selectedImageView.loadImageUsingCachWithUrlString(urlString: (selectedInformation?.companyImage!)!, activityIndicator: activityIndicatorSelectedImage)
        
        userNameSelected.text = selectedInformation?.companyName
        userPostDescription.text = selectedInformation?.description
        locationOfPost.text = selectedInformation?.location
        
        let userInfo = selectedInformation?.companyName
        let textArray = ["About ", userInfo!,"'s ","post :"]
        aboutUsersPost.text = textArray.joined()
        let seconds = selectedInformation?.time?.doubleValue
        
        
        let timestampDate = NSDate(timeIntervalSince1970:seconds!)
        let previousDate = timestampDate as Date
        let value:String = self.timeAgoStringFromDate(date: previousDate)!
        let array = ["Posted ",value]
        let joined = array.joined()
        
        postTime.text = joined
        
}

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("did finish loading the link")
        activityIndicator.stopAnimating()
        view.sendSubview(toBack: activityIndicator)
        
    }
    func sharePost(){
        performSegue(withIdentifier: "compileCompanyMessage", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "compileCompanyMessage"{
            let viewController = segue.destination as? newViewController
        viewController?.shareCompanyPost(selectedInformation: selectedInformation!, image: selectedImageView.image!)
        }
        if segue.identifier == "reportCompanyPost"{
            let viewController = segue.destination as? reportPost
            viewController?.userID = (selectedInformation?.companyName)!
        }
    }
    func loadList(){
        dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name:NSNotification.Name(rawValue: "closeView"), object: nil)
    }
    override func viewDidLayoutSubviews() {
        
        self.mainView.frame.origin.y = self.topLayoutGuide.length * 4.5
        let contentSize = self.userPostDescription.sizeThatFits(self.userPostDescription.bounds.size)
        var frame = self.userPostDescription.frame
        frame.size.height = contentSize.height
        self.userPostDescription.frame = frame
        self.userPostDescription.isScrollEnabled = false
        
        self.selectedScrollView.delegate = self
        self.selectedScrollView.contentSize.height = self.userPostDescription.frame.origin.y + self.userPostDescription.frame.height + (self.topLayoutGuide.length * 7.5)
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
