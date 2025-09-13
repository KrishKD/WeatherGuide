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
    let longitude: Float
    var timestamp: TimeInterval?
    var weather: WGWeather?
    var city: String = ""
    
    init(with weather: WGWeather, city: String = "") {
        self.weather = weather
        self.latitude = weather.latitude
        self.longitude = weather.longitude
        self.timestamp = TimeInterval(weather.current.dt)
        self.city = city
    }
}

extension WGLocation: Equatable {
    static func == (lhs: WGLocation, rhs: WGLocation) -> Bool {
        return lhs.id == rhs.id
    }
}

extension WGLocation: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
