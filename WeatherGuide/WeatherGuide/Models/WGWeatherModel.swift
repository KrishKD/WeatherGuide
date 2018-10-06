//
//  WGWeather.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

class WGWeatherModel: NSObject, Codable, NSCoding {
    
    var coord: Coordinates?
    var weather: [Weather]?
    var base: String?
    var main: Temperature?
    var clouds: [String: Int]?
    var wind: Wind?
    var rain: [String: Float]?
    var snow: [String: Float]?
    var dt: Double?
    var sys: System?
    var id: Int?
    var name: String?
    var dt_txt: String?
    
    private let coordDef = "coord"
    private let weatherDef = "weather"
    private let baseDef = "base"
    private let mainDef = "main"
    private let cloudsDef = "clouds"
    private let windDef = "wind"
    private let rainDef = "rain"
    private let snowDef = "snow"
    private let dtDef = "dt"
    private let sysDef = "sys"
    private let idDef = "id"
    private let nameDef = "name"
    private let dtTxtDef = "dt_txt"
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(coord, forKey: coordDef)
        aCoder.encode(weather, forKey: weatherDef)
        aCoder.encode(base, forKey: baseDef)
        aCoder.encode(main, forKey: mainDef)
        aCoder.encode(clouds, forKey: cloudsDef)
        aCoder.encode(wind, forKey: windDef)
        aCoder.encode(rain, forKey: rainDef)
        aCoder.encode(snow, forKey: snowDef)
        aCoder.encode(dt, forKey: dtDef)
        aCoder.encode(sys, forKey: sysDef)
        aCoder.encode(id, forKey: idDef)
        aCoder.encode(name, forKey: nameDef)
        aCoder.encode(dt_txt, forKey: dtTxtDef)
    }
    
    required init?(coder aDecoder: NSCoder) {
        coord = aDecoder.decodeObject(forKey: coordDef) as? Coordinates
        weather = aDecoder.decodeObject(forKey: weatherDef) as? [Weather]
        base = aDecoder.decodeObject(forKey: baseDef) as? String
        main = aDecoder.decodeObject(forKey: mainDef) as? Temperature
        clouds = aDecoder.decodeObject(forKey: cloudsDef) as? [String: Int]
        wind = aDecoder.decodeObject(forKey: windDef) as? Wind
        rain = aDecoder.decodeObject(forKey: rainDef) as? [String: Float]
        snow = aDecoder.decodeObject(forKey: snowDef) as? [String: Float]
        dt = aDecoder.decodeObject(forKey: dtDef) as? Double
        sys = aDecoder.decodeObject(forKey: sysDef) as? System
        id = aDecoder.decodeObject(forKey: idDef) as? Int
        name = aDecoder.decodeObject(forKey: nameDef) as? String
        dt_txt = aDecoder.decodeObject(forKey: dtTxtDef) as? String
    }
}

class Coordinates: NSObject, Codable, NSCoding {
    var lat: Float?
    var lon: Float?
    
    private let latDef = "lat"
    private let lonDef = "lon"
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(lat, forKey: latDef)
        aCoder.encode(lon, forKey: lonDef)
    }
    
    required init?(coder aDecoder: NSCoder) {
        lat = aDecoder.decodeObject(forKey: latDef) as? Float
        lon = aDecoder.decodeObject(forKey: lonDef) as? Float
    }
}

class Weather: NSObject, Codable, NSCoding {
    var id: Int?
    var main: String?
    var icon: String?
    
    private let idDef = "id"
    private let mainDef = "main"
    private let descriptionDef = "desc"
    private let iconDef = "icon"
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: idDef)
        aCoder.encode(main, forKey: mainDef)
        //aCoder.encode(description, forKey: descriptionDef)
        aCoder.encode(icon, forKey: iconDef)
    }
    
    required init?(coder aDecoder: NSCoder) {
        id =  aDecoder.decodeObject(forKey: idDef) as? Int
        main =  aDecoder.decodeObject(forKey: mainDef) as? String        
        icon =  aDecoder.decodeObject(forKey: iconDef) as? String
    }
}

class Wind: NSObject, Codable, NSCoding {
    var speed: Float?
    var deg: Float?
    
    private let speedDef = "speed"
    private let degDef = "deg"
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(speed, forKey: speedDef)
        aCoder.encode(deg, forKey: degDef)
    }
    
    required init?(coder aDecoder: NSCoder) {
        speed = aDecoder.decodeObject(forKey: speedDef) as? Float
        deg = aDecoder.decodeObject(forKey: degDef) as? Float
    }
    
}

class Temperature: NSObject, Codable, NSCoding {
    var temp: Float?
    var pressure: Float?
    var humidity: Int?
    var temp_min: Float?
    var temp_max: Float?
    var sea_level: Float?
    var grnd_level: Float?
    var temp_kf: Float?
    
    private let tempDef = "temp"
    private let pressureDef = "pressure"
    private let humidityDef = "humidity"
    private let tempMinDef = "temp_min"
    private let tempMaxDef = "temp_max"
    private let seaLevelDef = "sea_level"
    private let grndLevelDef = "grnd_level"
    private let tempkfDef = "temp_kf"
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(temp, forKey: tempDef)
        aCoder.encode(pressure, forKey: pressureDef)
        aCoder.encode(humidity, forKey: humidityDef)
        aCoder.encode(temp_min, forKey: tempMinDef)
        aCoder.encode(temp_max, forKey: tempMaxDef)
        aCoder.encode(sea_level, forKey: seaLevelDef)
        aCoder.encode(grnd_level, forKey: grndLevelDef)
        aCoder.encode(temp_kf, forKey: tempkfDef)
    }
    
    required init?(coder aDecoder: NSCoder) {
        temp = aDecoder.decodeObject(forKey: tempDef) as? Float
        pressure = aDecoder.decodeObject(forKey: pressureDef) as? Float
        humidity =  aDecoder.decodeObject(forKey: humidityDef) as? Int
        temp_min =  aDecoder.decodeObject(forKey: tempMinDef) as? Float
        temp_max =  aDecoder.decodeObject(forKey: tempMaxDef) as? Float
        sea_level =  aDecoder.decodeObject(forKey: seaLevelDef) as? Float
        grnd_level =  aDecoder.decodeObject(forKey: grndLevelDef) as? Float
        temp_kf =  aDecoder.decodeObject(forKey: tempkfDef) as? Float
    }
}

class System: NSObject, Codable, NSCoding {
    var message: Float?
    var sunrise: Int?
    var sunset: Int?
    var pod: String?
    
    private let msgDef = "message"
    private let sunriseDef = "sunrise"
    private let sunsetDef = "sunset"
    private let podDef = "pod"
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(message, forKey: msgDef)
        aCoder.encode(sunrise, forKey: sunriseDef)
        aCoder.encode(sunset, forKey: sunsetDef)
        aCoder.encode(pod, forKey: podDef)
    }
    
    required init?(coder aDecoder: NSCoder) {
        message = aDecoder.decodeObject(forKey: msgDef) as? Float
        sunrise =  aDecoder.decodeObject(forKey: sunriseDef) as? Int
        sunset =  aDecoder.decodeObject(forKey: sunsetDef) as? Int
        pod =  aDecoder.decodeObject(forKey: podDef) as? String
    }
}
