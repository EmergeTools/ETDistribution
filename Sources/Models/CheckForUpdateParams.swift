//
//  CheckForUpdateParams.swift
//  ETDistribution
//
//  Created by Itay Brenner on 31/10/24.
//

import Foundation

/// A model for configuring parameters needed to check for app updates, including authentication and optional connection details.
///
/// `CheckForUpdateParams` provides a structured way to configure the update check, holding essential information such as
/// the API key for authentication, optional tagging details, and options for Auth0-based login requirements. This model
/// enables flexibility in update checks with various configuration possibilities.
///
/// - Parameters:
///   - apiKey: A `String` representing the API key used to authenticate the update check.
///   - tagName: An optional `String` that represents a specific tag associated with the app release. If not provided, the SDK will attempt automatic tag detection.
///   - requiresLogin: A `Bool` indicating if user login is required through Auth0 before checking for updates. Defaults to `false`.
///   - connection: An optional `String` specifying the Auth0 connection to use if `requiresLogin` is set to `true`.
///
/// - Usage:
/// ```
/// let params = CheckForUpdateParams(apiKey: "your_api_key", requiresLogin: true, connection: "auth0_connection_name")
/// checkForUpdate(params: params) { result in
///     switch result {
///     case .success(let releaseInfo):
///         if let releaseInfo {
///             print("Update found: \(releaseInfo)")
///         } else {
///             print("No updates available")
///         }
///     case .failure(let error):
///         print("Update check error: \(error)")
///     }
/// }
/// ```
///
/// - Note: Use `requiresLogin` and `connection` to integrate Auth0-based user authentication for update checks requiring additional security.
@objc
public final class CheckForUpdateParams: NSObject {
  @objc
  public init(apiKey: String,
              tagName: String? = nil,
              requiresLogin: Bool = false,
              connection: String? = nil) {
    self.apiKey = apiKey
    self.tagName = tagName
    self.requiresLogin = requiresLogin
    self.connection = connection
  }

  public let apiKey: String
  public let tagName: String?
  public let requiresLogin: Bool
  public let connection: String?
}
