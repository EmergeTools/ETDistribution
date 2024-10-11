//
//  UIViewController+Distribute.swift
//
//
//  Created by Itay Brenner on 6/9/24.
//

import UIKit
import Foundation

struct AlertAction {
  let title: String
  let style: UIAlertAction.Style
  let handler: (UIAlertAction) -> Void
}

extension UIViewController {
  static func topMostViewController() -> UIViewController? {
    guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
      return nil
    }
    return findTopViewController(rootViewController)
  }
  
  private static func findTopViewController(_ viewController: UIViewController) -> UIViewController {
    if let presentedViewController = viewController.presentedViewController {
      return findTopViewController(presentedViewController)
    } else if let navigationController = viewController as? UINavigationController {
      return findTopViewController(navigationController.visibleViewController ?? navigationController)
    } else if let tabBarController = viewController as? UITabBarController,
              let selectedViewController = tabBarController.selectedViewController {
      return findTopViewController(selectedViewController)
    } else {
      return viewController
    }
  }
  
  static func showAlert(title: String, message: String, actions: [AlertAction]) {
    guard let topViewController = topMostViewController() else {
      print("No top view controller found")
      return
    }
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    actions.forEach { action in
      alertController.addAction(UIAlertAction(title: action.title, style: action.style, handler: action.handler))
    }
    
    topViewController.present(alertController, animated: true, completion: nil)
  }
}
