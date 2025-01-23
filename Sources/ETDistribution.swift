//
//  ETDistribution.swift
//
//
//  Created by Itay Brenner on 5/9/24.
//

import UIKit
import Foundation

@objc @MainActor
public final class ETDistribution: NSObject {
  // MARK: - Public
  @objc(sharedInstance)
  public static let shared = ETDistribution()

  /// Checks if there is an update available for the app, based on the provided `params`.
  ///
  ///
  /// - Parameters:
  ///   - params: A `CheckForUpdateParams` object.
  ///   - completion: An optional closure that is called with the result of the update check. If `DistributionReleaseInfo` is nil, there is no updated available. If the closure is not provided, the SDK will present an alert to the user prompting to install the release.
  ///
  /// - Example:
  /// ```
  /// let params = CheckForUpdateParams(apiKey: "your_api_key")
  /// checkForUpdate(params: params) { result in
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
  public func checkForUpdate(params: CheckForUpdateParams,
                             completion: (@MainActor (Result<DistributionReleaseInfo?, Error>) -> Void)? = nil) {
    checkRequest(params: params, completion: completion)
  }
  
  /// Checks if there is an update available for the app, based on the provided `params` with Objective-C compatibility.
  ///
  /// This function is designed for compatibility with Objective-C.
  ///
  /// - Parameters:
  ///   - params: A `CheckForUpdateParams` object.
  ///   - onReleaseAvailable: An optional closure that is called with the result of the update check. If `DistributionReleaseInfo` is nil,
  ///   there is no updated available. If the closure is not provided, the SDK will present an alert to the user prompting to install the release.
  ///   - onError: An optional closure that is called with an `Error` object if the update check fails. If no error occurs, this closure is not called.
  ///
  ///
  /// - Example:
  /// ```
  /// let params = CheckForUpdateParams(apiKey: "your_api_key")
  /// checkForUpdate(params: params, onReleaseAvailable: { releaseInfo in
  ///     print("Release info: \(releaseInfo)")
  /// }, onError: { error in
  ///     print("Error checking for update: \(error)")
  /// })
  /// ```
  @objc
  public func checkForUpdate(params: CheckForUpdateParams,
                             onReleaseAvailable: (@MainActor (DistributionReleaseInfo?) -> Void)? = nil,
                             onError: (@MainActor (Error) -> Void)? = nil) {
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
    guard plistUrl != "REQUIRES_LOGIN",
      var components = URLComponents(string: "itms-services://") else {
      return nil
    }
    components.queryItems = [
      URLQueryItem(name: "action", value: "download-manifest"),
      URLQueryItem(name: "url", value: plistUrl)
    ]
    return components.url
  }
  
  public func getReleaseInfo(releaseId: String, completion: @escaping (@Sendable (Result<DistributionReleaseInfo, Error>) -> Void)) {
    if let loginSettings = loginSettings,
       (loginLevel?.rawValue ?? 0) > LoginLevel.none.rawValue {
      Auth.getAccessToken(settings: loginSettings) { [weak self] result in
        switch result {
        case .success(let accessToken):
          self?.getReleaseInfo(releaseId: releaseId, accessToken: accessToken, completion: completion)
        case .failure(let error):
          completion(.failure(error))
        }
      }
    } else {
      getReleaseInfo(releaseId: releaseId, accessToken: nil) { [weak self] result in
        if case .failure(let error) = result,
           case RequestError.loginRequired = error {
          Task { [weak self] in
            // Attempt login if backend returns "Login Required"
            await self?.setLoginRequired()
            await self?.getReleaseInfo(releaseId: releaseId, completion: completion)
          }
          return
        }
        completion(result)
      }
    }
  }
  
  private func setLoginRequired() {
    loginSettings = LoginSetting.default
    loginLevel = .onlyForDownload
  }

  // MARK: - Private
  private lazy var session = URLSession(configuration: URLSessionConfiguration.ephemeral)
  private lazy var uuid = BinaryParser.getMainBinaryUUID()
  private var loginSettings: LoginSetting?
  private var loginLevel: LoginLevel?
  private var apiKey: String = ""

  override private init() {
    super.init()
  }

  private func checkRequest(params: CheckForUpdateParams,
                            completion: (@MainActor (Result<DistributionReleaseInfo?, Error>) -> Void)? = nil) {
#if targetEnvironment(simulator)
    // Not checking for updates on the simulator
    return
#else
    guard !isDebuggerAttached() else {
      // Not checking for updates when the debugger is attached
      return
    }
    apiKey = params.apiKey
    loginLevel = params.loginLevel
    loginSettings = params.loginSetting

    if let loginSettings = params.loginSetting,
       params.loginLevel == .everything {
      Auth.getAccessToken(settings: loginSettings) { [weak self] result in
        switch result {
        case .success(let accessToken):
          self?.getUpdatesFromBackend(params: params, accessToken: accessToken, completion: completion)
        case .failure(let error):
          completion?(.failure(error))
        }
      }
    } else {
      getUpdatesFromBackend(params: params, accessToken: nil) { [weak self] result in
        if case .failure(let error) = result,
           case RequestError.loginRequired = error {
          // Attempt login if backend returns "Login Required"
          let params = CheckForUpdateParams(apiKey: params.apiKey, tagName: params.tagName, requiresLogin: true)
          self?.checkRequest(params: params, completion: completion)
          return
        }
        completion?(result)
      }
    }
#endif
  }
  
  private func getUpdatesFromBackend(params: CheckForUpdateParams,
                              accessToken: String? = nil,
                                     completion: (@MainActor (Result<DistributionReleaseInfo?, Error>) -> Void)? = nil) {
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
    if let accessToken = accessToken {
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
  
  private func getReleaseInfo(releaseId: String,
                              accessToken: String? = nil,
                              completion: @escaping @Sendable (Result<DistributionReleaseInfo, Error>) -> Void) {
    guard var components = URLComponents(string: "https://api.emergetools.com/distribution/getRelease") else {
      fatalError("Invalid URL")
    }
    
    components.queryItems = [
      URLQueryItem(name: "apiKey", value: apiKey),
      URLQueryItem(name: "uploadId", value: releaseId),
      URLQueryItem(name: "platform", value: "ios")
    ]
    
    guard let url = components.url else {
      fatalError("Invalid URL")
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    if let accessToken = accessToken {
      request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
    
    session.getReleaseInfo(request, completion: completion)
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
    if release.loginRequiredForDownload, let loginSettings = loginSettings {
      Auth.getAccessToken(settings: loginSettings) { [weak self] result in
        guard case let .success(accessToken) = result else {
          return
        }
        self?.getReleaseInfo(releaseId: release.id, accessToken: accessToken) { [weak self] result in
          guard case .success(let release) = result else {
            return
          }
          Task { [weak self] in
            await self?.installAppWithDownloadString(release.downloadUrl)
          }
        }
      }
    } else {
      installAppWithDownloadString(release.downloadUrl)
    }
  }
  
  private func installAppWithDownloadString(_ urlString: String) {
    guard let url = self.buildUrlForInstall(urlString) else {
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
