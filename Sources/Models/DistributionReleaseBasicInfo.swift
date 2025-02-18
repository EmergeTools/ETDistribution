//
//  DistributionReleaseBasicInfo.swift
//  ETDistribution
//
//  Created by Itay Brenner on 18/2/25.
//

import Foundation

@objc
public final class DistributionReleaseBasicInfo: NSObject, Decodable, Sendable {
  public let id: String
  public let tag: String
  public let version: String
  public let build: String
  public let appId: String
  public let iconUrl: String?
  public let appName: String
  private let createdDate: String

  public var created: Date? {
    Date.fromString(createdDate)
  }
}
