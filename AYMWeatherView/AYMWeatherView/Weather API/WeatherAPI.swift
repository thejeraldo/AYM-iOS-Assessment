//
//  WeatherAPI.swift
//  AYMWeatherView
//
//  Created by Jeraldo Abille on 6/27/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import Foundation
import CoreLocation
import Common

public struct WeatherAPI { }

// MARK: - End Point

extension WeatherAPI: EndPointProtocol {
  public var baseURL: URL {
    return URL(string: "https://api.openweathermap.org/data/2.5")!
  }
  
  public var path: String {
    return ""
  }
  
  public var method: HTTPMethod {
    return .GET
  }
}

// MARK: - API Requests

extension WeatherAPI {
  
  public typealias weatherRequestCompletion = (_ weather: Weather?, _ error: Error?) -> ()
  public typealias forecastRequestCompletion = (_ weather: Forecast?, _ error: Error?) -> ()
  
  public func getWeather(apiKey: String, coordinates: CLLocationCoordinate2D?, completion: @escaping weatherRequestCompletion) {
    let url = baseURL.appendingPathComponent("weather")
    let params: [String: String] = [
      "APPID": apiKey,
      "lat": "\(coordinates?.latitude ?? 0.0)",
      "lon": "\(coordinates?.longitude ?? 0.0)"
    ]
    
    NetworkClient.fetch(url: url, method: .GET, parameters: params, headers: nil, responseType: Weather.self) { (weather, error) in
      guard error == nil else {
        print("Weather service error: \(error!)")
        completion(nil, error!)
        return
      }
      completion(weather, nil)
    }
  }
  
  public func getForecast(apiKey: String, coordinates: CLLocationCoordinate2D?, completion: @escaping forecastRequestCompletion) {
    let url = baseURL.appendingPathComponent("forecast")
    let params: [String: String] = [
      "APPID": apiKey,
      "lat": "\(coordinates?.latitude ?? 0.0)",
      "lon": "\(coordinates?.longitude ?? 0.0)"
    ]
    
    NetworkClient.fetch(url: url, method: .GET, parameters: params, headers: nil, responseType: Forecast.self) { (forecast, error) in
      guard error == nil else {
        print("Forecast service error: \(error!)")
        completion(nil, error!)
        return
      }
      completion(forecast, nil)
    }
  }
}
