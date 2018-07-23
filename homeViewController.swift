 //
//  homeViewController.swift
//  Sampy
//
//  Created by Omar Abbas on 5/27/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Firebase
import Mapbox
import MapboxCoreNavigation
import MapboxDirections
import CoreLocation
import Canvas
import NVActivityIndicatorView
import AVFoundation
import SystemConfiguration
import MapboxNavigation
import NotificationBannerSwift
 
class homeViewController: UIViewController,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MGLMapViewDelegate,UIScrollViewDelegate,AVSpeechSynthesizerDelegate{
    

    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var currentLocation: UIButton!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!

    @IBOutlet weak var swipeUpViewFrameLocation: UIView!
    @IBOutlet weak var swipeUpView: CSAnimationView!
    
    @IBOutlet weak var swipeUpButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
  
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet var mapHelpView: UIView!

    @IBOutlet weak var closeTransportationViewButton: UIButton!
   
    @IBOutlet weak var closeMapHelpView: UIButton!
    @IBOutlet weak var dontShowAgain: UIButton!
  
    @IBOutlet var noLocationErrorView: UIView!
  
    @IBOutlet weak var closeNoLocationErrorView: UIButton!
   
    @IBOutlet var transportationView: UIView!
    
    @IBOutlet weak var transportationViewMeasurment: UIView!

    @IBOutlet weak var viewForButtons: UIView!
    
    
    @IBOutlet weak var loadingMapPoints: CSAnimationView!
    @IBOutlet weak var loadingMapPointsActivityIndicator: NVActivityIndicatorView!
    
    //for navigation
    var userRoute: Route?
    let directions = Directions.shared
   
    var directionsButtonOldLocation = CGRect()
    
    @IBOutlet weak var bikingButton: UIButton!
    @IBOutlet weak var walkingButton: UIButton!
    @IBOutlet weak var drivingButton: UIButton!
   
    var destination: MGLPointAnnotation!
    
    @IBOutlet weak var directionsTestButton: UIButton!
    
    //end
    
    var effect: UIVisualEffect!
   
    @IBOutlet weak var viewForProfilePicture: UIView!
    
    @IBOutlet weak var showAroundMeTouch: UIImageView!
    
    @IBOutlet weak var loadingSampleViews: UIView!

    
    let manager = CLLocationManager()
    var markerArray = [MGLAnnotation]()
    let greenColor = UIColor(red: 52/255, green: 178/255, blue: 187/255, alpha: 1)
    var filteredLocations = [MapPoints]()
    var locations = [MapPoints]()
    var annotations = [MGLPointAnnotation]()
    let errorBanner = NotificationBanner(title: "I wasn't able to find anything :(",
                                         subtitle: "Try expanding your radius distance in settings",
                                         style: .danger)

    var  needToAnimateInHelp = Bool()
    
