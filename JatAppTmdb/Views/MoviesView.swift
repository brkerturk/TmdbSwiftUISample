//
//  MoviesView.swift
//  JatAppTmdb
//
//  Created by Burak Erturk on 20.01.2024.
//

import SwiftUI
import Combine

final class MoviesViewModel: ObservableObject {
  @Published var filteredMovies: [Movie] = []
  @Published var searchText: String = "" {
    didSet {
      searchMovies()
    }
  }
  
  private let environment: AppEnvironment
  private var movies: [Movie] = []
  private var moviesCancellable: AnyCancellable?
  
  // MARK: -
  init(environment: AppEnvironment) {
    self.environment = environment
  }
  
  fileprivate func viewDidAppear(isRefresh: Bool? = false) {
    getMovies(isRefresh)
  }
  
  fileprivate func viewDidDisAppear() {
    moviesCancellable?.cancel()
  }
  
  // MARK: - HTTP Requests
  
  private func getMovies(_ isRefresh: Bool?) {
    guard (movies.isEmpty || (isRefresh ?? false)) else { return }
    moviesCancellable = environment.httpClient.getMovies()
      .receive(on: environment.mainScheduler)
      .sink(
        success: { [weak self] pageData in
          guard let self else { return }
          movies = pageData.results
          filteredMovies = movies
          print(movies)
        }
      )
  }
  
  // MARK: - Helper Functions
  
  private func searchMovies() {
    guard !searchText.isEmpty else {
      filteredMovies = movies
      return
    }
    filteredMovies = movies.filter { $0.title.contains(searchText) }
  }
}

struct MoviesView: View {
  @StateObject var viewModel: MoviesViewModel
  @Namespace private var movieAnimation
  
  func listRow(movie: Movie) -> some View {
    HStack {
      CacheAsyncImage(
        url: movie.backDropFullUrl
      ) { phase in
        switch phase {
        case .empty:
          ProgressView()
        case .success(let image):
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(.rect(cornerRadius: 4))
        default:
          EmptyView()
        }
      }
      .frame(maxWidth: 80, maxHeight: 80)
      HStack {
        Text(movie.title)
          .font(.subheadline)
        Spacer()
        Text("\(String(format: "%.2f", movie.voteAverage))/10")
          .font(.footnote)
      }
    }
  }
  
  var body: some View {
    NavigationView {
      List(viewModel.filteredMovies, id: \.id) { movie in
        NavigationLink {
          MovieDetailView(viewModel: MovieDetailViewModel(movie: movie), movieAnimation: movieAnimation)
        } label: {
          listRow(movie: movie)
          .frame(height: 50)
        }
      }
      .refreshable {
        viewModel.viewDidAppear(isRefresh: true)
      }
      .searchable(text: $viewModel.searchText, prompt: "Search for a movie")
      .navigationTitle("Top Rated Movies")
      .onAppear { viewModel.viewDidAppear() }
      .onDisappear(perform: viewModel.viewDidDisAppear)
    }
  }
}

#Preview {
  ContentView ()
}
