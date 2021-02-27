//
//  TramManagerSpec.swift
//  HomeTimeTests
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Quick
import Nimble
@testable import HomeTime

class TramManagerSpec: QuickSpec {
    override func spec() {
        describe("Tram Manager") {
            
            var apiManager: APIManager!
            
            beforeEach {
                apiManager = APIManager.shared
            }
            
            afterEach {
                apiManager = nil
            }
            
            it("fetch trams with a valid URL") {
                waitUntil(timeout: 3) { done in
                    let stopId = 4055
                    let urlString =  "http://ws3.tramtracker.com.au/TramTracker/RestService/GetNextPredictedRoutesCollection/\(stopId)/78/false/?aid=TTIOSJSON&cid=2&tkn=d32413c6-a1b3-4bf4-9009-1b29b3fa9588"
                    
                    apiManager.makeGetRequest(urlString) { (result: Result<[Tram], Error>) in
                        switch result {
                            case .failure(let error):
                                expect(error).notTo(beNil())
                            case .success(let trams):
                                expect(trams.count).to(beGreaterThanOrEqualTo(1))
                        }
                        done()
                    }
                }
            }
            
            it("fetch trams with an invalid URL") {
                waitUntil(timeout: 3) { done in
                    let stopId = 0000
                    let urlString =  "http://ws3.tramtracker.com.au/TramTracker/RestService/GetNextPredictedRoutesCollection/\(stopId)/78/false/?aid=TTIOSJSON&cid=2&tkn=d32413c6-a1b3-4bf4-9009-1b29b3fa9588"
                    apiManager.makeGetRequest(urlString) { (result: Result<[Tram], Error>) in
                        switch result {
                            case .failure(let error):
                                expect(error).notTo(beNil())
                            case .success(let trams):
                                expect(trams.count).to(beGreaterThanOrEqualTo(1))
                        }
                        done()
                    }
                }
            }
        }
    }
}
