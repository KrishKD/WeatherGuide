//
//  WGError.swift
//  WeatherGuide
//
//  Created by krishna on 5/29/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

struct ErrorInfo: Equatable {
    public init(errorCode: String, errorTitle: String, errorMessage: String) {
        self.errorCode = errorCode
        self.errorTitle = errorTitle
        self.errorMessage = errorMessage
    }

    public let errorCode: String
    public let errorTitle: String
    public let errorMessage: String
}

enum WGError: Error, Equatable {
    case invalidLocation
    case invalidRequest
    case notConnected
    case invalidResponse
    case jsonParseError
    case generic(error: ErrorInfo)
    case genericMessage(errorMsg: String)
    
    var errorMessage: String {
        switch self {
        case .invalidLocation:
            "Unable to fetch location details"
        case .notConnected:
            "No internet connection"
        case .invalidRequest, .invalidResponse, .jsonParseError:
            "Unable to fetch weather details"
        case .generic(let error):
            error.errorMessage
        case .genericMessage(let errorMsg):
            errorMsg
        }
    }
}
