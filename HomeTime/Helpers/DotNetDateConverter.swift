//
//  Copyright (c) 2015 REA. All rights reserved.
//

import Foundation

class DotNetDateConverter {
    func dateFromDotNetFormattedDateString(_ string: String) -> Date! {
        guard let startRange = string.range(of: "("),
              let endRange = string.range(of: "+") else { return nil }

        let lowBound = string.index(startRange.lowerBound, offsetBy: 1)
        let range = lowBound..<endRange.lowerBound

        let dateAsString = string[range]
        guard let time = Double(dateAsString) else { return nil }
        let unixTimeInterval = time / 1000
        return Date(timeIntervalSince1970: unixTimeInterval)
    }

    // Calculated Time difference in minutes to give user a more straightforward ETA
    func formattedDateFromString(_ string: String) -> String {
      guard let date = dateFromDotNetFormattedDateString(string) else {
          return "Date Formatting failed"
      }
      let formatter = DateFormatter()
      formatter.dateFormat = "h:mm a"
      let timeString = formatter.string(from: date)
      
      let currentDate = Date()
        
      let gap = date.timeIntervalSince(currentDate)
      let minutes = (Int(gap) / 60 ) % 60
      return "\(timeString) (\(minutes) min)"
    }
}
