//
//  UITableView.swift
//  HomeTime
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    public func register(forClass aClass: AnyClass) {
        let className = String(describing: aClass)
        register(UINib(nibName: className, bundle: Bundle.main), forCellReuseIdentifier: className)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(forClass aClass: AnyClass) -> T {
        let className = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: className) as? T else {
            fatalError("Cannot deque cell for class \(aClass)")
        }
        return cell
    }
}
