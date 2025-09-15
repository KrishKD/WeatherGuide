//
//  WGWeather.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

struct WGWeather: Codable {
    let id: UUID = UUID()
    let latitude: Float
    let longitude: Float
    let timezone: String
    let timezoneOffset: Int
    let current: CurrentWeather
    let daily: [Daily]
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case timezone, current, daily
        case timezoneOffset = "timezone_offset"
    }
}

extension WGWeather: Hashable {
    static func == (lhs: WGWeather, rhs: WGWeather) -> Bool {
        lhs.id == rhs.id
    }
}

struct CurrentWeather: Codable {
    let id: UUID = UUID()
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Float
    let feelsLike: Float
    let pressure: Int
    let humidity: Int
    let dewPoint: Float
    let uvi: Float
    let clouds: Int
    let visibility: Int
    let windSpeed: Float
    let windDeg: Int
    let windGust: Float?
    let rain: Float?
    let snow: Float?
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case rain, snow, weather
    }
}

extension CurrentWeather: Hashable {
    static func == (lhs: CurrentWeather, rhs: CurrentWeather) -> Bool {
        lhs.id == rhs.id
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let desc: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, main, icon
        case desc = "description"
    }
}

extension Weather: Hashable {
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        lhs.id == rhs.id
    }
}

struct Daily: Codable {
    let id: UUID = UUID()
    let dt: Int
    let sunrise, sunset: Int
    let moonrise, moonset: Int
    let moonPhase: Float
    let summary: String?
    let temp: Temperature
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double?
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let uvi: Double

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case summary, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, uvi
    }
}

extension Daily: Hashable {
    static func == (lhs: Daily, rhs: Daily) -> Bool {
        lhs.id == rhs.id
    }
}

struct Temperature: Codable {
    let id: UUID = UUID()
    let day: Float
    let min: Float
    let max: Float
    let night: Float
    let evening: Float
    let morning: Float
    
    enum CodingKeys: String, CodingKey {
        case day, min, max, night
        case evening = "eve"
        case morning = "morn"
    }
}

extension Temperature: Hashable {
    static func == (lhs: Temperature, rhs: Temperature) -> Bool {
        lhs.id == rhs.id
    }
}

struct FeelsLike: Codable {
    let id: UUID = UUID()
    let day: Float
    let night: Float
    let evening: Float
    let morning: Float
    
    enum CodingKeys: String, CodingKey {
        case day, night
        case evening = "eve"
        case morning = "morn"
    }
}

extension FeelsLike: Hashable {
    static func == (lhs: FeelsLike, rhs: FeelsLike) -> Bool {
        lhs.id == rhs.id
    }
}
