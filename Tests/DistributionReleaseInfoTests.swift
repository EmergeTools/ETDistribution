//
//  File.swift
//  ETDistribution
//
//  Created by Itay Brenner on 31/1/25.
//

import Testing
import Foundation
@testable import ETDistribution

@Test func testParseDateWithFractionalSecondsWorks() async throws {
  let dateString = "2025-01-31T12:34:56.000Z"
  let expectedDate = Date(timeIntervalSince1970: 1738326896) // Friday, 31 January 2025 12:34:56 GMT
  let date = Date.fromString(dateString)
  
  #expect(date == expectedDate, "Invalid parser")
}

@Test func testParserUpToMiliseconds() async throws {
  let dateString = "2025-02-24T01:07:51.101Z"
  let date = Date.fromString(dateString)
  
  guard let date else {
    Issue.record("Failed to parse date")
    return
  }
  
  var calendar = Calendar.current
  calendar.timeZone = TimeZone(secondsFromGMT: 0)!
  let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
  
  #expect(dateComponents.year == 2025, "Different year")
  #expect(dateComponents.month == 2, "Different month")
  #expect(dateComponents.day == 24, "Different day")
  #expect(dateComponents.hour == 1, "Different hour")
  #expect(dateComponents.minute == 7, "Different minute")
  #expect(dateComponents.second == 51, "Different second")
  
  // Nanoseconds is the closest floating point number
  let miliseconds = dateComponents.nanosecond! / 1_000_000
  #expect(miliseconds == 101, "Different nanosecond")
}
