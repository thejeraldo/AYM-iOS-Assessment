//
//  AYMWeatherView.swift
//  AYMWeatherView
//
//  Created by Jeraldo Abille on 6/27/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import UIKit
import CoreLocation

open class AYMWeatherView: UIView {
  
  // MARK: - Enums
  
  public enum TemperatureUnits {
    case celsius
    case fahrenheit
  }
  
  // MARK: - Public Properties
  
  public var apiKey: String
  public var units: TemperatureUnits
  
  // MARK: - Private Properties
  @IBOutlet private weak var cityLabel: UILabel!
  @IBOutlet private weak var dayLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!
  @IBOutlet private weak var conditionImageView: UIImageView!
  @IBOutlet private weak var temperatureLabel: UILabel!
  @IBOutlet private weak var unitsLabel: UILabel!
  @IBOutlet private weak var humidityLabel: UILabel!
  @IBOutlet private weak var pressureLabel: UILabel!
  @IBOutlet private weak var windLabel: UILabel!
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var forecastCollectionView: UICollectionView!
  
  private var contentView: UIView?
  
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
    
    guard let view = loadViewFromNib() else {
      return
    }
    view.frame = bounds
    addSubview(view)
    contentView = view
    
    setDefaultValues()
  }
  
  // MARK: - Private Methods
  
  private func loadViewFromNib() -> UIView? {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "AYMWeatherView", bundle: bundle)
    return nib.instantiate(withOwner: self, options: nil).first as? UIView
  }
  
  private func setDefaultValues() {
    cityLabel.text = ""
    dayLabel.text = ""
    descriptionLabel.text = ""
    conditionImageView.image = nil
    temperatureLabel.text = "--"
    unitsLabel.text = units == .celsius ? "°C" : "°F"
    humidityLabel.text = "--"
    pressureLabel.text = "--"
    windLabel.text = "--"
  }
}
