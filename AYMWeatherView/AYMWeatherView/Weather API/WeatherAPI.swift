//
//  WeatherAPI.swift
//  AYMWeatherView
//
//  Created by Jeraldo Abille on 6/27/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherAPI { }

// MARK: - End Point

extension WeatherAPI: EndPointProtocol {
  var baseURL: URL {
    return URL(string: "https://api.openweathermap.org/data/2.5")!
  }
  
  var path: String {
    return ""
  }
  
  var method: HTTPMethod {
    return .GET
  }
}

// MARK: - API Requests

extension WeatherAPI {
  
  typealias weatherRequestCompletion = (_ weather: Weather?, _ error: Error?) -> ()
  typealias forecastRequestCompletion = (_ weather: Forecast?, _ error: Error?) -> ()
  
  func getWeather(apiKey: String, coordinates: CLLocationCoordinate2D?, completion: @escaping weatherRequestCompletion) {
    let url = baseURL.appendingPathComponent("weather")
    let params: [String: String] = [
      "APPID": apiKey,
      "lat": "\(coordinates?.latitude ?? 0.0)",
      "lon": "\(coordinates?.longitude ?? 0.0)"
    ]
    
    NetworkClient.fetch(url: url, method: .GET, parameters: params, responseType: Weather.self) { (weather, error) in
      guard error == nil else {
        print("Weather service error: \(error!)")
        completion(nil, error!)
        return
      }
      completion(weather, nil)
    }
  }
  
  func getForecast(apiKey: String, coordinates: CLLocationCoordinate2D?, completion: @escaping forecastRequestCompletion) {
    let url = baseURL.appendingPathComponent("forecast")
    let params: [String: String] = [
      "APPID": apiKey,
      "lat": "\(coordinates?.latitude ?? 0.0)",
      "lon": "\(coordinates?.longitude ?? 0.0)"
    ]
    
    NetworkClient.fetch(url: url, method: .GET, parameters: params, responseType: Forecast.self) { (forecast, error) in
      guard error == nil else {
        print("Forecast service error: \(error!)")
        completion(nil, error!)
        return
      }
      completion(forecast, nil)
    }
  }
}
