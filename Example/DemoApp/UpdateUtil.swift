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
                UIApplication.shared.open(url) { _ in
                  exit(0)
                }
            } else {
                print("Already up to date")
            }
        case .failure(let error):
            print("Error checking for update: \(error)")
        }
    }
  }
}