    @IBOutlet weak var viewToUseForCollectionView: UIView!
    var radiusDistanceNumber = NSNumber()
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                loadingMapPoints.frame.size.height = 100
                loadingSampleViews.frame.size.height = 100
                loadingMapPointsActivityIndicator.frame.origin.y = 40
                loadingLabel.frame.origin.y = 80
                
                
            default:
                print("unknown")
            }
        }
        
        
        radiusDistanceNumber = 5
        self.viewForButtons.isHidden = true
      
        
        self.closeNoLocationErrorView.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        
        self.noLocationErrorView.layer.cornerRadius = 14
        self.closeNoLocationErrorView.layer.cornerRadius = 5
        
        self.manager.delegate = self
        self.effect = self.visualEffectView.effect
        self.visualEffectView.effect = nil
        
        self.dontShowAgain.isHidden = true
        self.closeMapHelpView.isHidden = true
      
    
        
        switch CLLocationManager.authorizationStatus(){
        case.authorizedWhenInUse:
            //This is when the app first launches
            self.manager.delegate = self
            self.manager.startUpdatingLocation()
            self.manager.desiredAccuracy = kCLLocationAccuracyBest;
            
            
            let userLocation:CLLocationCoordinate2D? = self.manager.location?.coordinate
            
            if userLocation == nil{
                self.mapView.delegate = self
                self.manager.requestLocation()
                self.mapView.showsUserLocation = true
                self.mapView.isRotateEnabled = false
                self.mapView.allowsTilting = false
                self.loadTheView()
                
            }else{
                self.mapView.delegate = self
              self.mapView.setCenter(userLocation!, zoomLevel: 14, animated: true)
                self.mapView.setUserTrackingMode(.follow, animated: false)
                self.mapView.showsUserLocation = true
                self.mapView.isRotateEnabled = false
                self.mapView.allowsTilting = false
                self.loadTheView()
            
            }
            break
        case.notDetermined:
            self.manager.delegate = self
            self.manager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            self.manager.delegate = self
            self.animateNoLocation()
        
            break
        
        default: self.manager.requestWhenInUseAuthorization()
        }
    }
        override func viewWillDisappear(_ animated: Bool) {

        UIView.animate(withDuration: 0.25){

            self.loadingMapPoints.frame.origin.y = -self.loadingMapPoints.frame.height - 30
            self.loadingMapPointsActivityIndicator.stopAnimating()
    }
}
    override func viewDidDisappear(_ animated: Bool) {
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                let viewController = self.parent as? tabBarViewController
                viewController?.contentView.frame.size.height = 753
                
                loadingMapPoints.frame.size.height = 100
                loadingSampleViews.frame.size.height = 100
                loadingMapPointsActivityIndicator.frame.origin.y = 40
                loadingLabel.frame.origin.y = 80
                
            default:
                print("unknown")
            }
        }
        self.manager.stopUpdatingLocation()
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
            } else {
                if  self.needToAnimateInHelp == true{
                    self.helpAnimateIn()
                }
            }
        })
    }

    
    var timer: Timer?
    func handleReloadTable(){
        self.collectionView.reloadData()
    }

    func searchAroundArea(){
                bringInLoadingView()
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                let ref = Database.database().reference().child("Users").child(uid).child("radiusDistance")
                ref.observe(.value, with: {(snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        self.radiusDistanceNumber = (dictionary["radiusDistance"] as? NSNumber)!
                    }
                })
                
            filteredLocations.removeAll()
            locations.removeAll()
            annotations.removeAll()
  
            
            let sampleRef = Database.database().reference().child("SamplePost").child("post")
            
            sampleRef.observeSingleEvent(of:.value, with: {(snapshot) in
                if  let result = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in result{
                        let dictionary = child.value as? [String: AnyObject]
                        let lat = dictionary?["lat"] as! Double
                        let long = dictionary?["long"] as! Double
                        let image = dictionary?["image"] as! String
                        let text = dictionary?["text"] as! String
                        let user = dictionary?["user"] as! String
                        let address = dictionary?["postCity"] as! String
                        let time = dictionary?["time"] as! NSNumber
                        let uid = dictionary?["userUid"] as! String
                        let viewCount = dictionary?["viewCount"] as! NSNumber
                        let type = dictionary?["type"] as! String
                        
                        let structure = MapPoints(Latitude: lat, Longitude: long, Image: image, Text: text, User: user, PostCity: address, Time: time, userUID: uid, ViewCount: viewCount, Type: type)
                        self.filteredLocations.append(structure)
                        self.locations.append(structure)
                        self.filteredLocations.sort(by:{(message1, message2) -> Bool in
                            return (message1.time?.intValue)! > (message2.time?.intValue)!
                        })
                        self.locations.sort(by:{(message1, message2) -> Bool in
                            return (message1.time?.intValue)! > (message2.time?.intValue)!
                        })


                        self.timer?.invalidate()
                        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    }
                }
          
                 let refined = self.radiusDistanceNumber.doubleValue
                    self.removePointsAndClearArray()

                    self.filteredLocations = self.locations.filter {
                        (locations) in
                        
                        let userLocation = self.mapView.camera.centerCoordinate
                        let userLat = userLocation.latitude
                        let userLong = userLocation.longitude
                        
                        let coordinateOne = CLLocation(latitude: userLat, longitude: userLong)
                        let coordinateTwo = CLLocation(latitude: CLLocationDegrees(locations.latitude!), longitude: CLLocationDegrees(locations.longitude!))
                        
                        let distanceFromPoints = coordinateOne.distance(from: coordinateTwo)
                        let convertToMiles = distanceFromPoints*0.00062137
                        return convertToMiles < refined
                    }
                
                    self.filteredLocations.map {
                        (location) in
                        let annotation = MGLPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude!), longitude: CLLocationDegrees(location.longitude!))
                        annotation.title = location.user
                        annotation.subtitle = location.text
                        
                        self.mapView.addAnnotation(annotation)
                        self.annotations.append(annotation)
                        self.mapView.setCenter(self.mapView.camera.centerCoordinate, zoomLevel: 10, animated: true)
                        }
                
                    if self.filteredLocations.count <= 0 {
                        self.removeLoadingView()
                        self.collectionView.isUserInteractionEnabled = false
                        self.swipeUpAnimateOut()
                        if self.errorBanner.isDisplaying == true {
                        self.errorBanner.dismiss()
                        self.errorBanner.show()
                        }else {
                            self.errorBanner.show()
                        }
                        
                    } else{
                        self.removeLoadingView()
                        self.collectionView.isUserInteractionEnabled = true
                        let filteredLocationsCount = CGFloat(self.filteredLocations.count)
                        let multiplication = filteredLocationsCount * self.viewToUseForCollectionView.frame.width
                        self.collectionView.contentSize.width = CGFloat(multiplication)
                        self.swipeUpAnimation()
                }
                
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                
                
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                        
                    })
                })
            }
   
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.manager.delegate = self
        
        switch status {
        case.authorizedWhenInUse:
            //This is when the app first launches
            self.animateNoLocationOut()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest;
            manager.startUpdatingLocation()

            let userLocation:CLLocationCoordinate2D? = self.manager.location?.coordinate
            
            if self.manager.location == nil{
                self.manager.requestLocation()
                self.mapView.delegate = self
                self.mapView.showsUserLocation = true
                self.mapView.isRotateEnabled = false
                self.mapView.allowsTilting = false
                self.loadTheView()
            }else{
                self.mapView.delegate = self
                self.mapView.setCenter(userLocation!, zoomLevel: 14, animated: true)
                self.mapView.setUserTrackingMode(.follow, animated: false)
                self.mapView.showsUserLocation = true
                self.mapView.isRotateEnabled = false
                self.mapView.allowsTilting = false
                self.loadTheView()
                
            }
            break
        case.notDetermined:
            self.manager.delegate = self
            self.manager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
           self.animateNoLocation()
            break
        default: self.manager.requestWhenInUseAuthorization()
        }
    }
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.first != nil{
        self.updateUserLocation()
        
        } else {
            
            manager.desiredAccuracy = kCLLocationAccuracyBest;
            manager.requestLocation()
        }
}
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    func updateUserLocation(){
       
        Timer.scheduledTimer(timeInterval: 12.0, target: self, selector: #selector(slowedUpdateUserLocation), userInfo: nil, repeats: false)
    }
    func slowedUpdateUserLocation(){
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        let values = ["userLat":self.manager.location?.coordinate.latitude as Any,"userLong":self.manager.location?.coordinate.longitude as Any] as [String:Any]
        ref.updateChildValues(values)
    }
    func getUserCurrentlocation(){
        switch CLLocationManager.authorizationStatus(){
            
        case.authorizedWhenInUse:
            manager.delegate = self
            manager.requestLocation()
            let userLocation:CLLocationCoordinate2D? = manager.location?.coordinate
            
            self.mapView.setCenter(userLocation!, zoomLevel: 14, animated: true)
           
            break
        case.notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
           self.animateNoLocation()
            break
        default: manager.requestWhenInUseAuthorization()
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: viewToUseForCollectionView.frame.width, height: swipeUpView.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: "openPost", sender: self)
    Answers.logCustomEvent(withName: "user selected sample for more information inside HomeViewController", customAttributes: [:])
    }
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "openPost" {
            
            let indexPath = collectionView.indexPathsForSelectedItems?.last
            let selectedInformation: MapPoints
            
            selectedInformation = filteredLocations[(indexPath?.row)!]
            
            let viewController = segue.destination as! openingPostViewController
            viewController.selectedInformation = selectedInformation
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! cellForLocations
            
        
        let postInformation = filteredLocations[indexPath.row]

        
        let ref = Database.database().reference().child("Users").child(postInformation.userUid!)
        ref.observe(.value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                cell.userProfilePicture.frame = CGRect(x: cell.userProfilePicture.frame.origin.x, y: cell.userProfilePicture.frame.origin.y, width: self.viewForProfilePicture.frame.width, height: self.viewForProfilePicture.frame.height)
                cell.userProfilePicture.image = UIImage(named: "an-image")
                cell.userProfilePicture.clipsToBounds = true
                cell.userProfilePicture.layer.cornerRadius = cell.userProfilePicture.frame.size.height / 2;
                cell.userProfilePicture.loadImageUsingCachWithUrlString(urlString: dictionary["profileImageUrl"] as! String, activityIndicator: cell.activityIndicator)

            }
        })
        
        
        cell.postImage.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: cell.activityIndicator)
        cell.backgroundColor = UIColor.clear
        cell.userNameTextField.text = postInformation.user
        cell.postImage.loadImageUsingCachWithUrlString(urlString: postInformation.image!, activityIndicator: cell.activityIndicator)
        cell.activityIndicator.frame.size.width = cell.postImage.frame.width / 3
        cell.activityIndicator.frame.size.height = cell.postImage.frame.height / 3
        
        
        let seconds = postInformation.time?.doubleValue
        let timestampDate = NSDate(timeIntervalSince1970:seconds!)
        let previousDate = timestampDate as Date
        let value:String = self.timeAgoStringFromDate(date: previousDate)!
        let array = ["Posted ",value]
        let joined = array.joined()
        cell.postTime.text = joined
        
        let combinedCoordinates = CLLocationCoordinate2D(latitude: postInformation.latitude!, longitude: postInformation.longitude!)
        let userLocation:CLLocationCoordinate2D? = self.manager.location?.coordinate
        if userLocation != nil{
        let options = RouteOptions(coordinates: [userLocation!, combinedCoordinates])
        options.includesSteps = true
        options.routeShapeResolution = .full
        options.profileIdentifier = .walking
        
        _ = directions.calculate(options) { [weak self] (waypoints, routes, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let route = routes?.first else {
                return
            }
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
            
            let distanceFromPoints = Float(route.distance * 0.000568182).rounded()
            cell.distanceLabel.text = ("Aprox \(formatter.string(for: distanceFromPoints)!) miles away")
            
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //(0,10,0,10)
    
        return UIEdgeInsetsMake(0, 35, 67, 35)      //UIEdgeInsetsMake(0, -5, 0, -5)
    }
    func removePointsAndClearArray(){
        collectionView.isUserInteractionEnabled = false
        if filteredLocations.count > 0 {
            filteredLocations.removeAll()
            if self.mapView.annotations?.count == nil {
            }else{
                self.mapView.removeAnnotations(self.mapView.annotations!)
            }
            
            collectionView.reloadData()
        } else{
        }
    }
    
    func buttonPressed(){
        if swipeUpButton.titleLabel?.text == "Close" {
          
            swipeUpAnimateOut()
        } else{
        self.removePointsAndClearArray()
        self.collectionView.reloadData()
        self.searchAroundArea()
        }
    }

    func swipeUpAnimation(){
        
        UIView.animate(withDuration:0.3){
            self.directionsTestButton.frame = self.directionsButtonOldLocation
        }

        UIView.animate(withDuration: 0.7){
        self.currentLocation.frame.origin.x = -(UIScreen.main.bounds.width + self.currentLocation.frame.width)
        
        }
       
        self.view.addSubview(swipeUpView)
        
        UIView.animate(withDuration: 0.7){
        
            self.swipeUpButton.backgroundColor = self.greenColor
            self.swipeUpButton.frame.origin.x = 0
            self.swipeUpButton.frame.size.width = UIScreen.main.bounds.width
            self.swipeUpButton.setTitleColor(UIColor.white, for: .normal)
            self.swipeUpButton.setTitle("Close", for: .normal)
        }
        
        swipeUpView.frame = swipeUpViewFrameLocation.frame
        swipeUpView.startCanvasAnimation()
      
        let selectedPoints = filteredLocations.first
        if selectedPoints != nil{
        let destinationAnnotation = MGLPointAnnotation()
        destinationAnnotation.coordinate = CLLocationCoordinate2D(latitude: (selectedPoints?.latitude)!, longitude: (selectedPoints?.longitude)!)
        destination = destinationAnnotation
        getRoute(destination: CLLocationCoordinate2D(latitude: (selectedPoints?.latitude)!, longitude: (selectedPoints?.longitude)!))
        addRouteToMap()
        self.mapView.setCenter(CLLocationCoordinate2D(latitude: (selectedPoints?.latitude)!, longitude: (selectedPoints?.longitude)!), zoomLevel: 14, animated: true)
        for points in annotations {
            
            if points.subtitle == selectedPoints?.text{
                self.mapView.selectAnnotation(points, animated: true)
                }
            }
        }
    }
    func swipeUpAnimateOut(){
       
        UIView.animate(withDuration:0.3){
            self.directionsTestButton.frame.origin.y = -(UIScreen.main.bounds.height + self.directionsTestButton.frame.height)
        }

        UIView.animate(withDuration: 0.7){
        self.currentLocation.frame.origin.x = 0
        }
        
        UIView.animate(withDuration: 0.7){
    
            self.swipeUpButton.setTitleColor(self.greenColor, for: .normal)
            self.swipeUpButton.backgroundColor = UIColor.white
            self.swipeUpButton.setTitle("Search this area", for: .normal)
            self.swipeUpButton.frame.origin.x = UIScreen.main.bounds.width / 2
            self.swipeUpButton.frame.size.width = UIScreen.main.bounds.width / 2
        }

        UIView.animate(withDuration: 0.35) {
            self.swipeUpView.frame.origin.y = 1000
        }
    }

    func bringInLoadingView(){

        self.loadingMapPoints.frame.origin.y = 0
        loadingMapPoints.startCanvasAnimation()
        loadingMapPointsActivityIndicator.startAnimating()

    }
    func removeLoadingView(){
        UIView.animate(withDuration: 0.25){
        self.loadingMapPoints.frame.origin.y = -self.loadingMapPoints.frame.height - 30
            self.loadingMapPointsActivityIndicator.stopAnimating()
        }
    }
 
       func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
        let pageWidth: Float = Float(self.viewToUseForCollectionView.frame.width)  //3.5
       
        let currentOffset: Float = Float(scrollView.contentOffset.x)
        
        let targetOffset: Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset: Float = 0

        if targetOffset > currentOffset {
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
        }
        else {
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
        }
        if newTargetOffset < 0 {
            newTargetOffset = 0
        }
        else if (newTargetOffset > Float(scrollView.contentSize.width)){
            newTargetOffset = Float(Float(scrollView.contentSize.width))
        }
        
        targetContentOffset.pointee.x = CGFloat(currentOffset)

        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = self.viewToUseForCollectionView.frame.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let visibleIndexPath: IndexPath = (collectionView.indexPathForItem(at: visiblePoint))! else{
            return
        }
        
        let filteredLocationMapPoints = filteredLocations[(visibleIndexPath.item)]
        
        let filteredLocationLat = filteredLocationMapPoints.latitude
        let filteredLocationLong = filteredLocationMapPoints.longitude
        let combinedFilteredPoints = CLLocationCoordinate2D(latitude: filteredLocationLat!, longitude: filteredLocationLong!)
//        for points in annotations {
//            self.mapView.deselectAnnotation(points, animated: false)
//            if points.subtitle == filteredLocationMapPoints.text{
//                self.mapView.selectAnnotation(points, animated: true)
//            }
//        }
    
        self.mapView.setCenter(combinedFilteredPoints, zoomLevel: 14, animated: true)
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
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if filteredLocations.count == 0 {
            
        } else{
           destination = nil
            
            var visibleRect = CGRect()
            visibleRect.origin = collectionView.contentOffset
            visibleRect.size = self.viewToUseForCollectionView.frame.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            let visibleIndexPath: IndexPath = (collectionView.indexPathForItem(at: visiblePoint))!
            
            let filteredLocationMapPoints = filteredLocations[(visibleIndexPath.item)]
            
            let filteredLocationLat = filteredLocationMapPoints.latitude
            let filteredLocationLong = filteredLocationMapPoints.longitude
            let combinedFilteredPoints = CLLocationCoordinate2D(latitude: filteredLocationLat!, longitude: filteredLocationLong!)
            self.mapView.setCenter(combinedFilteredPoints, zoomLevel: 14, animated: true)
            increaseViewCount(postUid: filteredLocationMapPoints.userUid!, time: filteredLocationMapPoints.time!)
            
            let destinationCoordinate = MGLPointAnnotation()
            destinationCoordinate.coordinate = combinedFilteredPoints
            destination = destinationCoordinate
            
            getRoute(destination: combinedFilteredPoints)
            self.addRouteToMap()
           
            for points in annotations {
                if points.subtitle == filteredLocationMapPoints.text{
                    self.mapView.selectAnnotation(points, animated: true)
                }
            }
        }
    }
   
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        for points in annotations {
            self.mapView.deselectAnnotation(points, animated: true)
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
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func transportationAnimateIn(){
        self.view.addSubview(transportationView)
        transportationView.center = self.view.center
        transportationView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        transportationView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.visualEffectView.effect = self.effect
            self.view.sendSubview(toBack: self.swipeUpView)
            self.transportationView.alpha = 1
            self.transportationView.transform = CGAffineTransform.identity
        }
    }
    func transportationAnimateOut(){
        UIView.animate(withDuration: 0.4, animations:{
        self.transportationView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.transportationView.alpha = 0
        self.visualEffectView.effect = nil
        self.view.bringSubview(toFront: self.swipeUpView)
        
        }){(success:Bool) in
            self.transportationView.removeFromSuperview()
    }
}
    
    func helpAnimateIn(){
        self.view.addSubview(mapHelpView)
        mapHelpView.center = self.view.center
        mapHelpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        mapHelpView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.viewForButtons.isHidden = false
            self.closeMapHelpView.isHidden = false
            self.dontShowAgain.isHidden = false
            self.mapHelpView.alpha = 1
            self.mapHelpView.transform = CGAffineTransform.identity
        }
    }
    
    func helpAnimateOut(){
         needToAnimateInHelp = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.mapHelpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.mapHelpView.alpha = 0
        }){(success:Bool) in
            self.mapHelpView.removeFromSuperview()
            self.viewForButtons.isHidden = true
           
            
            self.closeMapHelpView.isHidden = true
            self.dontShowAgain.isHidden = true
            
            }
        }
    func dontShowAgainFunction(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        let values = ["doNotShow":"true"]
        ref.updateChildValues(values)
        helpAnimateOut()
    }
    
    func showMapHelp(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference().child("Users").child(uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
     
            let dictionary = snapshot.value as? [String:AnyObject]
            let doNotShowAgain = dictionary?["doNotShow"] as! String
            
            if doNotShowAgain == "false" {
                let viewController = self.parent as? tabBarViewController
                if viewController == nil{
                    self.needToAnimateInHelp = true
                } else{
                    self.needToAnimateInHelp = false
                self.helpAnimateIn()
                }
            }
            })
        }

    func goToSettings(){
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    func drivingDirections(){
        getDirections(profileIdentifier: .automobileAvoidingTraffic)
        self.transportationAnimateOut()
        Answers.logCustomEvent(withName: "user pressed driving directions inside HomeViewController", customAttributes: [:])
    }
    
    func walkingDirections(){
        getDirections(profileIdentifier: .walking)
        self.transportationAnimateOut()
        Answers.logCustomEvent(withName: "user pressed walking directions inside HomeViewController", customAttributes: [:])
        
    }
    
    func bikingDirections(){
        getDirections(profileIdentifier: .cycling)
        self.transportationAnimateOut()
        Answers.logCustomEvent(withName: "user pressed biking directions inside HomeViewController", customAttributes: [:])
    }
    
    func getDirections(profileIdentifier: MBDirectionsProfileIdentifier){

        let userLocation: CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        let origin = Waypoint(coordinate: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude), name: "currentLocation")
    
        let thedestination = Waypoint(coordinate: CLLocationCoordinate2D(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude), name: "Destination")
    

        let options = RouteOptions(waypoints: [origin, thedestination])
        options.routeShapeResolution = .full
        options.includesSteps = true
        options.profileIdentifier = profileIdentifier
        
            Directions.shared.calculate(options) { (waypoints, routes, error) in
            guard let route = routes?.first else { return }
            

            let viewController = NavigationViewController(for: route)
            viewController.mapView?.styleURL = URL(string: "mapbox://styles/sampyteam/cj5kex9af1i3c2rmtg1rb25sk")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    func getRoute(completion: (()->())? = nil,destination:CLLocationCoordinate2D) {
        let options = RouteOptions(coordinates: [mapView.userLocation!.coordinate, destination])
        options.includesSteps = true
        options.routeShapeResolution = .full
        options.profileIdentifier = .walking
        
        _ = directions.calculate(options) { [weak self] (waypoints, routes, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let route = routes?.first else {
                return
            }
            
            self?.userRoute = route
            
            
            completion?()
            self?.addRouteToMap()
        }
    }
    func addRouteToMap(){
        guard let style = mapView.style else{
            return
        }
        guard let userRoute = userRoute else {
            return
        }
        let polyline = MGLPolylineFeature(coordinates: userRoute.coordinates!, count: userRoute.coordinateCount)
        let lineSource = MGLShapeSource(identifier: "sourceIdentifier", shape: polyline, options: nil)
        
        if let source = style.source(withIdentifier: "sourceIdentifier") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let line = MGLLineStyleLayer(identifier: "layerIdentifier", source: lineSource)
            
            // Style the line
            
            line.lineColor = MGLStyleValue(rawValue: UIColor(red:0/255, green:112/255, blue:158/255, alpha:1))
            line.lineWidth = MGLStyleValue(rawValue: 5)
            line.lineCap = MGLStyleValue(rawValue: NSValue(mglLineCap: .round))
            line.lineJoin = MGLStyleValue(rawValue: NSValue(mglLineJoin: .round))
            
            // Add source and layer
            style.addSource(lineSource)
            for layer in style.layers.reversed() {
                if !(layer is MGLSymbolStyleLayer) {
                    style.insertLayer(line, above: layer)
                    break
                }
            }
        }
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
            } else {
                self.showMapHelp()
            }
        })
    
        let refDistance = Database.database().reference().child("Users").child(uid)
        refDistance.observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.radiusDistanceNumber = (dictionary["radiusDistance"] as? NSNumber)!
            }
            
        })
        self.directionsButtonOldLocation = directionsTestButton.frame
        self.collectionView.isUserInteractionEnabled = true
    
        self.collectionView.register(cellForLocations.self, forCellWithReuseIdentifier: "Cell")
        if UIDevice().userInterfaceIdiom == .phone{
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                print("it is the iPhone X")
let viewController = self.parent as? tabBarViewController
                viewController?.contentView.frame.size.height = 722
                
                loadingMapPoints.frame.size.height = 100
                loadingSampleViews.frame.size.height = 100
                loadingMapPointsActivityIndicator.frame.origin.y = 40
                loadingLabel.frame.origin.y = 80
                
            default:
                print("unknown")
            }
        }
        self.viewForButtons.isHidden = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.alwaysBounceHorizontal = true
        self.collectionView.backgroundColor = UIColor.clear
       
        self.transportationView.layer.cornerRadius = 14
        self.directionsTestButton.layer.cornerRadius = 5
        
        self.mapHelpView.frame = CGRect(x: mapHelpView.frame.origin.x, y: mapHelpView.frame.origin.y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        self.dontShowAgain.titleLabel?.adjustsFontSizeToFitWidth = true

        self.manager.distanceFilter = 3.048
        
       self.dontShowAgain.titleLabel?.adjustsFontSizeToFitWidth = true
        
       self.loadingMapPoints.frame.origin.y = -self.loadingMapPoints.frame.height - 30
        
        self.transportationView.frame.size.width = transportationViewMeasurment.frame.width
        self.transportationView.frame.size.height = transportationViewMeasurment.frame.height
       
        self.directionsTestButton.frame.origin.y = -(UIScreen.main.bounds.height + directionsTestButton.frame.height)
        
        self.noLocationErrorView.frame = CGRect(x: noLocationErrorView.frame.origin.x, y: noLocationErrorView.frame.origin.y, width: UIScreen.main.bounds.width - 16, height: noLocationErrorView.frame.height)
       
        self.collectionView.isPagingEnabled = false
        
    
        self.currentLocation.addTarget(self, action: #selector(self.getUserCurrentlocation), for: .touchUpInside)
        self.closeMapHelpView.addTarget(self, action: #selector(helpAnimateOut), for: .touchUpInside)
        self.dontShowAgain.addTarget(self, action: #selector(dontShowAgainFunction), for: .touchUpInside)
  
        self.directionsTestButton.addTarget(self, action: #selector(transportationAnimateIn), for: .touchUpInside)
        self.closeTransportationViewButton.addTarget(self, action: #selector(transportationAnimateOut), for: .touchUpInside)
        self.drivingButton.addTarget(self, action: #selector(drivingDirections), for: .touchUpInside)
        self.walkingButton.addTarget(self, action: #selector(walkingDirections), for: .touchUpInside)
        self.bikingButton.addTarget(self, action: #selector(bikingDirections), for: .touchUpInside)
        
        
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUpAnimateOut))
        swipeDown.direction = .down
        self.collectionView.addGestureRecognizer(swipeDown)
        
        self.swipeUpButton.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        
        let filteredLocationsCount = CGFloat(self.filteredLocations.count)
        let multiplication = filteredLocationsCount * self.viewToUseForCollectionView.frame.width + 100
        
        self.collectionView.contentSize.width = CGFloat(multiplication)
   
        if self.revealViewController() != nil {
           
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
 
