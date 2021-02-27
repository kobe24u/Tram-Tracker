//
//  Tram.swift
//  HomeTime
//
//  Created by Vinnie Liu on 26/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Foundation

struct Tram: Codable {
    //We can't make sure each request can return a valid token value, thus we make it optional
    //for better error handling
    let destination: String?
    let arrivalDate: String?
    let routeNo: String?

    private enum CodingKeys : String, CodingKey {
        case routeNo = "RouteNo"
        case arrivalDate = "PredictedArrivalDateTime"
        case destination = "Destination"
    }
}
