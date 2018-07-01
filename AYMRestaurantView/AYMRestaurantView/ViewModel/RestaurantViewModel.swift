//
//  RestaurantViewModel.swift
//  AYMRestaurantView
//
//  Created by Jeraldo Abille on 7/1/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import Foundation

public struct RestaurantViewModel {
  var restaurant: Restaurant
  var nameText: String? {
    return restaurant.details?.name
  }
  var cityText: String? {
    return restaurant.details?.location?.city
  }
  var cuisineText: String? {
    return restaurant.details?.cuisines
  }
  var ratingsText: String? {
    return restaurant.details?.userRating?.aggregateRating
  }
  var reviewsCountText: String? {
    return "\(restaurant.details?.userRating?.votes ?? "0") Reviews"
  }
}
