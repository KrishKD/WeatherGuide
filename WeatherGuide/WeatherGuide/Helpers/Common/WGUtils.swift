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
}

class WGUtils {
    //Set imageName based on weather condition
    static func setWeatherStatusImage(weatherCondition: String?) -> String {
        var imageName = "ScatteredClouds"
        if let weatherDescription = weatherCondition {
            switch weatherDescription {
            case WeatherStatus.clearSky.rawValue:
                imageName = "ClearSky"
            case WeatherStatus.cloudy.rawValue:
                imageName = "PartlyCloudy"
            case WeatherStatus.scatterredClouds.rawValue:
                imageName = "ScatteredClouds"
            case WeatherStatus.overcastClouds.rawValue:
                imageName = "BrokenClouds"
            case WeatherStatus.brokenClouds.rawValue:
                imageName = "BrokenClouds"
            case WeatherStatus.shower.rawValue:
                imageName = "ShowerRain"
            case WeatherStatus.rain.rawValue:
                imageName = "Rain"
            case WeatherStatus.thunderstorm.rawValue:
                imageName = "Thunderstorm"
            case WeatherStatus.snow.rawValue:
                imageName = "Snow"
            case WeatherStatus.mist.rawValue:
                imageName = "Mist"
            default:
                imageName = "ScatteredClouds"
            }
        }
        return imageName
    }
}

