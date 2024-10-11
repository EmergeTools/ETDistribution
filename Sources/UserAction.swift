//
//  UserAction.swift
//  
//
//  Created by Itay Brenner on 5/9/24.
//

import Foundation

@objc
public enum UserAction: Int {
  // User won't be notified of this update again
  case skip
  // User won't be notified of *any* update for 1 full day
  case postpone
  case install
}
