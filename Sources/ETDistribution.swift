//
//  ETDistribution.swift
//
//
//  Created by Itay Brenner on 5/9/24.
//

import UIKit
import Foundation

@objc
public final class ETDistribution: NSObject {
  // MARK: - Public
  @objc(sharedInstance)
  public static let shared = ETDistribution()

  /// Checks if there is an update available for the app, based on the provided `apiKey` and optional `tagName`.
  ///
  /// The `apiKey` is required to authenticate the request, and the `tagName` can optionally be
  /// provided to differentiate if the same binary has been uploaded with multiple tags.
  /// `tagName` is generally not needed, the SDK will identify the tag automatically.
  ///
  /// - Parameters:
  ///   - apiKey: A `String` API key used for authentication.
  ///   - tagName: An optional `String` that is the tag name used when this app was uploaded.
  ///   - completion: An optional closure that is called with the result of the update check. If `DistributionReleaseInfo` is nil, there is no updated available. If the closure is not provided, the SDK will present an alert to the user prompting to install the release.
  ///
  /// - Example:
  /// ```
  /// checkForUpdate(apiKey: "your_api_key", tagName: nil) { result in
  ///     switch result {
  ///     case .success(let releaseInfo):
  ///       if let releaseInfo {
  ///         print("Update found: \(releaseInfo)")
  ///       } else {
  ///         print("Already up to date")
  ///       }
  ///     case .failure(let error):
  ///         print("Error checking for update: \(error)")
  ///     }
  /// }
  /// ```
  public func checkForUpdate(apiKey: String,
                             tagName: String? = nil,
                             completion: ((Result<DistributionReleaseInfo?, Error>) -> Void)? = nil) {
    let params = CheckForUpdateParams(apiKey: apiKey, tagName: tagName)
    checkRequest(params: params, completion: completion)
  }
  
  /// Checks if there is an update available for the app, based on the provided `apiKey` and `tagName`with Objective-C compatibility.
  ///
  /// The `apiKey` is required to authenticate the request, and the `tagName` can optionally be
  /// provided to differentiate if the same binary has been uploaded with multiple tags.
  /// `tagName` is generally not needed, the SDK will identify the tag automatically.
  /// This function is designed for compatibility with Objective-C.
  ///
  /// - Parameters:
  ///   - apiKey: A `String` API key used for authentication.
  ///   - tagName: An optional `String` that is the tag name used when this app was uploaded.
  ///   - onReleaseAvailable: An optional closure that is called with the result of the update check. If `DistributionReleaseInfo` is nil,
  ///   there is no updated available. If the closure is not provided, the SDK will present an alert to the user prompting to install the release.
  ///   - onError: An optional closure that is called with an `Error` object if the update check fails. If no error occurs, this closure is not called.
  ///
  ///
  /// - Example:
  /// ```
  /// checkForUpdate(apiKey: "your_api_key", tagName: nil, onReleaseAvailable: { releaseInfo in
  ///     print("Release info: \(releaseInfo)")
  /// }, onError: { error in
  ///     print("Error checking for update: \(error)")
  /// })
  /// ```
  @objc
  public func checkForUpdate(apiKey: String,
                             tagName: String?,
                             onReleaseAvailable: ((DistributionReleaseInfo?) -> Void)? = nil,
                             onError: ((Error) -> Void)? = nil) {
    let params = CheckForUpdateParams(apiKey: apiKey, tagName: tagName)
    checkRequest(params: params) { result in
      switch result {
      case.success(let releaseInfo):
        onReleaseAvailable?(releaseInfo)
      case.failure(let error):
        onError?(error)
      }
    }
  }
  
