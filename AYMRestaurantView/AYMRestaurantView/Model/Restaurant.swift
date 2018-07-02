//
//  Restaurant.swift
//  AYMRestaurantView
//
//  Created by Jeraldo Abille on 6/28/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import Foundation

public struct GeoCode: Codable {
  public let location: Location?
}

public struct Location: Codable {
  public let entityType: String?
  public let entityId: Int?
  public let title: String?
  public let latitude: String?
  public let longitude: String?
  public let cityId: Int?
  public let cityName: String?
  public let countryId: Int?
  public let countryName: String?
}

public struct RestaurantSearch: Codable {
  public let restaurants: [Restaurant]?
}

public struct Restaurant: Codable {
  public let details: RestaurantDetails?
  
  private enum CodingKeys: String, CodingKey {
    case details = "restaurant"
  }
}

public struct RestaurantDetails: Codable {
  public let id: String?
  public let name: String?
  public let thumb: String?
  public let location: RestaurantLocation?
  public let cuisines: String?
  public let userRating: UserRating?
}

public struct RestaurantLocation: Codable {
  public let city: String?
}

public struct UserRating: Codable {
  public let aggregateRating: String?
  public let votes: String?
}


