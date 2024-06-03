//
//  WGPointAnnotation.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/4/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import UIKit
import MapKit
import SwiftUI

class WGPointAnnotation: MKPointAnnotation {
    var pinImageName: String?
}

struct PinAnnotation: Identifiable {
    let coordinates: CLLocationCoordinate2D
    var id: Int {
        return Hasher().finalize()
    }
}
