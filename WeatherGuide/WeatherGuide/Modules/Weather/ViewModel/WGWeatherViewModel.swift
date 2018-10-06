//
//  WGWeatherViewModel.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/3/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

protocol WGWeatherViewModelProtocol: class {
    func dataSaveFailed(errorMsg: String)
}

class WGWeatherViewModel {
    var locations: [WGLocation] = []
    private let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    weak var delegate: WGWeatherViewModelProtocol?
    
    //Fetch current weather data
    func getCurrentWeatherData(params: String,
                               onSuccess: @escaping ([WGLocation]) -> Void,
                               onFailure: @escaping (String) -> Void) {
        WGDataManager.getCurrentWeather(params: params, onSuccess: { (weather) in
            
            var timestamp: TimeInterval?
            if let unixTimestamp = weather.dt {
                timestamp = TimeInterval(unixTimestamp)
            }
            let location = WGLocation(id: weather.id, timeStamp: timestamp, weather: weather)
            
            //Check if the datasource already has an entry with the same cityId. If yes, replace it.
            if let duplicateItemIndex = self.locations.firstIndex(where: { $0.id == location.id }) {
                self.locations[duplicateItemIndex] = location
            } else {
                self.locations.append(location)
            }
            
            //Archive the new data asynchronously in background thread
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
        
        //After deleting a location, archive the data asynchronously in background thread
        DispatchQueue.global(qos: .background).async {
            self.saveLocationData()
        }
    }
    
    //Archive locations added by user
    func saveLocationData() {
        if var path = self.documentsPath {
            path += "/locationData"
            
            if !NSKeyedArchiver.archiveRootObject(self.locations, toFile: path) {
                //Call delegate incase of failure while archiving
                delegate?.dataSaveFailed(errorMsg: "Unable to save the data to disk. You may loose any saved data.")
            }
        }
    }
    
    //Retrieve archived data
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
