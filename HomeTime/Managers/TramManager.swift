//
//  TramManager.swift
//  HomeTime
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Foundation

class TramManager {
    private let apiManager = APIManager.shared
    
    func fetchTrams(stopID: String, completionHandler: @escaping (Result<[Tram], Error>) -> Void) {

        guard let token = UserDefaults.standard.tokenKey else {
            completionHandler(.failure(CustomError(errorDescription: Constants.Error.failedtoGetLocalStoredToken)))
            return
        }
        
        let urlString = APIEndpoints.fetchTrams(token: token, stopId: stopID).absoluteURLString()
        
        apiManager.makeGetRequest(urlString) { (result: Result<[Tram], Error>) in
            switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
                    return
                case .success(let trams):
                    completionHandler(.success(trams))
            }
        }
    }
}
