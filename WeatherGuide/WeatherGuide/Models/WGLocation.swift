//
//  WGLocation.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/4/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation
import MapKit
class WGLocation: NSObject, NSCoding {

    var id: Int?
    var timestamp: TimeInterval?
    var weather: WGWeatherModel?
    var forecast: WGForecastModel?
    
    private let idDef = "id"
    private let timestampDef = "timestamp"
    private let weatherDef = "weather"
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: idDef)
        aCoder.encode(timestamp, forKey: timestampDef)
        aCoder.encode(weather, forKey: weatherDef)
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: idDef) as? Int
        timestamp  = aDecoder.decodeObject(forKey: timestampDef) as? TimeInterval
        weather = aDecoder.decodeObject(forKey: weatherDef) as? WGWeatherModel
    }
    
    init(id: Int?, timeStamp: TimeInterval?, weather: WGWeatherModel?) {
        self.id = id
        self.timestamp = timeStamp
        self.weather = weather
        super.init()
    }
}
