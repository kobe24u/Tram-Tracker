//
//  APIResponseSpec.swift
//  HomeTimeTests
//
//  Created by Vinnie Liu on 27/2/21.
//  Copyright © 2021 REA. All rights reserved.
//

import Quick
import Nimble
@testable import HomeTime

class APIResponseSpec: QuickSpec {
    
    override func spec() {
        
        let tokenResponse = """
            {
              "errorMessage": null,
              "hasError": false,
              "hasResponse": true,
              "responseObject": [
                {
                  "__type": "AddDeviceTokenInfo",
                  "DeviceToken": "ecc7fab2-15d4-411e-bbba-d21dd888f55f"
                }
              ],
              "timeRequested": "/Date(1614426646908+1100)/",
              "timeResponded": "/Date(1614426646920+1100)/",
              "webMethodCalled": "GetDeviceToken"
            }
        """
        
        let errorResponse = """
            {
              "errorMessage": "HTTP Error 401 - Unauthorized",
              "hasError": true,
              "hasResponse": false,
              "responseObject": []
            }
            """
        
        
        describe("API responses") {
            
            it("Fetch token without error") {
                do {
                    let response =  try JSONDecoder().decode(APIResponse<Token>.self, from: tokenResponse.data(using: .utf8)!)
                    expect(response.responseObject.first).notTo(beNil())
                    expect(response.responseObject.first?.token) == "ecc7fab2-15d4-411e-bbba-d21dd888f55f"
                } catch {
                    expect(error).notTo(beNil())
                }
            }
        
            it("Fetch token with error") {
                do {
                    let response = try JSONDecoder().decode(APIResponse<Token>.self, from: errorResponse.data(using: .utf8)!)
                    expect(response.errorMessage) == "HTTP Error 401 - Unauthorized"
                } catch {
                    expect(error).notTo(beNil())
                }
            }
        }
    }
}
