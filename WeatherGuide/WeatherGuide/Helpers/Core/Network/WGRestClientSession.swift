//
//  WGRestClientSession.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/2/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

final class WGRestClientSession {
    public var session: URLSession?
    public static let defaultSession: WGRestClientSession = WGRestClientSession()
    
    //Configure URLSession
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20.0
        configuration.requestCachePolicy = .useProtocolCachePolicy
        session = URLSession(configuration: configuration)
    }
    
    //Configure URLRequest
    public func request(withURL url: String, params: [String: Any?]) -> WGRestClientRequest? {
        guard var components = URLComponents(string: url), let session = session else {
            return nil
        }
        
        let queryItems = APIHelper.mapValuesToQueryParams(params)
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else { return nil }
        
        let request = URLRequest(url: url,
                                 cachePolicy: session.configuration.requestCachePolicy,
                                 timeoutInterval: session.configuration.timeoutIntervalForRequest)
        
        return WGRestClientRequest(request: request)
    }
}
