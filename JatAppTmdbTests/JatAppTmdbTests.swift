//
//  JatAppTmdbTests.swift
//  JatAppTmdbTests
//
//  Created by Burak Erturk on 20.01.2024.
//

import XCTest
@testable import JatAppTmdb

final class JatAppTmdbTests: XCTestCase {
  let movieTitle = "The Shawshank Redemption"
  
  func testCharOccurancesAlgorithmic() {
    let occurances = movieTitle.characterCountsAlgorithmic()
    let result = (occurances == ["d": 1, "k": 1, "m": 1, "h": 3, "w": 1, "n": 2, "o": 1, "a": 2, "e": 3, "p": 1, "t": 2, "r": 1, "s": 2, "i": 1])
    XCTAssertTrue(result)
  }
  
  func testCharOccurancesSwift() {
    let occurances = movieTitle.characterCountsWithSwift()
    let result = (occurances == ["d": 1, "k": 1, "m": 1, "h": 3, "w": 1, "n": 2, "o": 1, "a": 2, "e": 3, "p": 1, "t": 2, "r": 1, "s": 2, "i": 1])
    XCTAssertTrue(result)
  }
}
