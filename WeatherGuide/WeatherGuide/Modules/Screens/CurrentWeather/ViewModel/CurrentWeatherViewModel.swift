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

class CurrentWeatherViewModel: NSObject, ObservableObject {
    struct ViewState {
        var currentTemperature: AttributedString
        var maximumTemperature: AttributedString
        var minimumTemperature: AttributedString
        var sunriseTime: String
        var sunsetTime: String
        var humidity: String
        var weatherStatusImageName: String
        var windSpeed: String
    }
    
    @Published var viewState: ViewState
    private let location: WGLocation
    private var cancellable: Set<AnyCancellable> = []
    private var weather: WGWeather? {
        didSet {
            Task {
                await updateViewState()
            }
        }
    }
    private let dataManager: WGDataManager
    
    init(location: WGLocation,
         viewState: ViewState,
         dataManager: WGDataManager = WGDataManager()) {
        self.location = location
        self.viewState = viewState
        self.dataManager = dataManager
    }
    
    var navigationTitle: String {
        "\(location.locality ?? ""), \(location.administrativeArea ?? "")"
    }
    
    private func getAPIParams(for latitude: String, longitude: String) -> [String: String] {
        return ["lat": latitude,
                "lon": longitude,
                "appid": API.key,
                "units": "imperial",
                "exclude": "hourly,minutely,alerts"]
    }
    
    func getWeatherData() async throws {
        let latitude = String(location.latitude)
        let longitude = String(location.longitude)
        
        let params = getAPIParams(for: latitude, longitude: longitude)
        
        self.weather = try await dataManager.getCurrentWeather(params: params)
    }
    
    func updateViewState() async {
        await MainActor.run {
            let currentTemperature = "\(weather?.current.temp ?? 0)\(Strings.temperatureSymbol)"
            let daily = weather?.daily.first
            
            let maximumTemperature = "\( daily?.temp.max ?? 0)\(Strings.temperatureSymbol)"
            let minimumTemperature = "\( daily?.temp.min ?? 0)\(Strings.temperatureSymbol)"
            let sunriseTimestamp = TimeInterval(daily?.sunrise ?? 0)
            let sunriseDate = Date(timeIntervalSinceReferenceDate: sunriseTimestamp)
            let sunriseDateString = sunriseDate.toHHmmaString(with: DefaultDateFormatter.dateformatterForhhmma())
            let sunsetTimestamp = TimeInterval(daily?.sunset ?? 0)
            let sunsetDate = Date(timeIntervalSince1970: sunsetTimestamp)
            let sunsetDateString = sunsetDate.toHHmmaString(with: DefaultDateFormatter.dateformatterForhhmma())
            let humidity = daily?.humidity
            let weatherCondition = weather?.current.weather.first?.desc
            let windSpeed = weather?.current.windSpeed ?? 0
            
            self.viewState.currentTemperature = currentTemperature.temperature
            self.viewState.maximumTemperature = maximumTemperature.temperature
            self.viewState.minimumTemperature = minimumTemperature.temperature
            self.viewState.sunriseTime = sunriseDateString
            self.viewState.sunsetTime = sunsetDateString
            self.viewState.humidity = "\(humidity ?? 0) %"
            self.viewState.weatherStatusImageName = WeatherStatus(rawValue: weatherCondition ?? "Clear")?.statusImage ?? WeatherStatus.clearSky.statusImage
            self.viewState.windSpeed = "\(windSpeed) mph"
        }
    }
}


