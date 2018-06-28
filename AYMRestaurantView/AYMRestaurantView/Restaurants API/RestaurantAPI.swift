//
//  RestaurantAPI.swift
//  AYMRestaurantView
//
//  Created by Jeraldo Abille on 6/28/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import Foundation
import CoreLocation

struct RestaurantAPI: EndPointProtocol {
  var apiKey: String
  
  var baseURL: URL {
    return URL(string: "https://developers.zomato.com/api/v2.1")!
  }
  
  var path: String {
    return ""
  }
  
  var method: HTTPMethod {
    return .GET
  }
}

extension RestaurantAPI {
  typealias geoCodeCompletion = (_ geocode: GeoCode?, _ error: Error?) -> ()
  typealias searchCompletion = (_ searchResults: RestaurantSearch?, _ error: Error?) -> ()
  func geocode(coord: CLLocationCoordinate2D, completion: @escaping geoCodeCompletion) {
    let url = baseURL.appendingPathComponent("geocode")
    let params: [String: String] = [
      "lat": "\(coord.latitude)",
      "lon": "\(coord.longitude)"
    ]
    let headers: [String: String] = [
      "user-key": apiKey
    ]
    NetworkClient.fetch(url: url, method: .GET, parameters: params, headers: headers, responseType: GeoCode.self) { (geocode, error) in
      guard error == nil else {
        print("Geocode service error: \(error!)")
        completion(nil, error!)
        return
      }
      completion(geocode, nil)
    }
  }
  
  func search(coord: CLLocationCoordinate2D, entityId: String, entityType: String, completion: @escaping searchCompletion) {
    let url = baseURL.appendingPathComponent("search")
    let params: [String: String] = [
      "lat": "\(coord.latitude)",
      "lon": "\(coord.longitude)",
      "entity_id": entityId,
      "entity_type": entityType,
      "count": "3",
      "radius": "100", // meters
      "sort": "rating",
      "order": "desc"
    ]
    let headers: [String: String] = [
      "user-key": apiKey
    ]
    NetworkClient.fetch(url: url, method: .GET, parameters: params, headers: headers, responseType: RestaurantSearch.self) { (searchResults, error) in
      guard error == nil else {
        print("Geocode service error: \(error!)")
        completion(nil, error!)
        return
      }
      completion(searchResults, nil)
    }
  }
}
