//
//  WGRestClientRequest.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/2/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

class WGRestClientRequest {
    var dataRequest: URLRequest?
    
    init(request: URLRequest) {
        self.dataRequest = request
    }
}
