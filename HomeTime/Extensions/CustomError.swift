//
//  CustomError.swift
//  HomeTime
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Foundation

//Custom Error class to show custom error message to the user
public class CustomError: LocalizedError {

    public let errorDescription: String?

    public init(errorDescription: String? = nil) {
        self.errorDescription = errorDescription
    }
}
