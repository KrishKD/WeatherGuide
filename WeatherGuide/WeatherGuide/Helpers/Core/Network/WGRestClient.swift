//
//  WGRestClient.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/2/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

class WGRestClient {
    static let defaultRestSession: WGRestClientSession = WGRestClientSession.defaultSession
    static var dataTask: URLSessionDataTask?
    
    private init() {
        //Restrict POSRestClient intialization
    }
    
    internal static func apiRequest(api: APICallAttributes) -> WGRestClientRequest? {
        
        let url: String = WGURL.endpoint + api.endPoint + "?" + api.parameter
        if let request = defaultRestSession.request(withURL: url) {
            return request
        } else {
            return nil
        }
    }
    
    public static func dataRequestAPICall(api: APICallAttributes,
                                          onSuccess: @escaping APISuccessHandler,
                                          onError: @escaping APIErrorHandler){
        //Setup Request object
        let clientRequest = apiRequest(api: api)
        
        //Throw error if request object is not valid
        guard let wgRequest = clientRequest, let dataRequest = wgRequest.dataRequest, let session = defaultRestSession.session else {
            onError(RestClientErrorMessage.nullRequestObject)
            return
        }
        
        //Make request
        dataTask = session.dataTask(with: dataRequest, completionHandler: { (data, response, error) in
            
            if let error = error as NSError? {
                onError(error.localizedDescription)
            } else {
                guard response != nil else {
                    onError(RestClientErrorMessage.nullResponseObject)
                    return
                }
                
                if let data = data {
                    onSuccess(data)
                }
            }
        })
        
        dataTask?.resume()
    }
}
