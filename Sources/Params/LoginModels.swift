//
//  LoginModels.swift
//  ETDistribution
//
//  Created by Itay Brenner on 18/2/25.
//

/// Type of authenticated access to required. The default case shows the Emerge Tools login page.
/// A custom connection can be used to automatically redirect to an SSO page.
public enum LoginSetting: Sendable {
  case `default`
  case connection(String)
}

/// Level of login required. By default no login is required
/// Available levels:
///   - none: No login is requiried
///   - onlyForDownload: login is required only when downloading the app
///   - everything: login is always required when doing API calls.
@objc
public enum LoginLevel: Int, Sendable {
  case noLogin
  case onlyForDownload
  case everything
}