  /// Checks if there is an update available for the app using a `CheckForUpdateParams` model for a more flexible configuration.
  ///
  /// This function performs an update check based on the provided `CheckForUpdateParams`, which includes essential data
  /// such as the API key, optional tag, and settings for Auth0-based login. The function supports custom configurations
  /// when user login is required through Auth0 for added security. If an update is found, the completion closure receives
  /// `DistributionReleaseInfo`; if there is no update, it receives `nil`.
  ///
  /// - Parameters:
  ///   - params: A `CheckForUpdateParams` instance containing required data for authentication and optional settings for Auth0 login.
  ///   - completion: An optional closure called with the result of the update check. If no update is available,
  ///                 `DistributionReleaseInfo` will be `nil`. If omitted, the SDK will prompt the user to install a new release if available.
  ///
  /// - Example:
  /// ```
  /// let params = CheckForUpdateParams(apiKey: "your_api_key", requiresLogin: true, connection: "auth0_connection_name")
  /// checkForUpdate(params: params) { result in
  ///     switch result {
  ///     case .success(let releaseInfo):
  ///         if let releaseInfo {
  ///             print("Update available: \(releaseInfo)")
  ///         } else {
  ///             print("App is up-to-date")
  ///         }
  ///     case .failure(let error):
  ///         print("Failed to check for updates: \(error)")
  ///     }
  /// }
  /// ```
  ///
  /// - Note: This function supports advanced configurations, including Auth0-based login, by setting `requiresLogin` to `true` and
  ///         providing the relevant `connection`. This allows the update check to authenticate users if required.
  public func checkForUpdate(params: CheckForUpdateParams,
                             completion: ((Result<DistributionReleaseInfo?, Error>) -> Void)? = nil) {
      checkRequest(params: params, completion: completion)
  }
  
  /// Checks if there is an update available for the app, based on the provided `apiKey` and `tagName`with Objective-C compatibility.
  ///
  /// This function performs an update check based on the provided `CheckForUpdateParams`, which includes essential data
  /// such as the API key, optional tag, and settings for Auth0-based login. The function supports custom configurations
  /// when user login is required through Auth0 for added security. If an update is found, the completion closure receives
  /// `DistributionReleaseInfo`; if there is no update, it receives `nil`.
  /// This function is designed for compatibility with Objective-C.
  ///
  /// - Parameters:
  ///   - params: A `CheckForUpdateParams` instance containing required data for authentication and optional settings for Auth0 login.
  ///   - onReleaseAvailable: An optional closure that is called with the result of the update check. If `DistributionReleaseInfo` is nil,
  ///   there is no updated available. If the closure is not provided, the SDK will present an alert to the user prompting to install the release.
  ///   - onError: An optional closure that is called with an `Error` object if the update check fails. If no error occurs, this closure is not called.
  ///
  ///
  /// - Example:
  /// ```
  /// let params = CheckForUpdateParams(apiKey: "your_api_key", requiresLogin: true, connection: "auth0_connection_name")
  /// checkForUpdate(params: params, onReleaseAvailable: { releaseInfo in
  ///     print("Release info: \(releaseInfo)")
  /// }, onError: { error in
  ///     print("Error checking for update: \(error)")
  /// })
  /// ```
  ///
  /// - Note: This function supports advanced configurations, including Auth0-based login, by setting `requiresLogin` to `true` and
  ///         providing the relevant `connection`. This allows the update check to authenticate users if required.
  @objc
  public func checkForUpdate(params: CheckForUpdateParams,
                             onReleaseAvailable: ((DistributionReleaseInfo?) -> Void)? = nil,
                             onError: ((Error) -> Void)? = nil) {
    checkRequest(params: params) { result in
      switch result {
      case.success(let releaseInfo):
        onReleaseAvailable?(releaseInfo)
      case.failure(let error):
        onError?(error)
      }
    }
  }

  public func buildUrlForInstall(_ plistUrl: String) -> URL? {
    guard var components = URLComponents(string: "itms-services://") else {
      return nil
    }
    components.queryItems = [
      URLQueryItem(name: "action", value: "download-manifest"),
      URLQueryItem(name: "url", value: plistUrl)
    ]
    return components.url
  }

  // MARK: - Private
  private lazy var session = URLSession(configuration: URLSessionConfiguration.ephemeral)
  private lazy var uuid = BinaryParser.getMainBinaryUUID()

