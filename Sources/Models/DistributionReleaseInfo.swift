//
//  DistributionReleaseInfo.swift
//  
//
//  Created by Itay Brenner on 6/9/24.
//

import Foundation

@objc
public final class DistributionReleaseInfo: NSObject, Decodable {
  public let id: String
  public let tag: String
  public let version: String
  public let appId: String
  public let downloadUrl: String
  public let iconUrl: String?
  public let appName: String
  private let createdDate: String
  private let currentReleaseDate: String
  public let loginRequiredForDownload: Bool

  public var currentReleaseCreated: Date? {
    let formatter = ISO8601DateFormatter()
    return formatter.date(from: currentReleaseDate)
  }

  public var created: Date? {
    let formatter = ISO8601DateFormatter()
    return formatter.date(from: createdDate)
  }
}
