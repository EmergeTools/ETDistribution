//
//  URLSession+Distribute.swift
//
//
//  Created by Itay Brenner on 6/9/24.
//

import Foundation

enum RequestError: Error {
  case invalidData
  case unknownError
}

extension URLSession {
  func checkForUpdate(_ request: URLRequest, completion: @escaping @MainActor (Result<DistributionUpdateCheckResponse, Error>) -> Void) {
    self.perform(request, decode: DistributionUpdateCheckResponse.self, completion: completion) { [weak self] data, statusCode in
      return RequestError.unknownError
    }
  }
  
  private func perform<T: Sendable & Decodable>(_ request: URLRequest,
                                     decode decodable: T.Type,
                                     completion: @escaping @MainActor (Result<T, Error>) -> Void,
                                     decodeErrorData: (@Sendable (Data, Int) -> Error)?) {
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      var result: Result<T, Error> = .failure(RequestError.unknownError)
      defer {
        DispatchQueue.main.async { [result] in
          completion(result)
        }
      }
      if let error = error {
        result = .failure(error)
        return
      }
      guard let httpResponse = response as? HTTPURLResponse,
            let data = data else {
        result = .failure(RequestError.invalidData)
        return
      }
      guard (200...299).contains(httpResponse.statusCode) else {
        result = .failure(RequestError.unknownError)
        return
      }
      
      print(String(data: data, encoding: .utf8))
      do {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        result = .success(try jsonDecoder.decode(decodable, from: data))
      } catch {
        result = .failure(error)
      }
    }.resume()
  }

}
