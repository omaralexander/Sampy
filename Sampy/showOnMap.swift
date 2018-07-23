//
//  showOnMap.swift
//  Sampy
//
//  Created by Omar Abbas on 10/2/17.
//  Copyright © 2017 Sampy. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation

class showOnMap: UIViewController,MGLMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var mapView: MGLMapView!
    
    var user = String()
    var postDescription = String()
    var coordinates = CLLocationCoordinate2D()
    let manager = CLLocationManager()
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        mapView.delegate = self
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        annotation.title = user
        annotation.subtitle = description
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
        self.mapView.setCenter(coordinates, zoomLevel: 16, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        mapView.delegate = self
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        annotation.title = user
        annotation.subtitle = description
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
        self.mapView.setCenter(coordinates, zoomLevel: 16, animated: true)
    }
    func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.manager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.manager.delegate = self
        
        switch status {
        case.authorizedWhenInUse:
            //This is when the app first launche
        
            dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
            mapView.delegate = self
            self.manager.delegate = self
            self.manager.startUpdatingLocation()
            self.manager.desiredAccuracy = kCLLocationAccuracyBest
            
            let annotation = MGLPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
            annotation.title = user
            annotation.subtitle = description
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
            self.mapView.setCenter(coordinates, zoomLevel: 16, animated: true)
            
            break
        case.notDetermined:
            self.manager.delegate = self
            self.manager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            self.manager.requestWhenInUseAuthorization()
            break
        default: self.manager.requestWhenInUseAuthorization()
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
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
