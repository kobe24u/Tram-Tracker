//
//  APIManager.swift
//  HomeTime
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Foundation

protocol APIManagerType {
    //Made a generic API get request to cater for both Token and Tram API requests
    func makeGetRequest<T: Codable>(_ urlString: String, completionHandler:  @escaping (Result<[T], Error>) -> Void)
}

class APIManager: APIManagerType{
    
    var session: URLSession
    
    //Singleton
    static let shared = APIManager.init()

    private init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    //Generic get request can handle all the get requests
    func makeGetRequest<T: Codable>(_ urlString: String, completionHandler: @escaping (Result<[T], Error>) -> Void) {
        guard let url = URL(string: urlString) else {return}
        
        session.dataTask(with: url, completionHandler: { (data, response, error) in
            Dispatch.main {
                completionHandler(self.handleAPIResponse(data: data, urlResponse: response, error: error))
            }
        }).resume()
    }
    
    //Make it an independent method to avoid endless bracket pyramids
    private func handleAPIResponse<T: Codable>(data: Data?, urlResponse: URLResponse?, error: Error?) -> (Result<[T], Error>){
        if error != nil {
            if let err = error{
                return .failure(CustomError(errorDescription: "\(Constants.Error.requestFailWithValidError) \(err.localizedDescription)"))
            }
            return .failure(CustomError(errorDescription: Constants.Error.requestFailWithNilError))
        } else {
            guard let data = data else {
                return .failure(CustomError(errorDescription: Constants.Error.dataMissing))
            }
            do {
                let jsonResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
                if jsonResponse.hasError == true {
                    return .failure(CustomError(errorDescription: jsonResponse.errorMessage ?? Constants.Error.hasErrorButNoErrorMsg))
                }
                return .success(jsonResponse.responseObject)
            } catch {
                return .failure(CustomError(errorDescription: "\(Constants.Error.unknownError) \(error.localizedDescription)"))
            }
        }
    }
}
