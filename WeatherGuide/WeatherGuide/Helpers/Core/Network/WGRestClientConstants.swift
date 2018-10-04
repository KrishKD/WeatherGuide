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
typealias APIErrorHandler = (WGRestError) -> Void
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

enum RestClientErrorCodes {
    static let emptyJSON: Int = 1000
    static let nullRequestObject: Int = 1001
    static let nullResponseObject: Int = 1002
}

enum RestClientErrorMessage {
    static let emptyJSON: String =  "EMPTY JSON RESPONSE"
    static let nullRequestObject: String = "Request object as null"
    static let nullResponseObject: String = "Response object as null"
}
