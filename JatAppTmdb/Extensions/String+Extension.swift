//
//  String+Extension.swift
//  JatAppTmdb
//
//  Created by Burak Erturk on 21.01.2024.
//

import Foundation

extension String {
  /**
   Swift specific solution.
   Calculates the occurrence of each character using the higher order function reduce.
   Time and space complexites are O(n)
   */
  func characterCountsWithSwift() -> Dictionary<String, Int> {
    return self.lowercased()
      .replacingOccurrences(of: " ", with: "")
      .reduce(into: [:], { $0[String($1), default: 0] += 1 })
  }
  
  /**
   Algorithmic solution.
   Calculates the occurrence of each character in an algorithmic way.
   Time and space complexites are O(n)
   */
  func characterCountsAlgorithmic() -> Dictionary<String, Int> {
    var dict : [String : Int] = [:]
    let formattedString = self.lowercased().replacingOccurrences(of: " ", with: "")
    for i in formattedString {
      var occurance = 1
      if dict[String(i)] == nil  {
        dict[String(i)] = occurance
      }
      else {
        occurance = dict[String(i)] ?? 0
        occurance += 1
        dict[String(i)] = occurance
      }
    }
    return dict as Dictionary<String, Int>
  }
}
