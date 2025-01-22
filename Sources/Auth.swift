//
//  Auth.swift
//  ETDistribution
//
//  Created by Noah Martin on 9/23/24.
//

import AuthenticationServices
import CommonCrypto

enum LoginError: Error {
  case noUrl
  case noCode
  case invalidData
}

enum Auth {
  private enum Constants {
    static let url = URL(string: "https://auth.emergetools.com")!
    static let clientId = "XiFbzCzBHV5euyxbcxNHbqOHlKcTwzBX"
    static let redirectUri = URL(string: "app.install.callback://callback")!
    static let accessTokenKey = "accessToken"
    static let refreshTokenKey = "refreshToken"
  }
  
  static func getAccessToken(settings: LoginSetting) async throws -> String {
    if let token = await KeychainHelper.getToken(key: Constants.accessTokenKey),
       JWTHelper.isValid(token: token) {
      return token
    } else {
      if let refreshToken = await KeychainHelper.getToken(key: Constants.accessTokenKey),
         JWTHelper.isValid(token: refreshToken) {
        
        do {
          return try await refreshAccessToken(refreshToken)
        } catch {
          return try await requestLogin(settings)
        }
      } else {
        return try await requestLogin(settings)
      }
    }
  }
  
  private static func requestLogin(_ settings: LoginSetting) async throws -> String {
    let result = try await login(settings: settings)
    
    try await KeychainHelper.setToken(result.accessToken, key: Constants.accessTokenKey)
    try await KeychainHelper.setToken(result.refreshToken, key: Constants.refreshTokenKey)
    
    return result.accessToken
  }
  
  private static func refreshAccessToken(_ refreshToken: String) async throws -> String {
    let url = URL(string: "oauth/token", relativeTo: Constants.url)!

    let parameters = [
      "grant_type": "refresh_token",
      "client_id": Constants.clientId,
      "refresh_token": refreshToken,
    ]

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
    
    let response = try await URLSession(configuration: URLSessionConfiguration.ephemeral).refreshAccessToken(request)
    
    try await KeychainHelper.setToken(response.accessToken, key: Constants.accessTokenKey)
    
    return response.accessToken
  }

  private static func login(settings: LoginSetting) async throws -> AuthCodeResponse
  {
    return try await withCheckedThrowingContinuation { continuation in
      let verifier = getVerifier()!
      let challenge = getChallenge(for: verifier)!

      let authorize = URL(string: "authorize", relativeTo: Constants.url)!
      var components = URLComponents(url: authorize, resolvingAgainstBaseURL: true)!
      var items: [URLQueryItem] = []
      var entries: [String: String] = [:]

      entries["scope"] = "openid profile email offline_access"
      entries["client_id"] = Constants.clientId
      entries["response_type"] = "code"
      if case .connection(let string) = settings {
        entries["connection"] = string
      }
      entries["redirect_uri"] = Constants.redirectUri.absoluteString
      entries["state"] = generateDefaultState()
      entries["audience"] = "https://auth0-jwt-authorizer"
      entries.forEach { items.append(URLQueryItem(name: $0, value: $1)) }
      components.queryItems = items
      components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

      let url = components.url!
      let session = ASWebAuthenticationSession(
        url: url,
        callbackURLScheme: Constants.redirectUri.scheme!) { url, error in
          if let error {
            continuation.resume(throwing: error)
            return
          }

          if let url {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let code = components!.queryItems!.first(where: { $0.name == "code"})
            if let code {
              Task {
                do {
                  let response = try await self.exchangeAuthorizationCodeForTokens(authorizationCode: code.value!, verifier: verifier)
                  continuation.resume(returning: response)
                } catch {
                  continuation.resume(throwing: error)
                }
              }
            } else {
              continuation.resume(throwing: LoginError.noCode)
            }
          } else {
            continuation.resume(throwing: LoginError.noUrl)
          }
        }
      
      DispatchQueue.main.async {
        session.presentationContextProvider = PresentationContextProvider.shared
        session.start()
      }
      
    }
  }

  private static func exchangeAuthorizationCodeForTokens(
    authorizationCode: String,
    verifier: String) async throws -> AuthCodeResponse
  {
    let url = URL(string: "oauth/token", relativeTo: Constants.url)!

    let parameters = [
      "grant_type": "authorization_code",
      "code_verifier": verifier,
      "client_id": Constants.clientId,
      "code": authorizationCode,
      "redirect_uri": Constants.redirectUri.absoluteString,
    ]

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
    
    return try await URLSession(configuration: URLSessionConfiguration.ephemeral).getAuthDataWith(request)
  }

  private static func getVerifier() -> String? {
    let data = Data(count: 32)
    var tempData = data
    _ = tempData.withUnsafeMutableBytes {
        SecRandomCopyBytes(kSecRandomDefault, data.count, $0.baseAddress!)
    }
    return tempData.a0_encodeBase64URLSafe()
  }

  private static func getChallenge(for verifier: String) -> String? {
    guard let data = verifier.data(using: .utf8) else { return nil }

    var buffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    _ = data.withUnsafeBytes {
        CC_SHA256($0.baseAddress, CC_LONG(data.count), &buffer)
    }
    return Data(buffer).a0_encodeBase64URLSafe()
  }

  private static func generateDefaultState() -> String {
    let data = Data(count: 32)
    var tempData = data

    let result = tempData.withUnsafeMutableBytes {
        SecRandomCopyBytes(kSecRandomDefault, data.count, $0.baseAddress!)
    }

    guard result == 0, let state = tempData.a0_encodeBase64URLSafe()
    else { return UUID().uuidString.replacingOccurrences(of: "-", with: "") }

    return state
  }
}

private class PresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
  fileprivate static let shared = PresentationContextProvider()

  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    if
      let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
      let window = windowScene.windows.first(where: \.isKeyWindow) {
        return window
    }
    return ASPresentationAnchor()
  }
}

extension Data {
  fileprivate func a0_encodeBase64URLSafe() -> String? {
    return self
      .base64EncodedString(options: [])
      .replacingOccurrences(of: "+", with: "-")
      .replacingOccurrences(of: "/", with: "_")
      .replacingOccurrences(of: "=", with: "")
  }
}
