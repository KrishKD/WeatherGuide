//
//  WGUtils.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/6/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit

enum WeatherStatus: String {
    case clearSky = "Clear"
    case cloudy = "Clouds"
    case scatterredClouds = "scattered clouds"
    case overcastClouds = "overcast clouds"
    case brokenClouds = "broken clouds"
    case shower = "shower rain"
    case rain = "Rain"
    case thunderstorm = "thunderstorm"
    case snow = "Snow"
    case mist = "Mist"
    
    var statusImage: String {
        switch self {
        case .clearSky:
            return "sun.max"
        case .cloudy:
            return "cloud.sun"
        case .scatterredClouds:
            return "cloud"
        case .overcastClouds, .brokenClouds:
            return "smoke"
        case .shower:
            return "cloud.drizzle"
        case .rain:
            return "cloud.rain"
        case .thunderstorm:
            return "cloud.bolt.rain"
        case .snow:
            return "snowflake"
        case .mist:
            return "sun.haze"
        }
    }
}
