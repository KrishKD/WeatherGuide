//
//  WGDataManager.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation
class WGDataManager {
    let client = WGRestClient<WGWeatherModel>()
    
    //Retrieve current weather data
    func getCurrentWeather(params: String) async throws -> WGWeatherModel {
        let api = (taskType: RestRequestTask.dataTask, endPoint: API.currentWeather, parameter: params)

        return try await withCheckedThrowingContinuation { continuation in
            client.dataRequestAPICall(api: api) { result in
                continuation.resume(with: self.processResponse(result))
            }
        }
    }
    
    private func processResponse<T: Decodable>(
        _ result: Result<WGResponse<T>, WGErrorResponse>
    ) -> Result<T, WGErrorResponse> {
        switch result {
        case .success(let response):
            return .success(response.body)
        case .failure(let error):
            return .failure(error)
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
