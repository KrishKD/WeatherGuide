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
    func getAddress(for location: CLLocation) async -> Result<CLPlacemark?, WGError>
    func getWeatherData(for location: CLLocation) async throws
    var selectedLocation: WGLocation? { get set }
}

final class HomeViewModel: HomeViewModelProtocol, ObservableObject {
    struct ViewState {
        var locations: [WGLocation] = []
        var isDataAvailable: Bool {
            !locations.isEmpty
        }
        var errorMsg: String = ""
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
    
    func getAddress(for location: CLLocation) async -> Result<CLPlacemark?, WGError> {
        return await withCheckedContinuation { continuation in
            geocoder.reverseGeocodeLocation(location) { placeMarks, error in
                guard let placemark = placeMarks?.first(where: { $0.locality != nil }) else {
                    return continuation.resume(returning: .failure(WGError.invalidLocation))
                }
                
                if let error {
                    return continuation.resume(returning: .failure(WGError.genericMessage(errorMsg: error.localizedDescription)))
                }
                
                continuation.resume(returning: .success(placemark))
            }
        }
    }
    
    func getWeatherData(for location: CLLocation) async throws {
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        var locationDetails: CLPlacemark?
        
        switch await getAddress(for: location) {
        case .success(let location):
            locationDetails = location
        case .failure(let error):
            viewState.errorMsg = error.errorMessage
            return
        }
        
        let params = getAPIParams(for: latitude, longitude: longitude)
        
        let weather = try await dataManager.getCurrentWeather(params: params)
        
        let location = WGLocation(with: weather, locationDetails: locationDetails)
        
        //Check if the datasource already has an entry with the same city. If yes, replace it.
        if let duplicateItemIndex = viewState.locations.firstIndex(where: { $0.details?.locality == location.details?.locality }) {
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
