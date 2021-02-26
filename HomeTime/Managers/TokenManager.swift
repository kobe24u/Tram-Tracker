//
//  TokenManager.swift
//  HomeTime
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Foundation

class TokenManager {
    private let apiManager = APIManager.shared
    
    func fetchToken(completionHandler: @escaping (Result<Token, Error>) -> Void) {

        let urlString = APIEndpoints.fetchToken.absoluteURLString()
        
        apiManager.makeGetRequest(urlString) { (result: Result<[Token], Error>) in
            switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
                    return
                case .success(let tokens):
                    if let token = tokens.first{
                        completionHandler(.success(token))
                    }else{
                        completionHandler(.failure(CustomError(errorDescription: "Request succeeded, but failed to extract the token")))
                    }
            }
        }
    }
}
