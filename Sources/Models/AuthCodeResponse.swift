//
//  File.swift
//  ETDistribution
//
//  Created by Itay Brenner on 31/10/24.
//

import Foundation

struct AuthCodeResponse: Decodable {
  let tokenType: String
  let idToken: String
  let expiresIn: Int
  let accessToken: String
  let refreshToken: String
}
