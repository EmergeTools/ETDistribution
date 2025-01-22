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
  func checkForUpdate(_ request: URLRequest) async throws -> DistributionUpdateCheckResponse {
    return try await self.perform(request, decode: DistributionUpdateCheckResponse.self, useCamelCase: true, decodeErrorData:  { [weak self] data, statusCode in
      return self?.getErrorFrom(data: data, statusCode: statusCode) ?? RequestError.badRequest("")
    })
  }
  
  func getAuthDataWith(_ request: URLRequest) async throws -> AuthCodeResponse {
    return try await self.perform(request,
                              decode: AuthCodeResponse.self,
                              useCamelCase: false,
                              decodeErrorData:  { data, statusCode in
      return RequestError.badRequest("")
    })
  }
  
  func refreshAccessToken(_ request: URLRequest) async throws -> AuthRefreshResponse {
    return try await self.perform(request,
                              decode: AuthRefreshResponse.self,
                              useCamelCase: false,
                              decodeErrorData:  { _, _ in
      return RequestError.badRequest("")
    })
  }
  
  func getReleaseInfo(_ request: URLRequest) async throws -> DistributionReleaseInfo {
    return try await self.perform(request,
                              decode: DistributionReleaseInfo.self,
                              useCamelCase: true,
                              decodeErrorData:  { [weak self] data, statusCode in
      return self?.getErrorFrom(data: data, statusCode: statusCode) ?? RequestError.badRequest("")
    })
  }
  
  private func perform<T: Decodable>(_ request: URLRequest,
                                     decode decodable: T.Type,
                                     useCamelCase: Bool = true,
                                     decodeErrorData: (@Sendable (Data, Int) -> Error)?) async throws -> T {
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw RequestError.invalidData
    }
    
    guard (200...299).contains(httpResponse.statusCode) else {
      let error = decodeErrorData?(data, httpResponse.statusCode) ?? RequestError.badRequest("Unknown error")
      throw error
    }
      
    let jsonDecoder = JSONDecoder()
    jsonDecoder.keyDecodingStrategy = useCamelCase ? .useDefaultKeys : .convertFromSnakeCase
    return try jsonDecoder.decode(decodable, from: data)
    
    throw RequestError.unknownError
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
