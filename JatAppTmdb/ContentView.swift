//
//  ContentView.swift
//  JatAppTmdb
//
//  Created by Burak Erturk on 20.01.2024.
//

import SwiftUI

struct ContentView: View {
  let environment = AppEnvironment(
    httpClient: HttpClient(baseURL: Constants.contentBaseUrl)
  )
  
  var body: some View {
    MoviesView(viewModel: MoviesViewModel(environment: environment))
  }
}

#Preview {
  ContentView()
}
