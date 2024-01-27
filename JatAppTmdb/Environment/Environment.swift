//
//  Environment.swift
//  JatAppTmdb
//
//  Created by Burak Erturk on 20.01.2024.
//

import Foundation
import CombineSchedulers

struct AppEnvironment {
  var httpClient: HttpClientProtocol
  var mainScheduler: AnyScheduler = DispatchQueue.main.eraseToAnyScheduler()
}
