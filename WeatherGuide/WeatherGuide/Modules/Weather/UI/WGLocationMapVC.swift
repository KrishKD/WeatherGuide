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

class WGLocationMapVC: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    let locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            
            addAnnotationPin(atLocation: coordinates)
        }
    }
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WGLocationMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLoc = locations.last{
            self.currentLocation = currentLoc
            let region = MKCoordinateRegion(center: currentLoc.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.mapView.setRegion(region, animated: true)
            addAnnotationPin(atLocation: currentLoc.coordinate)
        }
        self.locationManager.stopUpdatingLocation()
    }
}

extension WGLocationMapVC: MKMapViewDelegate {
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
