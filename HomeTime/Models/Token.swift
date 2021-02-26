//
//  Token.swift
//  HomeTime
//
//  Created by Vinnie Liu on 26/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Foundation

struct Token: Codable {
    
    //responseObject contains two fields, but we are only interested in the token
    //We can't make sure each request can return a valid token value, thus we make it optional
    //for better error handling
    let token: String?
    
    private enum CodingKeys: String, CodingKey {
        case token = "DeviceToken"
    }
}
