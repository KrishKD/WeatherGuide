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
            return "ClearSky"
        case .cloudy:
            return "PartlyCloudy"
        case .scatterredClouds:
            return "ScatteredClouds"
        case .overcastClouds, .brokenClouds:
            return "BrokenClouds"
        case .shower:
            return "ShowerRain"
        case .rain:
            return "Rain"
        case .thunderstorm:
            return "Thunderstorm"
        case .snow:
            return "Snow"
        case .mist:
            return "Mist"
        }
    }
}
