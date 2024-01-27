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
  var movieAnimation: Namespace.ID
  
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
          
          VStack(alignment: .leading, spacing: 15) {
            Text("Original title: \(viewModel.movie.originalTitle)")
              .font(.subheadline)
            Text("Release Date: \(viewModel.movie.releaseDate)")
              .font(.footnote)
            Text("Overview: \(viewModel.movie.overview)")
              .font(.footnote)
            Text("Character occurances: \(viewModel.occurances)")
              .font(.footnote)
          }
          .padding()
          .background(Color(UIColor.secondarySystemGroupedBackground))
          .clipShape(.rect(cornerRadius: 6))
          .padding(.horizontal)
          Spacer()
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