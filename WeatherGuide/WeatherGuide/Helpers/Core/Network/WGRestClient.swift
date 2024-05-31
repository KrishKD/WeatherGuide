//
//  WGRestClient.swift
//  WeatherGuide
//
//  Created by Devaraj, Krishna Kumar on 10/2/18.
//  Copyright © 2018 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

final class WGRestClient<T: Decodable> {
    let defaultRestSession: WGRestClientSession = WGRestClientSession.defaultSession
    var dataTask: URLSessionDataTask?
    
    internal func apiRequest(api: APICallAttributes) -> WGRestClientRequest? {
        let url: String = WGURL.endpoint + api.endPoint
        
        guard let request = defaultRestSession.request(withURL: url, params: api.parameter) else {
            return nil
        }
        
        return request
    }
    
    public func dataRequestAPICall(
        api: APICallAttributes,
        completion: @escaping (Result<WGResponse<T>, WGErrorResponse>) -> Void
    ) where T : Decodable {
        //Setup Request object
        let clientRequest = apiRequest(api: api)
        
        //Throw error if request object is invalid
        guard let wgRequest = clientRequest, 
              let dataRequest = wgRequest.dataRequest,
              let session = defaultRestSession.session else {
            return completion(.failure(.invalidRequest()))
        }
        
        //Make request
        dataTask = session.dataTask(with: dataRequest, completionHandler: { (data, response, error) in
            let response: Result<WGResponse<T>, WGErrorResponse> = self.processResponse(data: data, response: response, error: error)
            
            switch response {
            case .success(let responseObject):
                completion(.success(responseObject))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        
        dataTask?.resume()
    }
    
    private func processResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<WGResponse<T>, WGErrorResponse> {
        guard error == nil else {
            return .failure(processError(data: data, response: response, error: error))
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data else {
            return .failure(processError(data: data, response: response, error: error))
        }
        
        do {
            let responseObject = try JSONDecoder().decode(T.self, from: data)
            return .success(WGResponse(statusCode: httpResponse.statusCode,
                                       header: httpResponse.allHeaderFields as? [String: String] ?? [:],
                                       body: responseObject))
        } catch let error {
            return .failure(.jsonParseError())
        }
    }
    
    private func processError(
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) -> WGErrorResponse {
        guard let httpResponse = response as? HTTPURLResponse else {
            return WGErrorResponse(statusCode: nil, data: data, error: error)
        }
        
        let statusCode = httpResponse.statusCode
        
        return .init(statusCode: statusCode, data: data, error: error)
    }
}
