//
//  WGLocation.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/4/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation
import MapKit

struct WGLocation {
    let latitude: Float
    let longtitude: Float
    var timestamp: TimeInterval?
    var weather: WGWeather?
    
    init(with weather: WGWeather) {
        self.weather = weather
        self.latitude = weather.latitude
        self.longtitude = weather.longitude
        self.timestamp = TimeInterval(weather.current.dt)
    }
}

extension WGLocation: Equatable {
    static func == (lhs: WGLocation, rhs: WGLocation) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longtitude == rhs.longtitude
    }    
}
