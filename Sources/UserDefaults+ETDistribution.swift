//
//  UserDefaults+ETDistribution.swift
//
//
//  Created by Itay Brenner on 7/9/24.
//

import Foundation

extension UserDefaults {
  private enum Keys {
    static let skipedRelease = "skipedRelease"
    static let postponeTimeout = "postponeTimeout"
  }

  class var skippedRelease: String? {
    get {
      return UserDefaults(suiteName: "com.emerge.distribution")!.string(forKey: Keys.skipedRelease)
    }
    set {
      UserDefaults(suiteName: "com.emerge.distribution")!.set(newValue, forKey: Keys.skipedRelease)
    }
  }
  
  class var postponeTimeout: Date? {
    get {
      let epoch = UserDefaults(suiteName: "com.emerge.distribution")!.double(forKey: Keys.skipedRelease)
      return Date(timeIntervalSince1970: epoch)
    }
    set {
      UserDefaults(suiteName: "com.emerge.distribution")!.set(newValue?.timeIntervalSince1970, forKey: Keys.skipedRelease)
    }
  }
}
