//
//  AYMWeatherViewTests.swift
//  AYMWeatherViewTests
//
//  Created by Jeraldo Abille on 6/27/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import XCTest
import CoreLocation
@testable import AYMWeatherView

class AYMWeatherViewTests: XCTestCase {
  
  let baseURL: String = "https://api.openweathermap.org/data/2.5"
  let apiKey: String = "a052106f5d60e7b1389d825128d90275"
  let coord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(24.2048, 55.2708)
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testWeatherAPI() {
    let expectation = XCTestExpectation(description: "Weather Request")
    
    let api = WeatherAPI()
    api.getWeather(apiKey: apiKey, coordinates: coord) { (weather, error) in
      guard error == nil else {
        print("Error \(error!)")
        expectation.fulfill()
        return
      }
      XCTAssertNotNil(weather, "Weather is nil.")
      XCTAssertNotNil(weather?.weatherDetails?.first?.id, "Weather id is nil.")
      XCTAssertNotNil(weather?.weatherDetails?.first?.main, "Weather main is nil.")
      XCTAssertNotNil(weather?.main?.temp, "Weather main temp is nil.")
      XCTAssertNotNil(weather?.main?.tempMax, "Weather temp max is nil.")
      XCTAssertNotNil(weather?.main?.tempMin, "Weather temp min is nil.")
      XCTAssertNotNil(weather?.date, "Weather date is nil.")
      expectation.fulfill()
    }
    
    wait(for: [ expectation ], timeout: 60)
  }
  
  func testForecast() {
    let expectation = XCTestExpectation(description: "Forecast Request")
    
    let urlString = "\(baseURL)/forecast?APPID=\(apiKey)&lat=\(coord.latitude)&lon=\(coord.longitude)"
    let url = URL(string: urlString)
    let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
      guard error == nil else {
        print("Error \(error!)")
        expectation.fulfill()
        return
      }
      
      XCTAssertNotNil(data, "Response data is nil.")
      
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .secondsSince1970
      let forecast = try? decoder.decode(Forecast.self, from: data!)
      
      XCTAssertNotNil(forecast, "Forecast is nil.")
      XCTAssert(forecast?.list != nil, "Forecast list is nil.")
      
      expectation.fulfill()
    }
    dataTask.resume()
    
    wait(for: [ expectation ], timeout: 60)
  }
  
  func testWeatherViewAPIRequest() {
    let expectation = XCTestExpectation(description: "Weather View API Request")
    
    let weatherView = AYMWeatherView(apiKey: apiKey)
    weatherView.downloadWeather(coord: coord) { (error) in
      print("")
      XCTAssertNil(error, "Error is not nil.")
      expectation.fulfill()
    }
    
    wait(for: [ expectation ], timeout: 60)
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
}
