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
  var thumbURLString: String? {
    return restaurant.details?.thumb
  }
  var nameText: String? {
    return restaurant.details?.name
  }
  var cityText: String? {
    return restaurant.details?.location?.city
  }
  var cuisineText: String? {
    let cuisines = restaurant.details?.cuisines?.split(separator: ",")
    return cuisines?.first?.trimmingCharacters(in: .whitespaces)
  }
  var ratingsText: NSMutableAttributedString? {
    let aggregateRating = restaurant.details?.userRating?.aggregateRating ?? "0"
    let rating = Double(aggregateRating)
    let rounded = rating?.rounded()
    let ratingInt = Int(rounded!)
    let ratings = "\(rounded ?? 0) ★★★★★"
    let spaceIndex = ratings.index(of: " ")
    let index = ratings.index(spaceIndex!, offsetBy: ratingInt + 1)
    let attributedString = NSMutableAttributedString(string: ratings)
    attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray, range: (ratings.startIndex..<ratings.endIndex).nsRange)
    attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: (ratings.startIndex..<index).nsRange)
    return attributedString
  }
  var reviewsCountText: String? {
    return "\(restaurant.details?.userRating?.votes ?? "0") reviews"
  }
}
