//
//  HomeViewModel.swift
//  HomeTime
//
//  Created by Vinnie Liu on 26/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Foundation

typealias VoidClosure = () -> Void
typealias Closure<T> = (T) -> Void

enum TableViewSection: Int, CaseIterable {
    case north = 0
    case south = 1
    
    var title: String {
        switch self {
        case .north: return "North"
        case .south: return "South"
        }
    }
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
    func fetchToken(completion: @escaping (Result<Void, Error>) -> Void)
    func fetchTramStopsByDirection(direction: Direction, completion: @escaping (Result<Void, Error>) -> Void)
}

class HomeViewModel: HomeViewModelType{
    
    var northTramSectionTitle: String {
        return Direction.north.rawValue
    }
    
    var southTramsSectionTitle: String {
        return Direction.south.rawValue
    }
    
    func numberOfRowsIn(section: TableViewSection) -> Int {
        switch section {
        case .north:
            guard let count = northTrams?.count else { return 1 }
            return count
        case .south:
            guard let count = southTrams?.count else { return 1 }
            return count
        }
    }
    
    func titleForSection(_ section: TableViewSection) -> String {
        return section.title
    }
    
    func numberOfSections() -> Int {
        TableViewSection.allCases.count
    }
    
    func tramsFor(section: TableViewSection) -> [Tram]? {
        let trams: [Tram]? = section == .north ? northTrams : southTrams
        return trams
    }
    
    func tramFor(section: TableViewSection, row: Int) -> Tram? {
        guard let trams = tramsFor(section: section), trams.count >= 1 else {
            return nil
        }
        return trams[row]
    }
    
    func isLoading(section: TableViewSection) -> Bool {
        let isLoading: Bool = section == .north ? loadingNorth : loadingSouth
        return isLoading
    }
    
    //Everytime an API call is finished, north tram list got refreshed, we will use closure to notify VC to reload the north Section
    var northTrams: [Tram]? = []{
        didSet{
            self.reloadDirectionClosure?(.north)
        }
    }
    
    //Everytime an API call is finished, south tram list got refreshed, we will use closure to notify VC to reload the south Section
    var southTrams: [Tram]? = []{
        didSet{
            self.reloadDirectionClosure?(.south)
        }
    }
    
    var loadingNorth: Bool = false
    var loadingSouth: Bool = false
    
    var noUpComingTramClosure: VoidClosure?
    var reloadDirectionClosure: Closure<Direction>?
    
    private let tokenManager: TokenManager
    private let tramManager: TramManager
    
    //ViewModel will be responsble to talk to managers, get the data ready and notify viewcontroller to render them
    //Initialiser injection
    init(tokenManager: TokenManager, tramManager: TramManager) {
        self.tokenManager = tokenManager
        self.tramManager = tramManager
    }
    
    //reset all local data when user clicks the clear button
    func clearData() {
        northTrams = nil
        southTrams = nil
        loadingNorth = false
        loadingSouth = false
    }
    
    func fetchToken(completion: @escaping (Result<Void, Error>) -> Void) {
        tokenManager.fetchToken { (result) in
            switch result {
                case let .success(tokenObj):
                    UserDefaults.standard.tokenKey = tokenObj.token
                    completion(.success(()))
                case let .failure (error):
                    completion(.failure(error))
            }
        }
    }
    
    func fetchTramStopsByDirection(direction: Direction, completion: @escaping (Result<Void, Error>) -> Void) {

        //Inline operator to make the code cleaner
        let stopID = direction == .north ? Constants.TramStopIds.northStopId : Constants.TramStopIds.southStopId
        
        tramManager.fetchTrams(stopID: stopID) { [weak self] (result) in
            self?.updateLoadingStatus(direction)
            switch result {
                case let .success(trams):
                    self?.updateTramList(direction, trams)
                    completion(.success(()))
                case let .failure (error):
                    completion(.failure(error))
            }
        }
    }
    
    //API call finished, need to upadate loading status
    private func updateLoadingStatus(_ direction: Direction){
        if direction == .north{
            self.loadingNorth = false
        }else{
            self.loadingSouth = false
        }
    }
    
    //Load the server returned tram list into local list and then notify vc to refresh
    private func updateTramList(_ direction: Direction, _ trams: [Tram]){
        guard !trams.isEmpty else {
            self.noUpComingTramClosure?()
            return
        }
        
        if direction == .north{
            self.northTrams = trams
        }else{
            self.southTrams = trams
        }
    }
}
