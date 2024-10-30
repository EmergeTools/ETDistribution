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

struct TokenResponse: Decodable {
  let tokenType: String
  let idToken: String
  let expiresIn: Int
  let accessToken: String
}

enum Auth {

  static func getAccessToken(connection: String?, completion: @escaping (Result<String, Error>) -> Void) {
    // TODO: Store token/refresh
    login(connection: connection, completion: completion)
  }

  static func login(
    connection: String? = nil,
    completion: @escaping (Result<String, Error>) -> Void)
  {
    let verifier = getVerifier()!
    let challenge = getChallenge(for: verifier)!

    let authorize = URL(string: "authorize", relativeTo: self.url)!
    var components = URLComponents(url: authorize, resolvingAgainstBaseURL: true)!
    var items: [URLQueryItem] = []
    var entries: [String: String] = [:]

    entries["scope"] = "openid profile email"
    entries["client_id"] = clientId
    entries["response_type"] = "code"
    if let connection {
      entries["connection"] = connection
    }
    entries["redirect_uri"] = redirectUri.absoluteString
    entries["state"] = generateDefaultState()
    entries.forEach { items.append(URLQueryItem(name: $0, value: $1)) }
    components.queryItems = items
    components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

    let url = components.url!
    let session = ASWebAuthenticationSession(
      url: url,
      callbackURLScheme: redirectUri.scheme!) { url, error in
        if let error {
          completion(.failure(error))
          return
        }

        if let url {
          let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
          let code = components!.queryItems!.first(where: { $0.name == "code"})
          if let code {
            self.exchangeAuthorizationCodeForTokens(authorizationCode: code.value!, verifier: verifier) { result in
              print(result)
              completion(result.map { $0.accessToken } )
            }
          } else {
            completion(.failure(LoginError.noCode))
          }
        } else {
          completion(.failure(LoginError.noUrl))
        }
      }
    session.presentationContextProvider = PresentationContextProvider.shared
    session.start()
  }

  private static let url = URL(string: "https://auth.emergetools.com")!
  private static let clientId = "XiFbzCzBHV5euyxbcxNHbqOHlKcTwzBX"
  private static let redirectUri = URL(string: "app.install.callback://callback")!

  private static func exchangeAuthorizationCodeForTokens(
    authorizationCode: String,
    verifier: String,
    completion: @escaping (Result<TokenResponse, Error>) -> Void)
  {
    let url = URL(string: "oauth/token", relativeTo: self.url)!

    let parameters = [
      "grant_type": "authorization_code",
      "code_verifier": verifier,
      "client_id": clientId,
      "code": authorizationCode,
      "redirect_uri": redirectUri.absoluteString,
    ]

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }

      guard let data = data else {
        completion(.failure(LoginError.invalidData))
        return
      }

      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
        completion(.success(tokenResponse))
      } catch {
        completion(.failure(error))
      }
    }

    task.resume()
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
