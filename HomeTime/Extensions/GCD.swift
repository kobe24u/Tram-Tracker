//
//  GCD.swift
//  HomeTime
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Foundation

typealias Dispatch = DispatchQueue

//Avoid tedious long name
extension Dispatch {

    static func background(_ task: @escaping () -> ()) {
        Dispatch.global(qos: .background).async {
            task()
        }
    }

    static func main(_ task: @escaping () -> ()) {
        Dispatch.main.async {
            task()
        }
    }
}
