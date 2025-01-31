//
//  DistributionReleaseInfo.swift
//  
//
//  Created by Itay Brenner on 6/9/24.
//

import Foundation

@objc
public final class DistributionReleaseInfo: NSObject, Decodable, Sendable {
  public let id: String
  public let tag: String
  public let version: String
  public let build: String
  public let appId: String
  public let downloadUrl: String
  public let iconUrl: String?
  public let appName: String
  private let createdDate: String
  private let currentReleaseDate: String
  public let loginRequiredForDownload: Bool

  public var currentReleaseCreated: Date? {
    Date.fromString(currentReleaseDate)
  }

  public var created: Date? {
    Date.fromString(createdDate)
  }
}
