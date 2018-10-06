//
//  WGDataManager.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation
class WGDataManager {
    //Retrieve current weather data
    class func getCurrentWeather(params: String,
                                 onSuccess: @escaping (WGWeatherModel) -> Void,
                                 onFailure: @escaping (String) -> Void) {
        let api = (taskType: RestRequestTask.dataTask, endPoint: API.currentWeather, parameter: params)

        WGRestClient.dataRequestAPICall(api: api, onSuccess: { (response) in
            do {
                let jsonObject =  try JSONSerialization.jsonObject(with: response, options: [])
                print(jsonObject)
                
                //Convert Data to model object
                let weather = try JSONDecoder().decode(WGWeatherModel.self, from: response)
                
                guard let erroMsg = weather.message, weather.cod != nil else {
                    onSuccess(weather)
                    return
                }
                onFailure(erroMsg)
            } catch let error {
                onFailure(error.localizedDescription)
            }
        }) { (error) in
            onFailure(error)
        }
    }
    
    //Retrieve forecast weather data
    /*class func getForecast(params: String,
                           onSuccess: @escaping APISuccessHandler,
                           onFailure: @escaping (String) -> Void) {
        let api = (taskType: RestRequestTask.dataTask, endPoint: API.forecast, parameter: params)
        WGRestClient.dataRequestAPICall(api: api, onSuccess: { (apiResponse) in
            onSuccess(apiResponse)
        }, onError: {(error) in
            onFailure(error.statusMessage)
        })
    }*/
}
