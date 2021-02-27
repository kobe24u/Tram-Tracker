//
//  APIEndpoints.swift
//  HomeTime
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Foundation

public protocol EndpointsType {
    func absoluteURLString() -> String
}

enum APIEndpoints: EndpointsType {
    
    // API Endpoints, made it en enum, so if we need to do more API calls, just need to add here
    case fetchToken
    case fetchTrams(token:String, stopId:String)
    
    func absoluteURLString() -> String {
        var childPath = ""
        switch (self) {
        case .fetchToken:
            childPath = Constants.APIEndpoints.tokenChildPath
        case .fetchTrams(let token,let stopId):
            childPath = "/GetNextPredictedRoutesCollection/\(stopId)/78/false/?aid=TTIOSJSON&cid=2&tkn=\(token)"
        }
        return Constants.APIEndpoints.baseURL + childPath
    }
}

