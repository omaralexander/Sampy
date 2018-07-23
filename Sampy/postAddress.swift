//
//  postAddress.swift
//  Sampy
//
//  Created by Omar Abbas on 10/11/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation

class postAddress: UIViewController,MGLMapViewDelegate {
    

    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var onlineOnlyButton: UIButton!
    
    var passedImage: UIImage!
    var passedName = String()
    var passedWebLink = String()
    var passedCategory = String()
    var passedAddress = String()
    var passedDescription = String()
    var passedLat = String()
    var passedLong = String()
    var statusBarShouldBeHidden = Bool()
    @IBOutlet weak var alertLabel: UILabel!
    var lat = CLLocationDegrees()
    var lon = CLLocationDegrees()
    
    var stringLat = String()
    var stringLong = String()
    
    let annotation = MGLPointAnnotation()
    
    @IBOutlet weak var backButtonImage: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    
    override var prefersStatusBarHidden: Bool{
        return statusBarShouldBeHidden
    }
    @IBAction func backToWriteAnAddress(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        let address = sender.text
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address!) {
            placemarks, error in
            let placemark = placemarks?.first
            if placemark != nil {
            self.mapView.removeAnnotation(self.annotation)
                
            self.lat = (placemark?.location?.coordinate.latitude)!
            self.lon = (placemark?.location?.coordinate.longitude)!
            
            let center = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
                self.annotation.coordinate = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)

                self.stringLat = String(self.lat)
                self.stringLong = String(self.lon)
                
                self.mapView.addAnnotation(self.annotation)
            self.mapView.setCenter(center, animated: true)
            }
            else {
                print("the location turned up nothing")
            }
        }
    }
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
        mapView.delegate = self
        
        nextButton.layer.cornerRadius = 5
        nextButton.addTarget(self, action: #selector(nextButtonFunction), for: .touchUpInside)
        
        onlineOnlyButton.layer.cornerRadius = 5
        onlineOnlyButton.addTarget(self, action: #selector(onlineButtonFunction), for: .touchUpInside)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        if passedAddress != "" {
            
            addressTextField.text = passedAddress
            let lat = Double(passedLong)
            let long = Double(passedLat)
            let combinedCoordinates = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            self.annotation.coordinate = combinedCoordinates
            self.mapView.addAnnotation(self.annotation)
            mapView.setCenter(combinedCoordinates, animated: true)
            
        }
    
    }
    func hideKeyboard(){
        view.endEditing(true)
    }
    func nextButtonFunction() {
        if addressTextField.text != "" {
            alertLabel.isHidden = true
            performSegue(withIdentifier: "moveToDescription", sender: self)
        } else{
            alertLabel.isHidden = false
        }
    }
    func onlineButtonFunction(){
        addressTextField.text = "Online only"
        //coordinates
   
        stringLat = String(0)
        stringLong = String(0)
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToCategory"{
            let viewController = segue.destination as! postCategory
            viewController.imagePassedOver = passedImage
            viewController.passedName = passedName
            viewController.passedWebLink = passedWebLink
            viewController.theSelectedCategory = passedCategory
            viewController.passedAddress = passedAddress
            viewController.passedLat = passedLat
            viewController.passedLong = passedLong
            viewController.passedOverDescription = passedDescription
        }
        if segue.identifier == "moveToDescription" {
            let viewController = segue.destination as! postDescription
            
            viewController.passedImage = passedImage
            viewController.passedName = passedName
            viewController.passedWebLink = passedWebLink
            viewController.passedCategory = passedCategory
            viewController.passedAddress = addressTextField.text!
            viewController.passedLat = stringLat
            viewController.passedLong = stringLong
            viewController.passedDescription = passedDescription
            
        }
    }
}
