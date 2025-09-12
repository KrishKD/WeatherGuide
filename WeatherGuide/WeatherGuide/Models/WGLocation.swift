//
//  WGLocation.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/4/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

struct WGLocation: Identifiable {
    let id: UUID = UUID()
    let latitude: Float
    let longtitude: Float
    var timestamp: TimeInterval?
    var weather: WGWeather?
    var city: String = ""
    
    init(with weather: WGWeather) {
        self.weather = weather
        self.latitude = weather.latitude
        self.longtitude = weather.longitude
        self.timestamp = TimeInterval(weather.current.dt)
    }
    
    mutating
    func update(city: String) {
        self.city = city
    }
}

extension WGLocation: Equatable {
    static func == (lhs: WGLocation, rhs: WGLocation) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longtitude == rhs.longtitude
    }    
}
