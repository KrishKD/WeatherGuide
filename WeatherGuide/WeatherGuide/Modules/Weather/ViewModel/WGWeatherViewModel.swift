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
                               onSuccess: @escaping (WGWeatherModel) -> Void,
                               onFailure: @escaping (String) -> Void) {
        WGDataManager.getCurrentWeather(params: params, onSuccess: { (response) in
            onSuccess(response)
        }) { (error) in
            onFailure(error)
        }
    }
}
