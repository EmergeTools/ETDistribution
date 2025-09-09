//
//  DistributionUpdateCheckResponse.swift
//
//
//  Created by Itay Brenner on 6/9/24.
//

import Foundation

public struct DistributionUpdateCheckResponse: Decodable {
  public let current: DistributionReleaseInfo?
  public let update: DistributionReleaseInfo?
}
