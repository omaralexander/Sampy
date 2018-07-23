//
//  openingCompanyPost.swift
//  Sampy
//
//  Created by Omar Abbas on 8/29/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Canvas
import Firebase
import CoreLocation
import Mapbox
import MapboxNavigation
import MapboxDirections
import Fabric
import WebKit

class openingCompanyPost: UIViewController,UIScrollViewDelegate,MGLMapViewDelegate,CLLocationManagerDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var selectedScrollView: UIScrollView!
    
    @IBOutlet weak var activityIndicatorProfilepicture: NVActivityIndicatorView!
    
    @IBOutlet weak var webViewFrame: UIView!
    @IBOutlet weak var glanceLabel: UILabel!
    @IBOutlet weak var userNameSelected: UILabel!
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var visitOnlineButton: UIButton!
    
    @IBOutlet weak var locationOfPost: UILabel!
    
    @IBOutlet weak var aboutUsersPost: UILabel!
    
    @IBOutlet weak var userPostDescription: UITextView!
    
    @IBOutlet weak var closeDeleteView: UIButton!
    @IBOutlet weak var userProfilePicture: UIImageView!
    
    @IBOutlet weak var postTime: UILabel!
    
    @IBOutlet weak var activityIndicatorDeletingPost: NVActivityIndicatorView!
    
    @IBOutlet weak var activityIndicatorSelectedImage: NVActivityIndicatorView!
    
    @IBOutlet var noLocationErrorView: UIView!
    
    
    @IBOutlet weak var borderAboveDescription: UITextField!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var directions: UIButton!
    
    @IBOutlet weak var viewForSelectedPost: CSAnimationView!
    
    @IBOutlet weak var transportationViewMeasurments: UIView!
    
    @IBOutlet weak var dismissSelectedPostButton: UIButton!
    
    @IBOutlet weak var closeTheErrorView: UIButton!
    @IBOutlet weak var goToSettings: UIButton!
    
    var statusBarShouldBeHidden = false
    
    var selectedInformation: CompanyValues?
    
    @IBOutlet var deletePostView: UIView!
    @IBOutlet weak var deletePostButton: UIButton!
    @IBOutlet weak var expandMap: UIButton!
    @IBOutlet weak var deletePostLabel: UILabel!
    
    
    @IBOutlet var transportationView: UIView!
    
    @IBOutlet weak var drivingButton: UIButton!
    
    @IBOutlet weak var walkingButton: UIButton!
    
    @IBOutlet weak var bikingButton: UIButton!
    
    @IBOutlet weak var dismissTransportationView: UIButton!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var borderBelowMap: UITextField!
    
    var effect: UIVisualEffect!
    let manager = CLLocationManager()
    let webView = WKWebView()
    var locationTextArray = [String]()
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    var purpleColor = UIColor(red: 52/255, green: 179/255, blue: 187/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.effect = self.visualEffectView.effect
        self.visualEffectView.effect = nil

        statusBarShouldBeHidden = true
        setNeedsStatusBarAppearanceUpdate()
        
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 960:
                print("iPhone 4 or 4S")
                expandMap.frame.origin.y = 586
            case 2436:
                statusBarShouldBeHidden = false
                directions.titleLabel?.textAlignment = .natural
                directions.frame.size.height = 80 //100
                directions.frame.origin.y = 735 //738
                imageButton.frame.origin.y = 40
                dismissSelectedPostButton.frame.origin.y = 40
                visitOnlineButton.frame.origin.y = 30
                
                viewForSelectedPost.frame.size.height = 69
            default:
                print("unknown")
            }
        }
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        noLocationErrorView.layer.cornerRadius = 14
        goToSettings.layer.cornerRadius = 5
        closeTheErrorView.layer.cornerRadius = 5
        
        directions.titleLabel?.adjustsFontSizeToFitWidth = true
        
        transportationView.layer.cornerRadius = 14
        
        
        closeTheErrorView.addTarget(self, action: #selector(animateNoLocationOut), for: .touchUpInside)
        goToSettings.addTarget(self, action: #selector(goToSettingsFunction), for: .touchUpInside)
        
        visitOnlineButton.addTarget(self, action: #selector(visitOnlineFunction), for: .touchUpInside)
        
        dismissSelectedPostButton.addTarget(self, action: #selector(closeSelectedView), for: .touchUpInside)
        directions.addTarget(self, action: #selector(checkUserLocation), for: .touchUpInside)
        dismissTransportationView.addTarget(self, action: #selector(transportationAnimateOut), for: .touchUpInside)
        drivingButton.addTarget(self, action: #selector(drivingDirections), for: .touchUpInside)
        walkingButton.addTarget(self, action: #selector(walkingDirections), for: .touchUpInside)
        bikingButton.addTarget(self, action: #selector(bikingDirections), for: .touchUpInside)
        reportButton.addTarget(self, action: #selector(reportButtonFunction), for: .touchUpInside)
        closeDeleteView.addTarget(self, action: #selector(deletePostAnimateOut), for: .touchUpInside)
        expandMap.addTarget(self, action: #selector(goToMap), for: .touchUpInside)
        deletePostButton.addTarget(self, action: #selector(deleteEverything), for: .touchUpInside)
        
        
        self.transportationView.frame.size.width = transportationViewMeasurments.frame.width
        self.transportationView.frame.size.height = transportationViewMeasurments.frame.height
        
        self.selectedImageView.contentMode = .scaleToFill
        
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
        
        let zero = Double(0)
        userProfilePicture.isUserInteractionEnabled = false
        
        self.userProfilePicture.clipsToBounds = true
        self.userProfilePicture.contentMode = .scaleToFill
        self.userProfilePicture.layer.cornerRadius = userProfilePicture.frame.size.height / 2;
        self.userProfilePicture.layer.cornerRadius = userProfilePicture.frame.size.width / 2;
        self.userProfilePicture.loadImageUsingCachWithUrlString(urlString: (selectedInformation?.companyImage)!, activityIndicator: activityIndicatorProfilepicture)
        
        selectedImageView.loadImageUsingCachWithUrlString(urlString: (selectedInformation?.companyImage!)!, activityIndicator: activityIndicatorSelectedImage)
        userNameSelected.text = selectedInformation?.companyName
        userPostDescription.text = selectedInformation?.description
        
        
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
        
        print(self.userProfilePicture.frame)
        print(self.visitOnlineButton.frame)
        
        self.visitOnlineButton.isHidden = true

        if selectedInformation?.location == "Online only"{
            activityIndicator.isHidden = false
            directions.isHidden = true
            self.glanceLabel.text = "Web glance: "
            webView.frame = self.webViewFrame.frame
            webView.navigationDelegate = self
            selectedScrollView.addSubview(webView)
            selectedScrollView.bringSubview(toFront: webView)
            selectedScrollView.bringSubview(toFront: activityIndicator)
            let url = URL(string:(selectedInformation?.companyWebsite)!)
            let request = URLRequest(url: url!)
            webView.load(request)
            self.directions.isHidden = true
            expandMap.setTitle("Open website", for: .normal)
            expandMap.addTarget(self, action: #selector(goToWebsite), for: .touchUpInside)
            self.locationOfPost.text = "Online only"
        } else {
            self.expandMap.setTitle("Expand map", for: .normal)
            self.expandMap.addTarget(self, action: #selector(goToMap), for: .touchUpInside)
            self.directions.isHidden = false
           
            mapView.delegate = self
            selectedScrollView.bringSubview(toFront: mapView)
            let mapCoordinates = CLLocationCoordinate2D(latitude: (selectedInformation?.lat)!, longitude: (selectedInformation?.long)!)
            
            let annotation = MGLPointAnnotation()
            annotation.coordinate = mapCoordinates
            mapView.addAnnotation(annotation)
            mapView.setCenter(mapCoordinates, animated: false)
            mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToMap)))
            expandMap.addTarget(self, action: #selector(goToMap), for: .touchUpInside)
            
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
                })
            }
        if self.selectedInformation?.lat != 0 && self.selectedInformation?.long != 0 && self.selectedInformation?.companyWebsite != "" {
            self.visitOnlineButton.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        let contentSize = self.userPostDescription.sizeThatFits(self.userPostDescription.bounds.size)
        var frame = self.userPostDescription.frame
        frame.size.height = contentSize.height
        self.userPostDescription.frame = frame
        self.userPostDescription.isScrollEnabled = false
        
        self.selectedScrollView.delegate = self
        self.selectedScrollView.contentSize.height = self.userPostDescription.frame.origin.y + self.userPostDescription.frame.height + self.directions.frame.height
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.manager.stopUpdatingLocation()
    }
    func goToWebsite(){
        if let url = URL(string: (selectedInformation?.companyWebsite)!){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    func deletingThePost(){
        let samplePostDeleteReference = Database.database().reference().child("SamplePost").child("post")
        samplePostDeleteReference.queryOrdered(byChild: "time").queryEqual(toValue: self.selectedInformation?.time).observeSingleEvent(of: .childAdded, with: {(snapshot) in
            snapshot.ref.removeValue(completionBlock: {(error,ref) in
                if error != nil{
                    print("This is the error \(error?.localizedDescription as Any)")
                }
            })
        })
    }
    func deletingTheImage(){
        let removeImageRef = Storage.storage().reference(forURL: (self.selectedInformation?.companyImage)!)
        removeImageRef.delete(completion: {(error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
        })
    }
    func historyPostDelete(){
        let historyPostDeleteReference = Database.database().reference().child("HistoryOfPosts").child("post")
        historyPostDeleteReference.queryOrdered(byChild: "time").queryEqual(toValue: self.selectedInformation?.time).observeSingleEvent(of: .childAdded, with: {(snapshot) in
            snapshot.ref.removeValue(completionBlock: {(error,ref) in
                if error != nil{
                    print("this is the error when trying to delete the history post \(error?.localizedDescription as Any)")
                }
                self.deletePostAnimateOut()
            })
        })
    }
    func deleteEverything(){
        self.activityIndicatorDeletingPost.isHidden = true
        self.deletePostLabel.isHidden = false
        self.deletePostButton.isHidden = false
        self.activityIndicatorDeletingPost.startAnimating()
        deletingThePost()
        deletingTheImage()
        historyPostDelete()
        
    }
    func showOnlineFunction(){
        if let url = URL(string: (selectedInformation?.companyWebsite)!){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    func visitOnlineFunction(){
        if let url = URL(string: (selectedInformation?.companyWebsite)!){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showOnMap" {
            let viewController = segue.destination as! showOnMap
            var coordinates = CLLocationCoordinate2D(latitude: (selectedInformation?.lat)!, longitude: (selectedInformation?.long)!)
            viewController.coordinates = coordinates
            viewController.postDescription = (selectedInformation?.description)!
            viewController.user = (selectedInformation?.companyName)!
        }
        if segue.identifier == "reportPost"{
            let viewController = segue.destination as! reportAccountViewController
            viewController.userID = (selectedInformation?.companyName)!
        }
    }
    
    func closeSelectedView(){
        dismiss(animated: true, completion: nil)
    }
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    func drivingDirections(){
        getDirections(profileIdentifier: .automobileAvoidingTraffic)
        self.transportationAnimateOut()
        Answers.logCustomEvent(withName: "userPressed driving directions inside openingPostViewController", customAttributes: [:])
    }
    func walkingDirections(){
        getDirections(profileIdentifier: .walking)
        self.transportationAnimateOut()
        Answers.logCustomEvent(withName: "userPressed walking directions inside openingPostViewController", customAttributes: [:])
    }
    func bikingDirections(){
        getDirections(profileIdentifier: .cycling)
        self.transportationAnimateOut()
        Answers.logCustomEvent(withName: "userPressed biking directions inside openingPostViewController", customAttributes: [:])
    }
    func goToSettingsFunction(){
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    func getDirections(profileIdentifier: MBDirectionsProfileIdentifier){
        
        let userLocation: CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        let origin = Waypoint(coordinate: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude), name: "currentLocation")
        let destinationName: String! = selectedInformation!.companyName!
        let thedestination = Waypoint(coordinate: CLLocationCoordinate2D(latitude: (selectedInformation?.lat)!, longitude: (selectedInformation?.long!)!), name: "\(destinationName!)'s post")
        
        
        let options = RouteOptions(waypoints: [origin, thedestination])
        options.routeShapeResolution = .full
        options.includesSteps = true
        options.profileIdentifier = profileIdentifier
        
        Directions.shared.calculate(options) { (waypoints, routes, error) in
            guard let route = routes?.first else { return }
            
            
            let viewController = NavigationViewController(for: route, styles: [CustomStyle()])
            //viewController.mapView?.styleURL = URL(string: "mapbox://styles/sampyteam/cj5kex9af1i3c2rmtg1rb25sk")
            
            self.present(viewController, animated: true, completion: nil)
        }
    }
    func animateNoLocation(){
        self.view.addSubview(noLocationErrorView)
        noLocationErrorView.center = self.view.center
        noLocationErrorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        noLocationErrorView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.noLocationErrorView.alpha = 1
            self.noLocationErrorView.transform = CGAffineTransform.identity
        }
        
    }
    func animateNoLocationOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.noLocationErrorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.noLocationErrorView.alpha = 0
            self.visualEffectView.effect = nil
            
        }){(success:Bool) in
            self.noLocationErrorView.removeFromSuperview()
        }
    }
    func checkUserLocation(){
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case.authorizedWhenInUse:
            //This is when the app first launches
            
            animateNoLocationOut()
            manager.requestLocation()
            transportationAnimateIn()
            break
        case.notDetermined:
            //bring in animation
            
            self.manager.delegate = self
            self.manager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            //bringInAnimation
            self.animateNoLocation()
            break
        default: print("do nothing")
        }
        
    }
    func goToMap(){
        performSegue(withIdentifier: "showOnMap", sender: self)
    }
    func reportButtonFunction(){
        performSegue(withIdentifier: "reportPost", sender: self)
    }
    func deletePostAnimateIn(){
        
        self.view.addSubview(deletePostView)
        deletePostView.center = self.view.center
        deletePostView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        deletePostView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.deletePostView.alpha = 1
            self.deletePostView.transform = CGAffineTransform.identity
        }
    }
    func deletePostAnimateOut(){
        UIView.animate(withDuration: 0.4, animations:{
            self.deletePostView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.deletePostView.alpha = 0
            self.visualEffectView.effect = nil
        }){(success:Bool) in
            self.deletePostView.removeFromSuperview()
            self.activityIndicatorDeletingPost.stopAnimating()
            self.activityIndicatorDeletingPost.isHidden = true
            self.deletePostLabel.isHidden = false
            self.deletePostButton.isHidden = false
            self.dismiss(animated: true, completion: nil)
        }
    }
    func transportationAnimateIn(){
        self.view.addSubview(transportationView)
        transportationView.center = self.view.center
        transportationView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        transportationView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.transportationView.alpha = 1
            self.transportationView.transform = CGAffineTransform.identity
        }
    }
    func transportationAnimateOut(){
        UIView.animate(withDuration: 0.4, animations:{
            self.transportationView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.transportationView.alpha = 0
            self.visualEffectView.effect = nil
        }){(success:Bool) in
            self.transportationView.removeFromSuperview()
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.selectedScrollView.contentOffset.y >= selectedImageView.center.y {
            UIView.animate(withDuration: 0.25){
                self.statusBarShouldBeHidden = false
                self.setNeedsStatusBarAppearanceUpdate()
                self.viewForSelectedPost.backgroundColor = UIColor.white
            }
        }
        if self.selectedScrollView.contentOffset.y <= selectedImageView.center.y{
            UIView.animate(withDuration: 0.25){
                self.statusBarShouldBeHidden = true
                self.setNeedsStatusBarAppearanceUpdate()
                self.viewForSelectedPost.backgroundColor = UIColor.clear
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.manager.delegate = self
        
        switch status {
        case.authorizedWhenInUse:
            //This is when the app first launches
            
            self.animateNoLocationOut()
            //remove the animationView
            break
        case.notDetermined:
            
            break
        case .restricted, .denied:
            
            break
        default: print("nothign")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.first != nil{
            self.manager.requestLocation()
            
        } else {
            
            manager.desiredAccuracy = kCLLocationAccuracyBest;
            manager.requestLocation()
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
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


