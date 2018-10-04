//
//  WGForecastModel.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

class WGForecastModel: Codable {
    var cnt: Int?
    var city: City?
    var list: [WGWeatherModel]?
}

class City: Codable {
    var coord: Coordinates?
    var id: Int?
    var name: String?
    var population: Int?
    var country: String?
}
