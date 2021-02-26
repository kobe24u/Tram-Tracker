//
//  UserDefaults.swift
//  HomeTime
//
//  Created by Vinnie Liu on 26/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Foundation

//Use protocol to make sure if in the future we have more values need to store, just change this
//Xcode will throw error to remind us to add getter and setters to conform to this protocol
protocol UserDefaultsType {
    var tokenKey: String? { get set }
}

//Once we retrived the token, we store it using UserDefaults, so we can get access to the token easily later
extension UserDefaults: UserDefaultsType {
    
    private struct Key {
        static var tokenKey = "App.token.key"
    }

    var tokenKey: String? {
        get {
            return object(forKey: UserDefaults.Key.tokenKey) as? String
        }
        set {
            set(newValue, forKey: UserDefaults.Key.tokenKey)
        }
    }
}
