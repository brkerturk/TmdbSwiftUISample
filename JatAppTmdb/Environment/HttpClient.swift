//
//  HttpClient.swift
//  JatAppTmdb
//
//  Created by Burak Erturk on 20.01.2024.
//

import Foundation
import Combine

// HttpClientProtocol enables us to use a mock httpClient which is crucial for the tests and swiftui previews.
// Using Combine, we can create a mock publisher to achieve this.
protocol HttpClientProtocol {
  func getMovies() -> AnyPublisher<MoviePageModel, Error>
}

final class HttpClient: HttpClientProtocol {
  let baseUrl: URL
  
  enum Method: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
    case put = "PUT"
  }
  
  private let encoder = JSONEncoder()
  
  private let decoder = JSONDecoder()
  
  init(baseURL: URL) {
    self.baseUrl = baseURL
  }
  
  func getMovies() -> AnyPublisher<MoviePageModel, Error> {
    publisher(path: "top_rated", queryItems: [
      URLQueryItem(name: "language", value: "en-US"),
      URLQueryItem(name: "page", value: "1")]
    )
  }
}

// MARK: - Publishers

extension HttpClient {
  fileprivate func publisher<ApiResult: Decodable>(
    path: String,
    queryItems: [URLQueryItem]? = nil,
    method: Method = .get
  ) -> AnyPublisher<ApiResult, Error> {
    publisher(path: path, queryItems: queryItems, method: method, body: Optional<String>.none)
  }
  
  
  fileprivate func publisher<ApiResult: Decodable, Body: Encodable>(
    path: String,
    queryItems: [URLQueryItem]? = nil,
    method: Method = .get,
    body: Body? = nil
  ) -> AnyPublisher<ApiResult, Error> {
    var urlComponents: URLComponents?
    urlComponents = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: false)
    urlComponents?.queryItems = queryItems
    
    var request = URLRequest(url: urlComponents!.url!)
    request.httpMethod = method.rawValue
    request.addValue("application/json", forHTTPHeaderField: "accept")
    request.addValue(
      "Bearer \(Constants.apiToken)",
      forHTTPHeaderField: "Authorization"
    )
    
    if let body {
      request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
      request.httpBody = try? encoder.encode(body)
    }
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { [decoder] in
        print(request.debug())
        print($0.response.debugDescription)
        print(String(decoding: $0.data, as: UTF8.self))
        if let successResponse = try? decoder.decode(ApiResult.self, from: $0.data) {
          return successResponse
        }
        let errorResponse = try decoder.decode(ApiError.self, from: $0.data)
        print(errorResponse)
        throw errorResponse
      }
      .print()
      .eraseToAnyPublisher()
  }
}

// MARK: - Debugger

fileprivate extension URLRequest {
  func debug() {
    guard let httpMethod = self.httpMethod,
          let url = self.url,
          let headers = self.allHTTPHeaderFields
    else { return }
    print("\(httpMethod) \(url)")
    print("Headers:")
    print(headers as AnyObject)
    if let body = self.httpBody {
      print("Body:")
      print(String(data: body, encoding: .utf8)!)
    }
  }
}

// MARK: - Error Handling

struct ApiError: Error, Decodable, Hashable {
  enum ErrorCode: String, Decodable {
    case ERROR_CODE_TO_HANDLE
  }
  let code: ErrorCode
  let data: Data?
  
  var message: String {
    return NSLocalizedString("ERROR_" + code.rawValue, comment: "")
  }
}

extension Publisher {
  func sink(
    success: ((Output) -> Void)? = nil,
    failure: ((Failure) -> Void)? = nil
  ) -> AnyCancellable {
    sink { completion in
      switch completion {
      case let .failure(error):
        failure?(error)
      case .finished:
        return
      }
    } receiveValue: { result in
      success?(result)
    }
  }
}
