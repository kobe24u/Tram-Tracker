//
//  HomeViewControllerSpec.swift
//  HomeTimeTests
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Quick
import Nimble
@testable import HomeTime

class HomeViewControllerSpec: QuickSpec {
    override func spec() {
        describe("Home table view holding all tram data") {
            
            var viewController: HomeViewController!
            
            beforeEach {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                viewController.loadViewIfNeeded()
            }
            
            afterEach {
                viewController = nil
            }
            
            it("When no data loaded, table view should have two sections, each section should have one row") {
                let tableView = viewController.tramTimesTable
                expect(tableView).notTo(beNil())
                let northSectionRows = tableView?.numberOfRows(inSection: 0)
                expect(northSectionRows) == 1
                let southSectionRows = tableView?.numberOfRows(inSection: 1)
                expect(southSectionRows) == 1
            }
        
            it("When data got loaded, North section's third row destination should be North Richmond") {
            
                waitUntil(timeout: 3) { done in

                    viewController.viewModel.fetchTramStopsByDirection(direction: .north, completion: { result in
                        switch result {
                        case .success:
                            let detailCell = viewController.tramTimesTable.cellForRow(at: IndexPath(row: 2, section: 0)) as! TramDetailsTableViewCell
                            expect(detailCell.destLabel.text) == "North Richmond"
                        case let .failure(error):
                            expect(error).notTo(beNil())
                        }
                        done()
                    })
                }
            }
            
            it("When data got loaded, South section's second row destination should be Balaclava") {
            
                waitUntil(timeout: 3) { done in

                    viewController.viewModel.fetchTramStopsByDirection(direction: .south, completion: { result in
                        switch result {
                        case .success:
                            let detailCell = viewController.tramTimesTable.cellForRow(at: IndexPath(row: 1, section: 1)) as! TramDetailsTableViewCell
                            expect(detailCell.destLabel.text) == "Balaclava"
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
