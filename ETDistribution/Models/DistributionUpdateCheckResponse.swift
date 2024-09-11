//
//  DistributionUpdateCheckResponse.swift
//
//
//  Created by Itay Brenner on 6/9/24.
//

import Foundation

struct DistributionUpdateCheckResponse: Decodable {
  let updateInfo: DistributionReleaseInfo?
}

struct DistributionUpdateCheckErrorResponse: Decodable {
  let message: String
}
