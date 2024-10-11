//
//  URLSession+Distribute.swift
//
//
//  Created by Itay Brenner on 6/9/24.
//

import Foundation

enum RequestError: Error {
  case badRequest(String)
  case unknownError
}

extension URLSession {
  func checkForUpdate(_ request: URLRequest, completion: @escaping (Result<DistributionUpdateCheckResponse, Error>) -> Void) {
    self.perform(request, decode: DistributionUpdateCheckResponse.self, completion: completion)
  }
  
  private func perform<T: Decodable>(_ request: URLRequest, decode decodable: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
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
        return
      }
      guard (200...299).contains(httpResponse.statusCode) else {
        let errorMessage = (
          try? JSONDecoder().decode(
            DistributionUpdateCheckErrorResponse.self,
            from: data
          ).message
        ) ?? "Unknown error"
        result = .failure(RequestError.badRequest(errorMessage))
        return
      }
      
      do {
        result = .success(try JSONDecoder().decode(decodable, from: data))
      } catch {
        result = .failure(error)
      }
    }.resume()
  }
}
