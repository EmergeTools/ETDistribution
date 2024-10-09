//
//  UpdateUtil.swift
//  DemoApp
//
//  Created by Itay Brenner on 9/10/24.
//

import Foundation
import ETDistribution

struct UpdateUtil {
  static func checkForUpdates() {
    ETDistribution.shared.checkForUpdate(apiKey: Constants.apiKey) { result in
        switch result {
        case .success(let releaseInfo):
            if let releaseInfo {
                print("Update found: \(releaseInfo)")
            } else {
                print("Already up to date")
            }
        case .failure(let error):
            print("Error checking for update: \(error)")
        }
    }
  }
}
