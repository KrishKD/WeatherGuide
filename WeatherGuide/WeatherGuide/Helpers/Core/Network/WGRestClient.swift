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
        
        let url = WGURL.endpoint + api.endPoint
        if let request = defaultRestSession.request(withURL: url) {
            return request
        } else {
            return nil
        }
    }
    
    public static func dataRequestAPICall(api: APICallAttributes,
                                          onSuccess: @escaping APISuccessHandler,
                                          onError: @escaping APIErrorHandler){
        let clientRequest = apiRequest(api: api)
        
        guard let wgRequest = clientRequest, let dataRequest = wgRequest.dataRequest, let session = defaultRestSession.session else {
            let error = restError(RestClientErrorCodes.nullRequestObject, msg: RestClientErrorMessage.nullRequestObject)
            onError(error)
            return
        }
        
        dataTask = session.dataTask(with: dataRequest, completionHandler: { (data, response, error) in
            if let error = error as NSError? {
                let error = restError(error.code, msg: error.localizedDescription)
                onError(error)
            }
        })
    }
    
    internal static func restError(_ code: Int, msg: String ) -> WGRestError {
        return WGRestError(code, msg)
    }
}
