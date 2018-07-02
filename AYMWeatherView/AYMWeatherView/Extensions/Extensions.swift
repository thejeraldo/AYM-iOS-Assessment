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
