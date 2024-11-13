//
//  JWTHelper.swift
//  ETDistribution
//
//  Created by Itay Brenner on 30/10/24.
//

import Foundation

enum JWTHelper {
  /// Only checks for the expiration, not the signature
  static func isValid(token: String) -> Bool {
    guard let payload = parsePayload(token),
          let exp = payload["exp"] as? TimeInterval else {
      return false
    }
    let expirationDate = Date(timeIntervalSince1970: exp)
    return Date() < expirationDate
  }
    
  private static func parsePayload(_ token: String) -> [String: Any]? {
    let segments = token.split(separator: ".")
    guard segments.count > 1 else { return nil }
        
    let payloadSegment = String(segments[1])
        
    guard let decodedData = decodeBase64URL(payloadSegment),
          let json = try? JSONSerialization.jsonObject(with: decodedData, options: []),
          let payload = json as? [String: Any] else {
      return nil
    }
    
    return payload
  }
    
  private static func decodeBase64URL(_ string: String) -> Data? {
    var base64 = string
      .replacingOccurrences(of: "-", with: "+")
      .replacingOccurrences(of: "_", with: "/")
    
    while base64.count % 4 != 0 {
      base64 += "="
    }
    
    return Data(base64Encoded: base64)
  }
}
