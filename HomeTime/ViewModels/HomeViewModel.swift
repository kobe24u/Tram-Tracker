//
//  HomeViewModel.swift
//  HomeTime
//
//  Created by Vinnie Liu on 26/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Foundation

enum TableViewSections: Int, CaseIterable {
    case north = 0
    case south = 1
}

enum Direction: String, CaseIterable {
    case north = "North"
    case south = "South"
}


protocol HomeViewModelType {
    var northTramSectionTitle: String { get }
    var southTramsSectionTitle: String { get }

    var northTrams: [Tram]? { get set }
    var southTrams: [Tram]? { get set }
    
    var loadingNorth: Bool { get set }
    var loadingSouth: Bool { get set }
    
    func clearData()
    func fetchToken(completion: @escaping (Result<Token, Error>) -> Void)
    func fetchTramStopsByDirection(direction: Direction, completion: @escaping (Result<[Tram], Error>) -> Void)
}

class HomeViewModel: HomeViewModelType{
    
    var northTramSectionTitle: String {
        return Direction.north.rawValue
    }
    
    var southTramsSectionTitle: String {
        return Direction.south.rawValue
    }
    
    var northTrams: [Tram]? = []
    var southTrams: [Tram]? = []
    
    var loadingNorth: Bool = false
    var loadingSouth: Bool = false
    
    func clearData() {
        northTrams = nil
        southTrams = nil
        loadingNorth = false
        loadingSouth = false
    }
    
    func fetchToken(completion: @escaping (Result<Token, Error>) -> Void) {
        //TODO: call API to fetch token
    }
    
    func fetchTramStopsByDirection(direction: Direction, completion: @escaping (Result<[Tram], Error>) -> Void) {
        //TODO: call API to fetch token
    }
    
    
}
