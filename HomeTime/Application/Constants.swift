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
    
    struct Message {
        static let tramLoadingSpinnerTitle = "Loading upcoming trams"
        static let tramMissingTitle = "No upcoming trams. Please refresh"
    }
    
    struct TableViewCellIdentifiers {
        static let detailsCellIdentifier = "TramDetailsTableViewCell"
        static let missingCellIdentifier = "TramMissingTableViewCell"
    }
    
    struct Error {
        static let failedtoExtractToken = "Request succeeded, but failed to extract the token"
        static let failedtoGetLocalStoredToken = "Failed to fetch locally stored token when trying to make API calls"
        static let requestFailWithValidError = "Request error happens, error: "
        static let requestFailWithNilError = "Request error happens, but failed to extract the error message"
        static let dataMissing = "No error, but data is missing"
        static let hasErrorButNoErrorMsg = "Server response indicating error happened, but didn't return any error message"
        static let unknownError = "Unknown error: "
    }
    
    struct Title {
        static let tokenFetchingError = "Something wrong with token fetching"
        static let tramStopFetchingError = "Something wrong with tram stops fetching"
        static let noUpcomingError = "No upcoming trams found"
    }
}
