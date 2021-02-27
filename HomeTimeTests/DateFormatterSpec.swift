//
//  Copyright (c) 2015 REA. All rights reserved.
//

import Quick
import Nimble
@testable import HomeTime

class DateFormatterSpec: QuickSpec {
    override func spec() {
        describe("Date Formatter") {
            
            var converter: DotNetDateConverter!
            
            beforeEach {
                converter = DotNetDateConverter()
            }
            
            it("Convert .Net style date to readable date string") {
                let readableString = converter.convertToReadableString("/Date(1426821588000+1100)/")
                expect(readableString) == "14:19"
            }
        }
    }
}
