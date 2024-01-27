//
//  Constants.swift
//  JatAppTmdb
//
//  Created by Burak Erturk on 21.01.2024.
//

import Foundation

enum Constants {
  static let imageBaseUrl = URL(string: "https://image.tmdb.org/t/p/w500")!
  static let contentBaseUrl = URL(string: "https://api.themoviedb.org/3/movie/")!
  // TODO: token has to be encrypted
  static let apiToken = "your api token"
}
