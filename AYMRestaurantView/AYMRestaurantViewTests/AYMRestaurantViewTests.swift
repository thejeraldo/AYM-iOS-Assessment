//
//  AYMRestaurantViewTests.swift
//  AYMRestaurantViewTests
//
//  Created by Jeraldo Abille on 6/28/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import XCTest
import CoreLocation
@testable import AYMRestaurantView

class AYMRestaurantViewTests: XCTestCase {
  
  let baseURL: String = "https://developers.zomato.com/api/v2.1"
  let apiKey: String = "020541769015d08a109afa60dde2703a"
  let coord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(24.2048, 55.2708)
  var entityId: String = "51201"
  var entityType: String = "subzone"
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testGeocodeAPI() {
    let expectation = XCTestExpectation(description: "Geocode API")
  
    let url = URL(string: baseURL)?.appendingPathComponent("geocode")
    let params = [
      "lat": "\(coord.latitude)",
      "lon": "\(coord.longitude)",
    ]
    let headers = [
      "user-key": apiKey
    ]
    
    NetworkClient.fetch(url: url!, method: .GET, parameters: params, headers: headers, responseType: GeoCode.self) { (geocode, error) in
      guard error == nil else {
        return
      }
      
      XCTAssert(geocode?.location != nil, "Location is nil.")
      expectation.fulfill()
    }
    
    wait(for: [ expectation ], timeout: 60)
  }
  
  func testSearchAPI() {
    let expectation = XCTestExpectation(description: "Search API")
    
    let url = URL(string: baseURL)?.appendingPathComponent("search")
    let params = [
      "count": "3",
      "radius": "100",
      "sort": "rating",
      "order": "desc",
      "entity_id": entityId,
      "entity_type": entityType,
      "lat": "\(coord.latitude)",
      "lon": "\(coord.longitude)",
    ]
    let headers = [
      "user-key": apiKey
    ]
    
    NetworkClient.fetch(url: url!, method: HTTPMethod.GET, parameters: params, headers: headers, responseType: RestaurantSearch.self) { (searchResults, error) in
      guard error == nil else {
        return
      }
      
      XCTAssert(searchResults?.restaurants != nil, "Location is nil.")
      XCTAssert(searchResults?.restaurants?.first?.details?.name != nil, "Location name is nil.")
      XCTAssert(searchResults?.restaurants?.first?.details?.thumb != nil, "Location thumb is nil.")
      XCTAssert(searchResults?.restaurants?.first?.details?.location?.city != nil, "Location city is nil.")
      XCTAssert(searchResults?.restaurants?.first?.details?.cuisines != nil, "Location cuisines is nil.")
      XCTAssert(searchResults?.restaurants?.first?.details?.userRating?.aggregateRating != nil, "Location ratings is nil.")
      XCTAssert(searchResults?.restaurants?.first?.details?.userRating?.votes != nil, "Location votes is nil.")
      
      XCTAssert(searchResults?.restaurants?.first?.details?.thumb != nil, "Location is nil.")
      
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
