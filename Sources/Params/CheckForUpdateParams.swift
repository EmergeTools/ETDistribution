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
public final class CheckForUpdateParams: CommonParams {

  /// Create a new CheckForUpdateParams object.
  ///
  /// - Parameters:
  ///   - apiKey: A `String` API key used for authentication.
  ///   - tagName: An optional `String` that is the tag name used when this app was uploaded.
  ///   - requiresLogin: A `Bool` indicating if user login is required before checking for updates. Defaults to `false`.
  ///   - binaryIdentifierOverride: Override the binary identifier for local debugging
  ///   - appIdOverride: Override the app identifier (Bundle Id) for local debugging
  @objc
  public init(apiKey: String,
              tagName: String? = nil,
              requiresLogin: Bool = false,
              binaryIdentifierOverride: String? = nil,
              appIdOverride: String? = nil) {
    self.tagName = tagName
    self.binaryIdentifierOverride = binaryIdentifierOverride
    self.appIdOverride = appIdOverride
    super.init(apiKey: apiKey,
               loginSetting: requiresLogin ? .default : nil,
               loginLevel: requiresLogin ? .everything : .noLogin)
  }

  /// Create a new CheckForUpdateParams object with a connection name.
  ///
  /// - Parameters:
  ///   - apiKey: A `String` API key used for authentication.
  ///   - tagName: An optional `String` that is the tag name used when this app was uploaded.
  ///   - connection: A `String` connection name for a company. Will automatically redirect login to the company’s SSO page.
  ///   - loginLevel: An optional `LoginLevel` to set whether a login is required for downloading updates, checking for updates or never
  ///   - binaryIdentifierOverride: Override the binary identifier for local debugging
  ///   - appIdOverride: Override the app identifier (Bundle Id) for local debugging
  @objc
  public init(apiKey: String,
              tagName: String? = nil,
              connection: String,
              loginLevel: LoginLevel = .everything,
              binaryIdentifierOverride: String? = nil,
              appIdOverride: String? = nil) {
    self.tagName = tagName
    self.binaryIdentifierOverride = binaryIdentifierOverride
    self.appIdOverride = appIdOverride
    super.init(apiKey: apiKey,
               loginSetting: .connection(connection),
               loginLevel: loginLevel)
  }

  /// Create a new CheckForUpdateParams object with a login setting.
  ///
  /// - Parameters:
  ///   - apiKey: A `String` API key used for authentication.
  ///   - tagName: An optional `String` that is the tag name used when this app was uploaded.
  ///   - loginSetting: A `LoginSetting` to require authenticated access to updates.
  ///   - loginLevel: An optional `LoginLevel` to set whether a login is required for downloading updates, checking for updates or never
  ///   - binaryIdentifierOverride: Override the binary identifier for local debugging
  ///   - appIdOverride: Override the app identifier (Bundle Id) for local debugging
  public init(apiKey: String,
              tagName: String? = nil,
              loginSetting: LoginSetting,
              loginLevel: LoginLevel = .everything,
              binaryIdentifierOverride: String? = nil,
              appIdOverride: String? = nil) {
    self.tagName = tagName
    self.binaryIdentifierOverride = binaryIdentifierOverride
    self.appIdOverride = appIdOverride
    super.init(apiKey: apiKey,
               loginSetting: loginSetting,
               loginLevel: loginLevel)
  }

  let tagName: String?
  let binaryIdentifierOverride: String?
  let appIdOverride: String?
}
