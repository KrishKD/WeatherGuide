//
//  WGWeatherViewModel.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

class WGWeatherViewModel {
    var locations: [WGLocation] = []
    private let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    
    func getCurrentWeatherData(params: String,
                               onSuccess: @escaping ([WGLocation]) -> Void,
                               onFailure: @escaping (String) -> Void) {
        WGDataManager.getCurrentWeather(params: params, onSuccess: { (weather) in
            
            var timestamp: TimeInterval?
            if let unixTimestamp = weather.dt {
                timestamp = TimeInterval(unixTimestamp)
            }
            let location = WGLocation(id: weather.id, timeStamp: timestamp, weather: weather)
            
            if let duplicateItemIndex = self.locations.firstIndex(where: { $0.id == location.id }) {
                self.locations[duplicateItemIndex] = location
            } else {
                self.locations.append(location)
            }
            
            DispatchQueue.global(qos: .background).async {
                self.saveLocationData()
            }
            
            onSuccess(self.locations)
        }) { (error) in
            onFailure(error)
        }
    }
    
    func removeLocationObject(atIndex index: Int) {
        self.locations.remove(at: index)
        
        DispatchQueue.global(qos: .background).async {
            self.saveLocationData()
        }
    }
    
    func saveLocationData() {
        if var path = self.documentsPath {
            path += "/locationData"
            
            if NSKeyedArchiver.archiveRootObject(self.locations, toFile: path) {
                print("Success")
            }
        }
    }
    
    func retrieveLocationData() -> [WGLocation]{
        if var path = self.documentsPath {
            path += "/locationData"
            if let locationList = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [WGLocation] {
                self.locations = locationList
                return locationList
            }
        }
        
        
        return []
    }
}
