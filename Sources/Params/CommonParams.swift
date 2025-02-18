//
//  CommonParams.swift
//  ETDistribution
//
//  Created by Itay Brenner on 18/2/25.
//

import Foundation

@objc
public class CommonParams: NSObject {
  public init(apiKey: String,
              loginSetting: LoginSetting?,
              loginLevel: LoginLevel?) {
    self.apiKey = apiKey
    self.loginSetting = loginSetting
    self.loginLevel = loginLevel
  }

  let apiKey: String
  let loginSetting: LoginSetting?
  let loginLevel: LoginLevel?
}
