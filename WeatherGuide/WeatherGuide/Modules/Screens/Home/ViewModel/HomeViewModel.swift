//
//  HomeViewModel.swift
//  WeatherGuide
//
//  Created by krishna on 6/25/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation
import CoreLocation

protocol HomeViewModelProtocol {
    func getAddress(for location: CLLocation) async -> String
    func getWeatherData(for location: CLLocation) async throws
    var selectedLocation: WGLocation? { get set }
}

final class HomeViewModel: HomeViewModelProtocol, ObservableObject {
    struct ViewState {
        var locations: [WGLocation] = []
        var isDataAvailable: Bool {
            !locations.isEmpty
        }
    }
    
    @Published var viewState: ViewState
    @Published var selectedLocation: WGLocation? {
        didSet {
            print(self)
        }
    }
        
    private let geocoder: CLGeocoder
    private let dataManager: WGDataManager
    
    init(viewState: ViewState,
         geocoder: CLGeocoder = CLGeocoder(),
         dataManager: WGDataManager = WGDataManager()) {
        self.viewState = viewState
        self.dataManager = dataManager
        self.geocoder = geocoder
    }
    
    private func getAPIParams(for latitude: String, longitude: String) -> [String: String] {
        return ["lat": latitude,
                "lon": longitude,
                "appid": API.key,
                "units": "imperial",
                "exclude": "hourly,minutely,alerts"]
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
    
    func getWeatherData(for location: CLLocation) async throws {
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        let city = await getAddress(for: location)
        
        let params = getAPIParams(for: latitude, longitude: longitude)
        
        let weather = try await dataManager.getCurrentWeather(params: params)
        
        let location = WGLocation(with: weather, city: city)
        
        //Check if the datasource already has an entry with the same city. If yes, replace it.
        if let duplicateItemIndex = viewState.locations.firstIndex(where: { $0.city == location.city }) {
            await MainActor.run { [location] in
                viewState.locations[duplicateItemIndex] = location
            }
        } else {
            await MainActor.run { [location] in
                viewState.locations.append(location)
            }
        }
    }
}
