//
//  WGLocation.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/4/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

struct WGLocation: Identifiable {
    let id: UUID = UUID()
    let latitude: Double
    let longitude: Double
    var dateModified: Date
    var locality: String?
    var administrativeArea: String?
    
    init(with latitude: Double, longitude: Double, locality: String?, administrativeArea: String? , dateModified: Date) {
        self.latitude = latitude
        self.longitude = longitude
        self.dateModified = dateModified
        self.locality = locality
        self.administrativeArea = administrativeArea
    }
}

extension WGLocation: Equatable {
    static func == (lhs: WGLocation, rhs: WGLocation) -> Bool {
        return lhs.id == rhs.id
    }
}

extension WGLocation: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension WGLocation {
    init(with location: Location) {
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.locality = location.locality
        self.administrativeArea = location.administrativeArea
        self.dateModified = location.dateModified ?? Date()
    }
}
