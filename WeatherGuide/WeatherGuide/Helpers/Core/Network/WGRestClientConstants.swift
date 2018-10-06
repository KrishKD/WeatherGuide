//
//  WGRestClientConstants.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/2/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]
typealias APIParameter = String
typealias APISuccessHandler = (Data) -> Void
typealias APIErrorHandler = (String) -> Void
typealias APICallAttributes = (taskType: RestRequestTask, endPoint: String, parameter: APIParameter)

enum RestRequestTask: Int {
    case dataTask
    var type: Int {
        switch self {
        case .dataTask:
            return RestClientTask.data
        }
    }
}

enum RestClientTask {
    static let data: Int = 1000
}

enum RestClientErrorMessage {
    static let nullRequestObject: String = "Request object was null"
    static let nullResponseObject: String = "Response object was null"
}
