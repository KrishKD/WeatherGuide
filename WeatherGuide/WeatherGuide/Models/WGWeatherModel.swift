//
//  WGWeather.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

class WGWeatherModel: Codable {
    var coord: Coordinates?
    var weather: [Weather]?
    var base: String?
    var main: Temperature?
    var clouds: [String: Int]?
    var wind: Wind?
    var rain: [String: Float]?
    var snow: [String: Float]?
    var dt: Int?
    var sys: System?
    var id: Int?
    var name: String?
    var dt_txt: String?
}

class Coordinates: Codable {
    var lat: Float?
    var lon: Float?
}

class Weather: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

class Wind: Codable {
    var speed: Float?
    var deg: Float?
}

class Temperature: Codable {
    var temp: Float?
    var pressure: Float?
    var humidity: Int?
    var temp_min: Float?
    var temp_max: Float?
    var sea_level: Float?
    var grnd_level: Float?
    var temp_kf: Float?
}

class System: Codable {
    var message: Float?
    var sunrise: Int?
    var sunset: Int?
    var pod: String?
}
