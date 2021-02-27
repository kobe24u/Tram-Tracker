//
//  Constants.swift
//  HomeTime
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Foundation

struct Constants {
    struct APIEndpoints {
        static let baseURL = "http://ws3.tramtracker.com.au/TramTracker/RestService"
        static let tokenChildPath = "/GetDeviceToken/?aid=TTIOSJSON&devInfo=HomeTimeiOS"
    }
    
    struct TramStopIds {
        static let northStopId = "4055"
        static let southStopId = "4155"
    }
}
