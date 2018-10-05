//
//  WGRestError.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/2/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

class WGRestError {
    let statusCode: Int
    let statusMessage: String
    
    init(_ code: Int, _ msg: String) {
        self.statusCode = code
        self.statusMessage = msg
    }
}
