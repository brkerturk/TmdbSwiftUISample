//
//  MovieDetailView.swift
//  JatAppTmdb
//
//  Created by Burak Erturk on 21.01.2024.
//

import SwiftUI

final class MovieDetailViewModel: ObservableObject {
  @Published var occurances: String = ""
  let movie: Movie
  
  // MARK: -
  
  init(movie: Movie) {
    self.movie = movie
  }
  
  fileprivate func viewDidAppear(isAlgorithmic: Bool = true) {
    characterOccurances(isAlgorithmic)
  }
  
  /**
   This function was a part of an algorithm question. Commented out in the view for now.
   */
  private func characterOccurances(_ isAlgorithmic: Bool) {
    if isAlgorithmic {
      occurances = movie.title.characterCountsAlgorithmic().description
    } else {
      occurances = movie.title.characterCountsWithSwift().description
    }
  }
}

struct MovieDetailView: View {
  @StateObject var viewModel: MovieDetailViewModel
  
  var body: some View {
    ScrollView {
      GeometryReader { geo in
        VStack(spacing: 20) {
          CacheAsyncImage(
            url: viewModel.movie.posterFullUrl
          ) { phase in
            switch phase {
            case .empty:
              ProgressView()
            case .success(let image):
              image
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: 500)
                .clipped()
                .shadow(radius: 5, x: 0, y: 5)
            default:
              EmptyView()
            }
          }
          .frame(width: geo.size.width, height: 500)
          
          GroupBox(
            label: Text("Original title: \(viewModel.movie.originalTitle)"),
            content: {
              VStack(alignment: .leading, spacing: 15) {
                Text("Release Date: \(viewModel.movie.releaseDate)")
                  .font(.footnote)
                Text("Overview: \(viewModel.movie.overview)")
                  .fixedSize(horizontal: false, vertical: true)
                  .font(.footnote)
                /*Text("Character occurances: \(viewModel.occurances)")
                 .font(.footnote)*/
              }
            }
          )
          .padding(.horizontal, 10)
        }
        .navigationTitle(viewModel.movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.viewDidAppear() }
      }
    }
  }
}

#Preview {
  ContentView ()
}
