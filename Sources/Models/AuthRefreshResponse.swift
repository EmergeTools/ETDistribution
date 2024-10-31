//
//  AuthRefreshResponse.swift
//  ETDistribution
//
//  Created by Itay Brenner on 31/10/24.
//

import Foundation

struct AuthRefreshResponse: Decodable {
  let tokenType: String
  let idToken: String
  let accessToken: String
  let scope: String
  let expiresIn: Int
}
