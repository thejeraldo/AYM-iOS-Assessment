//
//  WeatherModel.swift
//  AYMWeatherView
//
//  Created by Jeraldo Abille on 6/27/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import Foundation

public struct WeatherForecast {
  var weather: Weather?
  var forecast: Forecast?
  var date: Date? {
    return self.weather?.date
  }
}

public struct Forecast: Codable {
  let list: [Weather]?
}

public struct Weather: Codable {
  let weatherDetails: [WeatherDetails]?
  let main: Main?
  let wind: Wind?
  let date: Date?
  let city: String?
  
  private enum CodingKeys: String, CodingKey {
    case weatherDetails = "weather"
    case main
    case wind
    case date = "dt"
    case city = "name"
  }
}

public struct WeatherDetails: Codable {
  let id: Int?
  let main: String?
  let weatherDescription: String?
  let icon: String?
  
  private enum CodingKeys: String, CodingKey {
    case id
    case main
    case weatherDescription = "description"
    case icon
  }
}

public struct Main: Codable {
  let temp: Double?
  let temp_min: Double?
  let temp_max: Double?
  let pressure: Double?
  let humidity: Int?
}

struct Wind: Codable {
  let speed: Double?
  let deg: Double?
}
