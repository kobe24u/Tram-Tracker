//
//  TokenManagerSpec.swift
//  HomeTimeTests
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Quick
import Nimble
@testable import HomeTime

class TokenManagerSpec: QuickSpec {
    override func spec() {
        describe("Token Manager") {
            
            var apiManager: APIManager!
            
            beforeEach {
                apiManager = APIManager.shared
            }
            
            afterEach {
                apiManager = nil
            }
            
            it("fetch token with a valid URL") {
                waitUntil(timeout: 3) { done in
                    let urlString = APIEndpoints.fetchToken.absoluteURLString()
                    apiManager.makeGetRequest(urlString) { (result: Result<[Token], Error>) in
                        switch result {
                            case .failure(let error):
                                expect(error).notTo(beNil())
                            case .success(let tokens):
                                expect(tokens.count).to(beGreaterThanOrEqualTo(1))
                        }
                        done()
                    }
                }
            }
            
            it("fetch token with an invalid URL") {
                waitUntil(timeout: 3) { done in
                    let urlString = "http://ws3.tramtracker.com.au/TramTracker/RestService/GetDeviceToken/?aid=TTIOSJSON&devInfo="
                    apiManager.makeGetRequest(urlString) { (result: Result<[Token], Error>) in
                        switch result {
                            case .failure(let error):
                                expect(error).notTo(beNil())
                            case .success(let tokens):
                                expect(tokens.count).to(beGreaterThanOrEqualTo(1))
                        }
                        done()
                    }
                }
            }
        }
    }
}
