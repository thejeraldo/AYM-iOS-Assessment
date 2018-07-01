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

public struct Forecast: Codable {
  public let list: [Weather]?
  public func fiveDayForecast() -> [DailyForecast]? {
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
          let temp_max = weather.main?.tempMax
          let temp_min = weather.main?.tempMin
          if temp_max! > maxTemp {
            maxTemp = temp_max!
          }
          if temp_min! < minTemp {
            minTemp = temp_min!
          }
        }
        let date = dateFormatter.date(from: group.key)
        let condition = group.value.last?.weatherDetails?.last?.id
        let dailyForecast = DailyForecast(tempMin: minTemp, tempMax: maxTemp, date: date, condition: condition)
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
  public let tempMin: Double?
  public let tempMax: Double?
  public let date: Date?
  public let condition: Int?
}

public struct Weather: Codable {
  public let weatherDetails: [WeatherDetails]?
  public let main: Main?
  public let wind: Wind?
  public let date: Date?
  public let city: String?
  
  private enum CodingKeys: String, CodingKey {
    case weatherDetails = "weather"
    case main
    case wind
    case date = "dt"
    case city = "name"
  }
}

public struct WeatherDetails: Codable {
  public let id: Int?
  public let main: String?
  public let weatherDescription: String?
  public let icon: String?
  
  private enum CodingKeys: String, CodingKey {
    case id
    case main
    case weatherDescription = "description"
    case icon
  }
}

public struct Main: Codable {
  public let temp: Double?
  public let tempMin: Double?
  public let tempMax: Double?
  public let pressure: Double?
  public let humidity: Int?
}

public struct Wind: Codable {
  public let speed: Double?
  public let deg: Double?
}
