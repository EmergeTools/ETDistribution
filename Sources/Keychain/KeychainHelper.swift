//
//  File.swift
//  ETDistribution
//
//  Created by Itay Brenner on 30/10/24.
//

import Foundation

enum KeychainError: LocalizedError {
  case unexpectedStatus(OSStatus)
}

enum KeychainHelper {
  static let service = "com.emerge.ETDistribution"
  
  static func setToken(_ token: String, key: String) throws {
    let existingToken = try getToken(key: key)
    if existingToken == nil {
      try addToken(token, key: key)
    } else {
      try updateToken(token, key: key)
    }
  }
  
  static func getToken(key: String) -> String? {
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: key,
        kSecMatchLimit: kSecMatchLimitOne,
        kSecReturnData: true
    ] as CFDictionary

    var result: AnyObject?
    let status = SecItemCopyMatching(query, &result)

    guard status == errSecSuccess else {
      return nil
    }
    return dataToToken(result as! Data)
  }
  
  private static func addToken(_ token: String, key: String) throws {
    let data = tokenToData(token)
    
    let attributes = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: key,
      kSecValueData: data
    ] as CFDictionary

    let status = SecItemAdd(attributes, nil)
    guard status == errSecSuccess else {
      throw KeychainError.unexpectedStatus(status)
    }
  }
  
  private static func updateToken(_ token: String, key: String) throws {
    let data = tokenToData(token)
    let query = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: key
    ] as CFDictionary

    let attributes = [
      kSecValueData: data
    ] as CFDictionary

    let status = SecItemUpdate(query, attributes)
    guard status == errSecSuccess else {
      throw KeychainError.unexpectedStatus(status)
    }
  }
  
  private static func tokenToData(_ token: String) -> Data {
    return token.data(using: .utf8) ?? Data()
  }
  
  private static func dataToToken(_ data: Data) -> String {
    return String(data: data, encoding: .utf8) ?? ""
  }
}
