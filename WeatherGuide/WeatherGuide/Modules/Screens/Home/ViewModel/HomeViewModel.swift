//
//  HomeViewModel.swift
//  WeatherGuide
//
//  Created by krishna on 6/25/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation
import CoreLocation

final class HomeViewModel: ObservableObject {
    struct ViewState {
        var locations: [WGLocation] = []
        var isDataAvailable: Bool {
            !locations.isEmpty
        }
    }
    
    @Published var viewState: ViewState
    private lazy var geocoder = CLGeocoder()
    private let dataManager: WGDataManager = WGDataManager()
    
    init(viewState: ViewState) {
        self.viewState = viewState
    }
    
    func getAPIParams(for latitude: String, longitude: String) -> [String: String] {
        return ["lat": latitude,
                "lon": longitude,
                "appid": API.key,
                "units": "imperial",
                "exclude": "hourly,minutely,alerts"]
    }
    
    func getWeatherData(for latitude: String, longitude: String, city: String) async throws {
        let params = getAPIParams(for: latitude, longitude: longitude)
        
        let weather = try await dataManager.getCurrentWeather(params: params)
        
        var location = WGLocation(with: weather)
        location.update(city: city)
        
        //Check if the datasource already has an entry with the same cityId. If yes, replace it.
        if let duplicateItemIndex = viewState.locations.firstIndex(where: { $0 == location }) {
            await MainActor.run { [location] in
                viewState.locations[duplicateItemIndex] = location
            }
        } else {
            await MainActor.run { [location] in
                viewState.locations.append(location)
            }
        }
    }
    
    func getAddress(for location: CLLocation) async -> String {
        return await withCheckedContinuation { continuation in
            geocoder.reverseGeocodeLocation(location) { placeMarks, error in
                guard let placemark = placeMarks?.first else {
                    return continuation.resume(returning: "NA")
                }
                
                if let error {
                    print(error.localizedDescription)
                    return continuation.resume(returning: "NA")
                }
                
                continuation.resume(returning: placemark.locality ?? placemark.administrativeArea ?? "NA")
            }
        }
    }
}
