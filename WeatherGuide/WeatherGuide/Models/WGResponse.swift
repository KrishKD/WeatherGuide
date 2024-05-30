//
//  WGResponse.swift
//  WeatherGuide
//
//  Created by krishna on 5/29/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

struct WGResponse<T: Decodable> {
    let statusCode: Int
    let header: [String : String]
    let body: T

    init(statusCode: Int, header: [String : String], body: T) {
        self.statusCode = statusCode
        self.header = header
        self.body = body
    }

    init(response: HTTPURLResponse, body: T) {
        self.init(statusCode: response.statusCode,
                  header: response.allHeaderFields as? [String: String] ?? [:],
                  body: body)
    }
}
