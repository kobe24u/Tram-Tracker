//
//  APIResponse.swift
//  HomeTime
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Foundation

struct APIResponse<T: Codable> : Codable {
    var errorMessage: String?
    var hasError: Bool
    var hasResponse: Bool
    var responseObject: [T]
}
