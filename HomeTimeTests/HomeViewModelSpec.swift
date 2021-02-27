//
//  HomeViewModelSpec.swift
//  HomeTimeTests
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Quick
import Nimble
@testable import HomeTime

class HomeViewModelSpec: QuickSpec {
    override func spec() {
        describe("ViewModel of the home list page") {
            
            var viewModel: HomeViewModel!
            
            beforeEach {
                viewModel = HomeViewModel(tokenManager: TokenManager(), tramManager: TramManager())
            }
            
            afterEach {
                viewModel = nil
            }
            
            it("navigation bar title") {
                expect(viewModel.title).to(equal("Upcoming Trams"))
            }
            
            it("north tram section header title") {
                expect(viewModel.northTramSectionTitle).to(equal("North"))
            }
            
            it("south tram section header title") {
                expect(viewModel.southTramsSectionTitle).to(equal("South"))
            }
            
            it("tram tableview section number") {
                expect(viewModel.numberOfSections()).to(equal(2))
            }
            
            it("fetch token") {
                waitUntil(timeout: 3) { done in
                    viewModel.fetchToken { (result) in
                        switch result {
                        case .success():
                            let localStoredToken = UserDefaults.standard.tokenKey
                            expect(localStoredToken).notTo(beNil())
                        case let .failure(error):
                            expect(error).notTo(beNil())
                        }
                        done()
                    }
                }
            }
            
            it("fetch south tram stop") {
                waitUntil(timeout: 3) { done in
                    viewModel.fetchTramStopsByDirection(direction: .south, completion: { result in
                            expect(viewModel.loadingSouth).to(beFalse())
                            switch result {
                                case .success():
                                    expect(viewModel.southTrams?.count).to(beGreaterThanOrEqualTo(1))
                                case let .failure(error):
                                    expect(error).notTo(beNil())
                            }
                            done()
                    })
                }
            }
            
            it("fetch north tram stop") {
                waitUntil(timeout: 3) { done in
                    viewModel.fetchTramStopsByDirection(direction: .north, completion: { result in
                            expect(viewModel.loadingNorth).to(beFalse())
                            switch result {
                                case .success():
                                    expect(viewModel.northTrams?.count).to(beGreaterThanOrEqualTo(1))
                                case let .failure(error):
                                    expect(error).notTo(beNil())
                            }
                            done()
                    })
                }
            }

        }
    }
}
