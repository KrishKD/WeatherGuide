//
//  LocationMapViewModel.swift
//  WeatherGuide
//
//  Created by krishna on 6/3/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit
import Combine

struct LocationMapViewModel {
    struct ViewState {
        @State var coordinateRegion = MKCoordinateRegion(
            center: .init(latitude: 0.0, longitude: 0.0),
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        
        var annotations: [PinAnnotation] = []
    }
    
    var viewState: ViewState
}
