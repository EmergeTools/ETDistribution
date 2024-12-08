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
    ETDistribution.shared.checkForUpdate(params: CheckForUpdateParams(apiKey: Constants.apiKey)) { result in
      switch result {
      case .success(let releaseInfo):
        if let releaseInfo {
          print("Update found: \(releaseInfo)")
          guard let url = ETDistribution.shared.buildUrlForInstall(releaseInfo.downloadUrl) else {
            return
          }
          DispatchQueue.main.async {
            UIApplication.shared.open(url) { _ in
              exit(0)
            }
          }
        } else {
          print("Already up to date")
        }
      case .failure(let error):
        print("Error checking for update: \(error)")
      }
    }
  }
  
  static func checkForUpdatesWithLogin() {
    let params = CheckForUpdateParams(apiKey: Constants.apiKey, requiresLogin: true)
    ETDistribution.shared.checkForUpdate(params: params) { result in
      switch result {
      case .success(let releaseInfo):
        if let releaseInfo {
          print("Update found: \(releaseInfo)")
          guard let url = ETDistribution.shared.buildUrlForInstall(releaseInfo.downloadUrl) else {
            return
          }
          DispatchQueue.main.async {
            UIApplication.shared.open(url) { _ in
              exit(0)
            }
          }
        } else {
          print("Already up to date")
        }
      case .failure(let error):
        print("Error checking for update: \(error)")
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
}