  override private init() {
    super.init()
  }

  private func checkRequest(params: CheckForUpdateParams,
                            completion: ((Result<DistributionReleaseInfo?, Error>) -> Void)? = nil) {
#if targetEnvironment(simulator)
    // Not checking for updates on the simulator
    return
#else
    guard !isDebuggerAttached() else {
      // Not checking for updates when the debugger is attached
      return
    }

    if params.requiresLogin {
      Auth.getAccessToken(connection: params.connection) { [weak self] result in
        switch result {
        case .success(let accessToken):
          self?.performRequest(params: params, accessToken: accessToken, completion: completion)
        case .failure(let error):
          completion?(.failure(error))
        }
      }
    } else {
      performRequest(params: params, completion: completion)
    }
#endif
  }
  
  private func performRequest(params: CheckForUpdateParams,
                              accessToken: String? = nil,
                              completion: ((Result<DistributionReleaseInfo?, Error>) -> Void)? = nil) {
    guard var components = URLComponents(string: "https://api.emergetools.com/distribution/checkForUpdates") else {
      fatalError("Invalid URL")
    }
    
    components.queryItems = [
      URLQueryItem(name: "apiKey", value: params.apiKey),
      URLQueryItem(name: "binaryIdentifier", value: uuid),
      URLQueryItem(name: "appId", value: Bundle.main.bundleIdentifier),
      URLQueryItem(name: "platform", value: "ios")
    ]
    if let tagName = params.tagName {
      components.queryItems?.append(URLQueryItem(name: "tag", value: tagName))
    }
    
    guard let url = components.url else {
      fatalError("Invalid URL")
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    if accessToken != nil {
      request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
    
    session.checkForUpdate(request) { [weak self] result in
      let mappedResult = result.map { $0.updateInfo }
      if let completion = completion {
        completion(mappedResult)
      } else if let response = try? mappedResult.get() {
        self?.handleResponse(response: response)
      }
    }
  }
  
  private func handleResponse(response: DistributionReleaseInfo) {
    guard response.id != UserDefaults.skippedRelease,
          (UserDefaults.postponeTimeout == nil || UserDefaults.postponeTimeout! < Date() ) else {
      return
    }
    print("ETDistribution: Update Available: \(response.downloadUrl)")
    let message = "New version \(response.version) is available"

    var actions = [AlertAction]()
    actions.append(AlertAction(title: "Install",
                               style: .default,
                               handler: { [weak self] _ in
      self?.handleInstallRelease(response)
    }))
    actions.append(AlertAction(title: "Postpone updates for 1 day",
                               style: .cancel,
                               handler: { [weak self] _ in
      self?.handlePostponeRelease()
    }))
    actions.append(AlertAction(title: "Skip",
                               style: .destructive,
                               handler: { [weak self] _ in
      self?.handleSkipRelease(response)
    }))
    
    DispatchQueue.main.async {
      UIViewController.showAlert(title: "Update Available",
                                 message: message,
                                 actions: actions)
    }
  }
  
  private func isDebuggerAttached() -> Bool {
    var info = kinfo_proc()
    var size = MemoryLayout.stride(ofValue: info)
    var mib : [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
    let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
    assert(junk == 0, "sysctl failed")
    return (info.kp_proc.p_flag & P_TRACED) != 0
  }
  
  private func handleInstallRelease(_ release: DistributionReleaseInfo) {
    guard let url = self.buildUrlForInstall(release.downloadUrl) else {
      return
    }
    UIApplication.shared.open(url) { _ in
      // We need to exit since iOS doesn't start the install until the app exits
      exit(0)
    }
  }
  
  private func handleSkipRelease(_ release: DistributionReleaseInfo) {
    UserDefaults.skippedRelease = release.id
  }
  
  private func handlePostponeRelease() {
    UserDefaults.postponeTimeout = Date(timeIntervalSinceNow: 60 * 60 * 24)
  }
}
