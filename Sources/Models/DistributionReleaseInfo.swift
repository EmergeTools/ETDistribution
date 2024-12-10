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
  public let loginRequiredForDownload: Bool
}
