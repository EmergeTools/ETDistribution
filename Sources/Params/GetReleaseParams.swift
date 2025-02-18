//
//  GetReleaseParams.swift
//  ETDistribution
//
//  Created by Itay Brenner on 18/2/25.
//

import Foundation

/// A model for configuring parameters needed to get an update information.
///
@objc
public final class GetReleaseParams: CommonParams {

  /// Create a new GetReleaseParams object.
  ///
  /// - Parameters:
  ///   - apiKey: A `String` API key used for authentication.
  ///   - releaseId: A `String` identifying the relase.
  ///   - requiresLogin: A `Bool` indicating if user login is required before checking for updates. Defaults to `false`.
  @objc
  public init(apiKey: String,
              releaseId: String,
              requiresLogin: Bool = false) {
    self.releaseId = releaseId
    super.init(apiKey: apiKey,
               loginSetting: requiresLogin ? .default : nil,
               loginLevel: requiresLogin ? .everything : .noLogin)
  }

  /// Create a new GetReleaseParams object with a connection name.
  ///
  /// - Parameters:
  ///   - apiKey: A `String` API key used for authentication.
  ///   - releaseId: A `String` identifying the relase.
  ///   - connection: A `String` connection name for a company. Will automatically redirect login to the company’s SSO page.
  ///   - loginLevel: An optional `LoginLevel` to set whether a login is required for downloading updates, checking for updates or never
  @objc
  public init(apiKey: String,
              releaseId: String,
              connection: String,
              loginLevel: LoginLevel = .everything) {
    self.releaseId = releaseId
    super.init(apiKey: apiKey,
               loginSetting: .connection(connection),
               loginLevel: loginLevel)
  }
  
  /// Create a new GetReleaseParams object with a login setting.
  ///
  /// - Parameters:
  ///   - apiKey: A `String` API key used for authentication.
  ///   - releaseId: A `String` identifying the relase.
  ///   - loginSetting: A `LoginSetting` to require authenticated access to updates.
  ///   - loginLevel: An optional `LoginLevel` to set whether a login is required for downloading updates, checking for updates or never
  public init(apiKey: String,
              releaseId: String,
              loginSetting: LoginSetting,
              loginLevel: LoginLevel = .everything) {
    self.releaseId = releaseId
    super.init(apiKey: apiKey,
               loginSetting: loginSetting,
               loginLevel: loginLevel)
  }

  let releaseId: String
}
