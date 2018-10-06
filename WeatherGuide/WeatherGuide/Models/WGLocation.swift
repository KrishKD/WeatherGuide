//
//  WGLocation.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/4/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation
import MapKit
class WGLocation {
    var id: Int?
    var timestamp: TimeInterval?
    var weather: WGWeatherModel?
    var forecast: WGForecastModel?
}
