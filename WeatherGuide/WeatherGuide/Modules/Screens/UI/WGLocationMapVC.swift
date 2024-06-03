//
//  WGLocationMapVC.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class WGLocationMapVC: WGBaseVC {

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    private let locationManager: CLLocationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    var pinLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addGestureRecognizer(tapRecognizer)
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.cancelsTouchesInView = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getCurrentLocation()
    }
    
    @IBAction func mapTapped(_ sender: Any) {
        if let gestureRecognizer = sender as? UITapGestureRecognizer, gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            self.mapView.removeAnnotations(self.mapView.annotations)
            addAnnotationPin(atLocation: coordinates)
        }
    }
    
    @IBAction func btnAddLocationClick(_ sender: Any) {
        for location in self.mapView.annotations {
            if !location.isKind(of: MKUserLocation.self) {
                self.pinLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }

        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unWindToHomeScreen", sender: self)
        }
    }
    
    //Get user's current location and set map region
    func getCurrentLocation() {
        self.mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    //Add Pin annotation to the map
    func addAnnotationPin(atLocation coordinates: CLLocationCoordinate2D) {
        let pointAnnotation = WGPointAnnotation()
        pointAnnotation.pinImageName = "Pin"
        pointAnnotation.coordinate = coordinates
        
        let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
        if let annotation = pinAnnotationView.annotation {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotation(annotation)
        }
    }
}

extension WGLocationMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLoc = locations.last{
            self.currentLocation = currentLoc
            
            //Set map region
            let region = MKCoordinateRegion(center: currentLoc.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.mapView.setRegion(region, animated: true)
            addAnnotationPin(atLocation: currentLoc.coordinate)
        }
        //Stop location update once we get user location.
        self.locationManager.stopUpdatingLocation()
    }
}

extension WGLocationMapVC: MKMapViewDelegate {
    
    //Set custom annotation image to that map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        if let customAnnotation = annotation as? WGPointAnnotation, let imageName = customAnnotation.pinImageName {
            annotationView?.image = UIImage(imageLiteralResourceName: imageName)
        }
        
        return annotationView
    }
}
