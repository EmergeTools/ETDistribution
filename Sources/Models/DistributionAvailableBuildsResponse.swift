//
//  DistributionAvailableBuildsResponse.swift
//  ETDistribution
//
//  Created by Itay Brenner on 17/2/25.
//

public struct DistributionAvailableBuildsResponse: Decodable, Sendable {
  let page: Int
  let totalPages: Int
  let totalBuilds: Int
  let builds: [DistributionReleaseBasicInfo]
}
