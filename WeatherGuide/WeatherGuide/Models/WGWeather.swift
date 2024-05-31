//
//  WGWeather.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

struct WGWeather: Codable {
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

struct CurrentWeather: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Decimal
    let feelsLike: Decimal
    let pressure: Int
    let humidity: Int
    let dewPoint: Decimal
    let uvi: Decimal
    let clouds: Int
    let visibility: Int
    let windSpeed: Decimal
    let windDeg: Int
    let windGust: Decimal?
    let rain: Decimal?
    let snow: Decimal?
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

struct Daily: Codable {
    let dt: Int
    let sunrise, sunset: Int
    let moonrise, moonset: Int
    let moonPhase: Decimal
    let summary: String
    let temp: Temperature
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let clouds, pop: Int
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

struct Temperature: Codable {
    let day: Decimal
    let min: Decimal
    let max: Decimal
    let night: Decimal
    let evening: Decimal
    let morning: Decimal
    
    enum CodingKeys: String, CodingKey {
        case day, min, max, night
        case evening = "eve"
        case morning = "morn"
    }
}

struct FeelsLike: Codable {
    let day: Decimal
    let night: Decimal
    let evening: Decimal
    let morning: Decimal
    
    enum CodingKeys: String, CodingKey {
        case day, night
        case evening = "eve"
        case morning = "morn"
    }
}
