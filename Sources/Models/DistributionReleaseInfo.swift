//
//  DistributionReleaseInfo.swift
//  
//
//  Created by Itay Brenner on 6/9/24.
//

import Foundation

public struct DistributionReleaseInfo: Decodable {
  public let id: String
  public let buildVersion: String
  public let buildNumber: Int
  public let releaseNotes: String?
  public let downloadUrl: String
  public let iconUrl: String?
  public let appName: String
  private let createdDate: String

  public var created: Date? {
    Date.fromString(createdDate)
  }
}
