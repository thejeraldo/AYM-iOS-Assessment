//
//  AYMWeatherView.swift
//  AYMWeatherView
//
//  Created by Jeraldo Abille on 6/27/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import UIKit

open class AYMWeatherView: UIView {
  
  // MARK: - Enums
  
  public enum TemperatureUnits {
    case celsius
    case fahrenheit
  }
  
  // MARK: - Public Properties
  
  public var apiKey: String
  public var units: TemperatureUnits
  
  // MARK: - Initialization
  
  public init(apiKey: String, units: TemperatureUnits = .celsius) {
    self.apiKey = apiKey
    self.units = units
    super.init(frame: CGRect.zero)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    self.apiKey = ""
    self.units = .celsius
    super.init(coder: aDecoder)
  }
}
