//
//  WeatherViewModel.swift
//  AYMWeatherView
//
//  Created by Jeraldo Abille on 6/28/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

struct WeatherViewModel {
  var weather: Weather
  var dayText: String? {
    let df = DateFormatter()
    if let date = weather.date {
      df.dateFormat = "EEEE"
      return df.string(from: date)
    }
    return ""
  }
  var cityText: String {
    return weather.city ?? ""
  }
  var conditionImage: UIImage? {
    let condition = weather.weatherDetails?.first?.id ?? 0
    switch condition {
    case 200..<300:
      return UIImage(asset: .thunderstorm)
    case 300..<400: // Drizzle
      return UIImage(asset: .drizzle)
    case 500..<600: // Rain
      return UIImage(asset: .rain)
    case 600..<700: // Snow
      return UIImage(asset: .snow)
    case 700..<800: // Mist
      return UIImage(asset: .mist)
    case 800: // Clear
      return UIImage(asset: .clear)
    case 801..<805: // Clouds
      return UIImage(asset: .cloudy)
    default:
      return UIImage(asset: .clear)
    }
  }
  var temperatureText: String {
    let temperature = weather.main?.temp ?? 0.0
    let celsius = Int(temperature - 273.15)
    return "\(celsius)"
  }
  var temperatureUnitText: String {
    return "°C"
  }
  var descriptionText: String? {
    return weather.weatherDetails?.first?.weatherDescription ?? ""
  }
  var pressureText: String? {
    return "\(weather.main?.pressure ?? 0)"
  }
  var humidityText: String? {
    return "\(weather.main?.humidity ?? 0)"
  }
  var windText: String? {
    return "\(weather.wind?.speed ?? 0)"
  }
  
  init(_ weather: Weather) {
    self.weather = weather
  }
}

struct DailyForecastViewModel {
  var forecast: DailyForecast
  var dayText: String {
    let dateFormatter = DateFormatter()
    if let date = forecast.date {
      dateFormatter.dateFormat = "EEE"
      return dateFormatter.string(from: date)
    }
    return "--"
  }
  var maxTempString: String {
    let maxTemp = forecast.tempMax ?? 0.0
    let maxTempCelsius = Int(maxTemp - 273.15)
    return "\(maxTempCelsius)°"
  }
  var minTempString: String {
    let minTemp = forecast.tempMin ?? 0.0
    let minTempCelsius = Int(minTemp - 273.15)
    return "\(minTempCelsius)°"
  }
  var conditionImage: UIImage {
    let condition = forecast.condition ?? 0
    switch condition {
    case 200..<300:
      return UIImage(asset: .thunderstorm)
    case 300..<400: // Drizzle
      return UIImage(asset: .drizzle)
    case 500..<600: // Rain
      return UIImage(asset: .rain)
    case 600..<700: // Snow
      return UIImage(asset: .snow)
    case 700..<800: // Mist
      return UIImage(asset: .mist)
    case 800: // Clear
      return UIImage(asset: .clear)
    case 801..<805: // Clouds
      return UIImage(asset: .cloudy)
    default:
      return UIImage(asset: .clear)
    }
  }
  
  init(_ forecast: DailyForecast) {
    self.forecast = forecast
  }
}
