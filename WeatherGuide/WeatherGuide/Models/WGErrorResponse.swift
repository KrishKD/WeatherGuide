//
//  WGErrorResponse.swift
//  WeatherGuide
//
//  Created by krishna on 5/29/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

struct WGErrorResponse: Error {
    let statusCode: Int?
    let data: Data?
    let error: Error?
    
    init(statusCode: Int?, data: Data?, error: Error?) {
        self.statusCode = statusCode
        self.data = data
        self.error = error
    }
}

extension WGErrorResponse: Equatable {
    static func == (lhs: WGErrorResponse, rhs: WGErrorResponse) -> Bool {
        return lhs.statusCode == rhs.statusCode &&
               lhs.data == rhs.data &&
               lhs.error?.localizedDescription == rhs.error?.localizedDescription
    }
}

extension WGErrorResponse {
    static func invalidRequest(statusCode: Int? = nil,
                               data: Data? = nil,
                               error: Error? = nil) -> WGErrorResponse {
        let wgError = WGError.invalidRequest
        return .init(statusCode: statusCode, data: data, error: wgError)
    }
    
    static func jsonParseError(statusCode: Int? = nil,
                               data: Data? = nil,
                               error: Error? = nil) -> WGErrorResponse {
        let wgError = WGError.jsonParseError
        return .init(statusCode: statusCode, data: data, error: wgError)
    }
}
