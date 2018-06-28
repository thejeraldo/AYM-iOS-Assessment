//
//  Array.swift
//  AYMWeatherView
//
//  Created by Jeraldo Abille on 6/28/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
  enum AssetIdentifier: String {
    case clear = "clear"
    case cloudy = "cloudy"
    case drizzle = "drizzle"
    case mist = "mist"
    case rain = "rain"
    case snow = "snow"
    case thunderstorm = "thunderstorm"
  }
  convenience init!(asset: AssetIdentifier) {
    let bundle = Bundle(for: AYMWeatherView.self)
    self.init(named: asset.rawValue, in: bundle, compatibleWith: nil)
  }
}

extension Array {
  func chunks(_ chunkSize: Int) -> [[Element]] {
    return stride(from: 0, to: self.count, by: chunkSize).map {
      Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
    }
  }
}

extension String {
  func capitalizingFirstLetter() -> String {
    return prefix(1).uppercased() + dropFirst()
  }
  
  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
}

extension UIAlertController {
  func presentInOwnWindow(animated: Bool, completion: (() -> Void)?) {
    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    alertWindow.windowLevel = UIWindowLevelAlert + 1;
    alertWindow.makeKeyAndVisible()
    alertWindow.rootViewController?.present(self, animated: animated, completion: completion)
  }
}
