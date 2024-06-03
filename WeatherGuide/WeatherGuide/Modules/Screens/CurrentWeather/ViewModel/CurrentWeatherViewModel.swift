//
//  CurrentWeatherViewModel.swift
//  WeatherGuide
//
//  Created by krishna on 6/2/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class CurrentWeatherViewModel {
    struct ViewState {
        public let currentTemperature: AttributedString
        let maximumTemperature: AttributedString
        let minimumTemperature: AttributedString
        let sunriseTime: String
        let sunsetTime: String
        let humidity: String
        let weatherStatusImageName: String
        let windSpeed: String
    }
    
    let viewState: ViewState
    private let location: WGLocation
    
    init(location: WGLocation) {
        self.location = location
        let currentTemperature = "\(location.weather?.current.temp.intValue ?? 0)\(Strings.temperatureSymbol)"
        let daily = location.weather?.daily.first
        
        let maximumTemperature = "\( daily?.temp.max.intValue ?? 0)\(Strings.temperatureSymbol)"
        let minimumTemperature = "\( daily?.temp.min.intValue ?? 0)\(Strings.temperatureSymbol)"
        let sunriseTimestamp = TimeInterval(daily?.sunrise ?? 0)
        let sunriseDate = Date(timeIntervalSinceReferenceDate: sunriseTimestamp)
        let sunriseDateString = sunriseDate.toHHmmaString(with: DefaultDateFormatter.dateformatterForhhmma())
        let sunsetTimestamp = TimeInterval(daily?.sunset ?? 0)
        let sunsetDate = Date(timeIntervalSince1970: sunsetTimestamp)
        let sunsetDateString = sunsetDate.toHHmmaString(with: DefaultDateFormatter.dateformatterForhhmma())
        let humidity = daily?.humidity
        let weatherCondition = location.weather?.current.weather.first?.desc
        let windSpeed = location.weather?.current.windSpeed.intValue ?? 0
        
        self.viewState = .init(
            currentTemperature: currentTemperature.temperature,
            maximumTemperature: maximumTemperature.temperature,
            minimumTemperature: minimumTemperature.temperature,
            sunriseTime: sunriseDateString,
            sunsetTime: sunsetDateString,
            humidity: "\(humidity ?? 0) %",
            weatherStatusImageName: WeatherStatus(rawValue: weatherCondition ?? "Clear")?.statusImage ?? WeatherStatus.clearSky.statusImage,
            windSpeed: "\(windSpeed) mph"
        )
    }
    
    func bind() {
        
    }
}
