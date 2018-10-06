//
//  WGWeatherViewModel.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

class WGWeatherViewModel {
    
    func getCurrentWeatherData(params: String,
                               onSuccess: @escaping (WGLocation) -> Void,
                               onFailure: @escaping (String) -> Void) {
        WGDataManager.getCurrentWeather(params: params, onSuccess: { (weather) in
            let location = WGLocation()
            location.id = weather.id
            if let unixTimestamp = weather.dt {
                location.timestamp = TimeInterval(unixTimestamp)
            }
            location.weather = weather
            onSuccess(location)
        }) { (error) in
            onFailure(error)
        }
    }
}
