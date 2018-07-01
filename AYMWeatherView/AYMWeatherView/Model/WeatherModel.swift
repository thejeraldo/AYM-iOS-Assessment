//
//  WeatherModel.swift
//  AYMWeatherView
//
//  Created by Jeraldo Abille on 6/27/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import Foundation

struct WeatherForecast {
  var weather: Weather?
  var forecast: Forecast?
  var date: Date? {
    return self.weather?.date
  }
}

struct Forecast: Codable {
  let list: [Weather]?
  func fiveDayForecast() -> [DailyForecast]? {
    var forecast = [DailyForecast]()
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "MMM dd yyyy"
    if let list = self.list {
      let chunks = Dictionary(grouping: list) { (weather) -> String in
        let dateString = dateFormatter.string(from: weather.date!)
        return dateString
      }
      for group in chunks {
        var maxTemp = 0.0
        var minTemp = Double.greatestFiniteMagnitude
        for weather in group.value {
          let temp_max = weather.main?.temp_max
          let temp_min = weather.main?.temp_min
          if temp_max! > maxTemp {
            maxTemp = temp_max!
          }
          if temp_min! < minTemp {
            minTemp = temp_min!
          }
        }
        let date = dateFormatter.date(from: group.key)
        let condition = group.value.last?.weatherDetails?.last?.id
        let dailyForecast = DailyForecast(temp_min: minTemp, temp_max: maxTemp, date: date, condition: condition)
        forecast.append(dailyForecast)
      }
    }
    forecast.sort {
      $0.date! < $1.date!
    }
    return Array(forecast.prefix(5))
  }
}

public struct DailyForecast {
  public let temp_min: Double?
  public let temp_max: Double?
  public let date: Date?
  public let condition: Int?
}

struct Weather: Codable {
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

struct WeatherDetails: Codable {
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

struct Main: Codable {
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
