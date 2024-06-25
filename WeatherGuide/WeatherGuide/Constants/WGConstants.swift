//
//  WGConstants.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/2/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

struct WGURL {
    static let endpoint: String = "https://api.openweathermap.org/data/3.0/"
}

struct API {
    static let key: String = "497358898c20ed18f085bd4ecc7c17c4"
    static let currentWeather: String = "onecall"
}

class WGSpacer {
    static let xxs: CGFloat = 2.0
    static let xs: CGFloat = 4.0
    static let small: CGFloat = 8.0
    static let medium: CGFloat = 16.0
    static let large: CGFloat = 32.0
    static let extraLarge: CGFloat = 64.0
}

struct Strings {
    static let temperatureSymbol = "°F"
}
