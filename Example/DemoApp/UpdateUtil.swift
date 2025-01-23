//
//  UpdateUtil.swift
//  DemoApp
//
//  Created by Itay Brenner on 9/10/24.
//  Copyright © 2024 Emerge Tools. All rights reserved.
//

import Foundation
import UIKit
import ETDistribution

struct UpdateUtil {
  static func checkForUpdates() {
    let params = CheckForUpdateParams(apiKey: Constants.apiKey, requiresLogin: false, allowCheckOnSimulatorAndDebugging: true)
    ETDistribution.shared.checkForUpdate(params: params) { result in
      guard case let .success(releaseInfo) = result else {
        if case let .failure(error) = result {
          print("Error checking for update: \(error)")
        }
        return
      }
      
      guard let releaseInfo = releaseInfo else {
        print("Already up to date")
        return
      }
      
      print("Update found: \(releaseInfo), requires login: \(releaseInfo.loginRequiredForDownload)")
      if releaseInfo.loginRequiredForDownload {
        // Get new release info, with login
        ETDistribution.shared.getReleaseInfo(releaseId: releaseInfo.id) { newReleaseInfo in
          if case let .success(newReleaseInfo) = newReleaseInfo {
            UpdateUtil.installRelease(releaseInfo: newReleaseInfo)
          }
        }
      } else {
        UpdateUtil.installRelease(releaseInfo: releaseInfo)
      }
    }
  }
  
  static func checkForUpdatesWithLogin() {
    let params = CheckForUpdateParams(apiKey: Constants.apiKey, requiresLogin: true, allowCheckOnSimulatorAndDebugging: true)
    ETDistribution.shared.checkForUpdate(params: params) { result in
      guard case let .success(releaseInfo) = result else {
        if case let .failure(error) = result {
          print("Error checking for update: \(error)")
        }
        return
      }
      
      guard let releaseInfo = releaseInfo else {
        print("Already up to date")
        return
      }
      
      print("Update found: \(releaseInfo), requires login: \(releaseInfo.loginRequiredForDownload)")
      if releaseInfo.loginRequiredForDownload {
        // Get new release info, with login
        ETDistribution.shared.getReleaseInfo(releaseId: releaseInfo.id) { newReleaseInfo in
          if case let .success(newReleaseInfo) = newReleaseInfo {
            UpdateUtil.installRelease(releaseInfo: newReleaseInfo)
          }
        }
      } else {
        UpdateUtil.installRelease(releaseInfo: releaseInfo)
      }
    }
  }
  
  static func clearTokens() {
    delete(key: "accessToken") {
      delete(key: "refreshToken") {
        print("Tokens cleared")
      }
    }
  }
  
  private static func delete(key: String, completion: @escaping () -> Void) {
    DispatchQueue.global().async {
      let attributes = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: "com.emerge.ETDistribution",
        kSecAttrAccount: key,
      ] as CFDictionary

      SecItemDelete(attributes)
      
      completion()
    }
  }
  
  private static func installRelease(releaseInfo: DistributionReleaseInfo) {
    guard let url = ETDistribution.shared.buildUrlForInstall(releaseInfo.downloadUrl) else {
      return
    }
    DispatchQueue.main.async {
      UIApplication.shared.open(url) { _ in
        exit(0)
      }
    }
  }
}
