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
    func fetchLocationFromDB() async
    func saveLocationToDB(_ placemark: CLPlacemark?) async
    func getAddress(for location: CLLocation) async -> Result<CLPlacemark?, WGError>
    func fetchAddressDetails(for location: CLLocation) async -> Result<CLPlacemark?, WGError>
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
    @Published var selectedLocation: WGLocation?
        
    private let geocoder: CLGeocoder
    private let dataManager: WGDataManager
    
    init(viewState: ViewState,
         geocoder: CLGeocoder = CLGeocoder(),
         dataManager: WGDataManager = WGDataManager()) {
        self.viewState = viewState
        self.dataManager = dataManager
        self.geocoder = geocoder
    }
    
    func fetchLocationFromDB() async {
        let locations: [Location] = await CoreDataStack.shared.fetchLocations()
        
        guard !locations.isEmpty else { return }
        
        await MainActor.run { [weak self] in
            self?.viewState.locations = locations.map { return WGLocation(with: $0) }
        }
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
    
    func fetchAddressDetails(for location: CLLocation) async -> Result<CLPlacemark?, WGError> {
        switch await getAddress(for: location) {
        case .success(let placemark):
            return .success(placemark)
        case .failure(let error):
            viewState.errorMsg = error.errorMessage
            return .failure(error)
        }
    }
    
    func saveLocationToDB(_ placemark: CLPlacemark?) async {
        guard let placemark, !CoreDataStack.shared.hasDuplicateObject(for: placemark.locality) else { return }
        
        await CoreDataStack.shared.createLocationObjectModel(from: placemark)
        await CoreDataStack.shared.save()
    }
}
