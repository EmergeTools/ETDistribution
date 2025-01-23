//
//  URLSession+Distribute.swift
//
//
//  Created by Itay Brenner on 6/9/24.
//

import Foundation

enum RequestError: Error {
  case badRequest(String)
  case invalidData
  case loginRequired
  case unknownError
}

extension URLSession {
  func checkForUpdate(_ request: URLRequest, completion: @escaping @Sendable (Result<DistributionUpdateCheckResponse, Error>) -> Void) {
    self.perform(request, decode: DistributionUpdateCheckResponse.self, useCamelCase: true, completion: completion) { [weak self] data, statusCode in
      return self?.getErrorFrom(data: data, statusCode: statusCode) ?? RequestError.badRequest("")
    }
  }
  
  func getAuthDataWith(_ request: URLRequest, completion: @escaping @Sendable (Result<AuthCodeResponse, Error>) -> Void) {
    self.perform(request, decode: AuthCodeResponse.self, useCamelCase: false, completion: completion) { _, _ in
      return RequestError.badRequest("")
    }
  }
  
  func refreshAccessToken(_ request: URLRequest, completion: @escaping @Sendable (Result<AuthRefreshResponse, Error>) -> Void) {
    self.perform(request, decode: AuthRefreshResponse.self, useCamelCase: false, completion: completion) { _, _ in
      return RequestError.badRequest("")
    }
  }
  
  func getReleaseInfo(_ request: URLRequest, completion: @escaping @Sendable (Result<DistributionReleaseInfo, Error>) -> Void) {
    self.perform(request, decode: DistributionReleaseInfo.self, useCamelCase: true, completion: completion) { [weak self] data, statusCode in
      return self?.getErrorFrom(data: data, statusCode: statusCode) ?? RequestError.badRequest("")
    }
  }
  
  private func perform<T: Decodable>(_ request: URLRequest,
                                     decode decodable: T.Type,
                                     useCamelCase: Bool = true,
                                     completion: @escaping @Sendable (Result<T, Error>) -> Void,
                                     decodeErrorData: ((Data, Int) -> Error)?) {
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      var result: Result<T, Error> = .failure(RequestError.unknownError)
      defer {
        completion(result)
      }
      if let error = error {
        result = .failure(error)
        return
      }
      guard let httpResponse = response as? HTTPURLResponse,
            let data = data else {
        completion(.failure(RequestError.invalidData))
        return
      }
      guard (200...299).contains(httpResponse.statusCode) else {
        let error = decodeErrorData?(data, httpResponse.statusCode) ?? RequestError.badRequest("Unknown error")
        result = .failure(error)
        return
      }
      
      do {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = useCamelCase ? .useDefaultKeys : .convertFromSnakeCase
        result = .success(try jsonDecoder.decode(decodable, from: data))
      } catch {
        result = .failure(error)
      }
    }.resume()
  }
  
  private func getErrorFrom(data: Data, statusCode: Int) -> RequestError {
    let errorMessage = (
      try? JSONDecoder().decode(
        DistributionUpdateCheckErrorResponse.self,
        from: data
      ).message
    ) ?? "Unknown error"
    if statusCode == 403 {
      return RequestError.loginRequired
    }
    return RequestError.badRequest(errorMessage)
  }
}
