//
//  APIHelper.swift
//  WeatherGuide
//
//  Created by krishna on 5/31/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

class APIHelper {
    static func mapValuesToQueryParams(_ items: [String: Any?]) -> [URLQueryItem] {
        let queryItems = items.filter({ $0.value != nil }).reduce(into: [URLQueryItem]()) { (result, item) in
            if let collection = item.value as? Array<Any?> {
                let value = collection.filter({ $0 != nil }).map({"\($0!)"}).joined(separator: ",")
                result.append(URLQueryItem(name: item.key, value: value))
            } else if let value = item.value {
                result.append(URLQueryItem(name: item.key, value: "\(value)"))
            }
        }
        
        if queryItems.isEmpty {
            return []
        }
        return queryItems
    }
}
