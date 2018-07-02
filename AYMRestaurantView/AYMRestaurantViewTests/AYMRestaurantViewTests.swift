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
    
    let api = RestaurantAPI()
    api.geocode(apiKey: apiKey, coord: coord) { (geocode, error) in
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
    
    let api = RestaurantAPI()
    api.search(apiKey: apiKey, coord: coord, entityId: entityId, entityType: entityType) { (searchResults, error) in
      guard error == nil else {
        return
      }
      XCTAssert(searchResults?.restaurants != nil, "Restaurants is nil.")
      XCTAssert(searchResults?.restaurants?.first?.details?.name != nil, "Restaurant name is nil.")
      XCTAssert(searchResults?.restaurants?.first?.details?.thumb != nil, "Restaurant thumb is nil.")
      XCTAssert(searchResults?.restaurants?.first?.details?.location?.city != nil, "Restaurant city is nil.")
      XCTAssert(searchResults?.restaurants?.first?.details?.cuisines != nil, "Restaurant cuisines is nil.")
      XCTAssert(searchResults?.restaurants?.first?.details?.userRating?.aggregateRating != nil, "Restaurant ratings is nil.")
      XCTAssert(searchResults?.restaurants?.first?.details?.userRating?.votes != nil, "Restaurant votes is nil.")
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
