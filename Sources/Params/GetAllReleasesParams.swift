//
//  GetAllReleasesParams.swift
//  ETDistribution
//
//  Created by Itay Brenner on 18/2/25.
//

import Foundation

/// A model for configuring parameters needed to get an update information.
///
@objc
public final class GetAllReleasesParams: CommonParams {

  /// Create a new GetAllReleasesParams object.
  ///
  /// - Parameters:
  ///   - apiKey: A `String` API key used for authentication.
  ///   - requiresLogin: A `Bool` indicating if user login is required before checking for updates. Defaults to `false`.
  ///   - page: Page Number, pages start from 1
  ///   - binaryIdentifierOverride: Override the binary identifier for local debugging
  ///   - appIdOverride: Override the app identifier (Bundle Id) for local debugging
  @objc
  public init(apiKey: String,
              requiresLogin: Bool = false,
              page: NSNumber? = 1,
              binaryIdentifierOverride: String? = nil,
              appIdOverride: String? = nil) {
    self.page = page ?? 1
    self.binaryIdentifierOverride = binaryIdentifierOverride
    self.appIdOverride = appIdOverride
    super.init(apiKey: apiKey,
               loginSetting: requiresLogin ? .default : nil,
               loginLevel: requiresLogin ? .everything : .noLogin)
  }

  /// Create a new GetAllReleasesParams object with a connection name.
  ///
  /// - Parameters:
  ///   - apiKey: A `String` API key used for authentication.
  ///   - connection: A `String` connection name for a company. Will automatically redirect login to the company’s SSO page.
  ///   - loginLevel: An optional `LoginLevel` to set whether a login is required for downloading updates, checking for updates or never
  ///   - page: Page Number, pages start from 1
  ///   - binaryIdentifierOverride: Override the binary identifier for local debugging
  ///   - appIdOverride: Override the app identifier (Bundle Id) for local debugging
  @objc
  public init(apiKey: String,
              connection: String,
              loginLevel: LoginLevel = .everything,
              page: NSNumber? = 1,
              binaryIdentifierOverride: String? = nil,
              appIdOverride: String? = nil) {
    self.page = page ?? 1
    self.binaryIdentifierOverride = binaryIdentifierOverride
    self.appIdOverride = appIdOverride
    super.init(apiKey: apiKey,
               loginSetting: .connection(connection),
               loginLevel: loginLevel)
  }
  
  /// Create a new GetAllReleasesParams object with a login setting.
  ///
  /// - Parameters:
  ///   - apiKey: A `String` API key used for authentication.
  ///   - loginSetting: A `LoginSetting` to require authenticated access to updates.
  ///   - loginLevel: An optional `LoginLevel` to set whether a login is required for downloading updates, checking for updates or never
  ///   - page: Page Number, pages start from 1
  ///   - binaryIdentifierOverride: Override the binary identifier for local debugging
  ///   - appIdOverride: Override the app identifier (Bundle Id) for local debugging
  public init(apiKey: String,
              loginSetting: LoginSetting,
              loginLevel: LoginLevel = .everything,
              page: NSNumber? = 1,
              binaryIdentifierOverride: String? = nil,
              appIdOverride: String? = nil) {
    self.page = page ?? 1
    self.binaryIdentifierOverride = binaryIdentifierOverride
    self.appIdOverride = appIdOverride
    super.init(apiKey: apiKey,
               loginSetting: loginSetting,
               loginLevel: loginLevel)
  }

  let page: NSNumber
  let binaryIdentifierOverride: String?
  let appIdOverride: String?
}
