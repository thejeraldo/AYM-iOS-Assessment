//
//  Restaurant.swift
//  AYMRestaurantView
//
//  Created by Jeraldo Abille on 6/28/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import Foundation

struct GeoCode: Codable {
  let location: Location?
}

struct Location: Codable {
  let entityType: String?
  let entityId: Int?
  let title: String?
  let latitude: String?
  let longitude: String?
  let cityId: Int?
  let cityName: String?
  let countryId: Int?
  let countryName: String?
}

struct RestaurantSearch: Codable {
  let restaurants: [Restaurant]?
}

struct Restaurant: Codable {
  let details: RestaurantDetails?
  
  private enum CodingKeys: String, CodingKey {
    case details = "restaurant"
  }
}

struct RestaurantDetails: Codable {
  let id: String?
  let name: String?
  let thumb: String?
  let location: RestaurantLocation?
  let cuisines: String?
  let userRating: UserRating?
}

struct RestaurantLocation: Codable {
  let city: String?
}

struct UserRating: Codable {
  let aggregateRating: String?
  let votes: String?
}


