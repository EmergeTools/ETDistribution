//
//  CheckForUpdateParams.swift
//  ETDistribution
//
//  Created by Noah Martin on 10/31/24.
//

import Foundation

/// A model for configuring parameters needed to check for app updates.
///
/// Note: `tagName` is generally not needed, the SDK will identify the tag automatically.
@objc
public final class CheckForUpdateParams: NSObject {

  /// Create a new CheckForUpdateParams object.
  ///
  /// - Parameters:
  ///   - apiKey: A `String` API key used for authentication.
  ///   - tagName: An optional `String` that is the tag name used when this app was uploaded.
  ///   - requiresLogin: A `Bool` indicating if user login is required before checking for updates. Defaults to `false`.
  @objc
  public init(apiKey: String,
              tagName: String? = nil,
              requiresLogin: Bool = false) {
    self.apiKey = apiKey
    self.tagName = tagName
    self.loginSetting = requiresLogin ? .default : nil
  }

  /// Create a new CheckForUpdateParams object with a connection name.
  ///
  /// - Parameters:
  ///   - apiKey: A `String` API key used for authentication.
  ///   - tagName: An optional `String` that is the tag name used when this app was uploaded.
  ///   - connection: A `String` connection name for a company. Will automatically redirect login to the company’s SSO page.
  @objc
  public init(apiKey: String,
              tagName: String? = nil,
              connection: String) {
    self.apiKey = apiKey
    self.tagName = tagName
    self.loginSetting = .connection(connection)
  }

  /// Create a new CheckForUpdateParams object with a login setting.
  ///
  /// - Parameters:
  ///   - apiKey: A `String` API key used for authentication.
  ///   - tagName: An optional `String` that is the tag name used when this app was uploaded.
  ///   - loginSetting: A `LoginSetting` to require authenticated access to updates.
  public init(apiKey: String,
              tagName: String? = nil,
              loginSetting: LoginSetting) {
    self.apiKey = apiKey
    self.tagName = tagName
    self.loginSetting = loginSetting
  }

  /// Type of authenticated access to required. The default case shows the Emerge Tools login page.
  /// A custom connection can be used to automatically redirect to an SSO page.
  public enum LoginSetting {
    case `default`
    case connection(String)
  }

  let apiKey: String
  let tagName: String?
  let loginSetting: LoginSetting?
}
