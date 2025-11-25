//
//  LocationMapViewModel.swift
//  WeatherGuide
//
//  Created by krishna on 6/3/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation
import MapKit

class LocationMapViewModel: NSObject, ObservableObject {
    
    @Published var mapRegion: MapCameraPosition = MapCameraPosition.region(.init(
        center: .init(latitude: 34.13024, longitude: -84.22762),
        latitudinalMeters: 1000,
        longitudinalMeters: 1000)
    )
    
    @Published var annotations: [PinAnnotation] = []
    
    private let locationManager = CLLocationManager()
    let addLocationSubject = PassthroughSubject<CLLocation?, Never>()
    
    var binding: Binding<MapCameraPosition> {
        Binding {
            return self.mapRegion
        } set: {  [weak self] newRegion in
            DispatchQueue.main.async {
                self?.mapRegion = newRegion
            }
        }
    }
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func fetchCurrentLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            // locationManager.startUpdatingLocation()
            if let location = locationManager.location {
                DispatchQueue.main.async { [weak self] in
                    let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                          latitudinalMeters: 1000,
                                                          longitudinalMeters: 1000)
                    self?.mapRegion = .region(coordinateRegion)
                    
                    self?.annotations.append(.init(coordinates: location.coordinate))
                }
            }
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func updateAnnotation(with coordinate: CLLocationCoordinate2D) {
        annotations.removeAll()
        annotations.append(.init(coordinates: coordinate))
    }
    
    func addLocation() {
        if let pin = annotations.first {
            let location = CLLocation(latitude: pin.coordinates.latitude,
                                      longitude: pin.coordinates.longitude)
            addLocationSubject.send(location)
        } else {
            addLocationSubject.send(nil)
        }
    }
}

extension LocationMapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = locationManager.location {
                DispatchQueue.main.async { [weak self] in
                    let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                          latitudinalMeters: 1000,
                                                          longitudinalMeters: 1000)
                    self?.mapRegion = .region(coordinateRegion)
                    self?.annotations.append(.init(coordinates: location.coordinate))
                }
                
            }
        default:
            break
        }
    }
}
