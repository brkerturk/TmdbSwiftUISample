//
//  ApiModels.swift
//  JatAppTmdb
//
//  Created by Burak Erturk on 20.01.2024.
//

import Foundation

struct MoviePageModel: Decodable {
  let page: Int
  let results: [Movie]
}

struct Movie: Decodable, Hashable {
  let adult: Bool
  let backdropPath: String
  let genreIds: [Int]
  let id: Int
  let originalLanguage: String
  let originalTitle: String
  let overview: String
  let popularity: Double
  let posterPath: String
  let releaseDate: String
  let title: String
  let video: Bool
  let voteAverage: Double
  let voteCount: Int
  
  private enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case genreIds = "genre_ids"
    case id
    case originalLanguage = "original_language"
    case originalTitle = "original_title"
    case overview
    case popularity
    case posterPath = "poster_path"
    case releaseDate = "release_date"
    case title
    case video
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }
  
  var backDropFullUrl: URL {
    Constants.imageBaseUrl.appendingPathComponent(backdropPath)
  }
  var posterFullUrl: URL {
    Constants.imageBaseUrl.appendingPathComponent(posterPath)
  }
}
