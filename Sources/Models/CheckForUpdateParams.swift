//
//  CheckForUpdateParams.swift
//  ETDistribution
//
//  Created by Noah Martin on 10/31/24.
//

import Foundation

/// Type of authenticated access to required. The default case shows the Emerge Tools login page.
/// A custom connection can be used to automatically redirect to an SSO page.
public enum LoginSetting {
  case `default`
  case connection(String)
}

/// Level of login required. By default no login is required
/// Available levels:
///   - none: No login is requiried
///   - onlyForDownload: login is required only when downloading the app
///   - everything: login is always required when doing API calls.
@objc
public enum LoginLevel: Int {
  case none
  case onlyForDownload
  case everything
}

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
  ///   - binaryIdentifierOverride: Override the binary identifier for local debugging
  ///   - appIdOverride: Override the app identifier (Bundle Id) for local debugging
  ///   - allowCheckOnSimulatorAndDebugging: Allow checking for updates when attached to a debugger and using a simulator
  @objc
  public init(apiKey: String,
              tagName: String? = nil,
              requiresLogin: Bool = false,
              binaryIdentifierOverride: String? = nil,
              appIdOverride: String? = nil,
              allowCheckOnSimulatorAndDebugging: Bool = false) {
    self.apiKey = apiKey
    self.tagName = tagName
    self.loginSetting = requiresLogin ? .default : nil
    self.loginLevel = requiresLogin ? .everything : .none
    self.binaryIdentifierOverride = binaryIdentifierOverride
    self.appIdOverride = appIdOverride
    self.allowCheckOnSimulatorAndDebugging = allowCheckOnSimulatorAndDebugging
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
  ///   - allowCheckOnSimulatorAndDebugging: Allow checking for updates when attached to a debugger and using a simulator
  @objc
  public init(apiKey: String,
              tagName: String? = nil,
              connection: String,
              loginLevel: LoginLevel = .everything,
              binaryIdentifierOverride: String? = nil,
              appIdOverride: String? = nil,
              allowCheckOnSimulatorAndDebugging: Bool = false) {
    self.apiKey = apiKey
    self.tagName = tagName
    self.loginSetting = .connection(connection)
    self.loginLevel = loginLevel
    self.binaryIdentifierOverride = binaryIdentifierOverride
    self.appIdOverride = appIdOverride
    self.allowCheckOnSimulatorAndDebugging = allowCheckOnSimulatorAndDebugging
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
  ///   - allowCheckOnSimulatorAndDebugging: Allow checking for updates when attached to a debugger and using a simulator
  public init(apiKey: String,
              tagName: String? = nil,
              loginSetting: LoginSetting,
              loginLevel: LoginLevel = .everything,
              binaryIdentifierOverride: String? = nil,
              appIdOverride: String? = nil,
              allowCheckOnSimulatorAndDebugging: Bool = false) {
    self.apiKey = apiKey
    self.tagName = tagName
    self.loginSetting = loginSetting
    self.loginLevel = loginLevel
    self.binaryIdentifierOverride = binaryIdentifierOverride
    self.appIdOverride = appIdOverride
    self.allowCheckOnSimulatorAndDebugging = allowCheckOnSimulatorAndDebugging
  }

  let apiKey: String
  let tagName: String?
  let loginSetting: LoginSetting?
  let loginLevel: LoginLevel?
  let binaryIdentifierOverride: String?
  let appIdOverride: String?
  let allowCheckOnSimulatorAndDebugging: Bool
}
