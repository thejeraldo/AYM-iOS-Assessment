//
//  RestaurantTableViewCell.swift
//  AYMRestaurantView
//
//  Created by Jeraldo Abille on 7/1/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import UIKit

open class RestaurantTableViewCell: UITableViewCell {
  
  @IBOutlet public weak var thumbImageView: UIImageView? {
    didSet {
      thumbImageView?.clipsToBounds = true
      thumbImageView?.layer.cornerRadius = 4
      thumbImageView?.contentMode = .center
    }
  }
  @IBOutlet public weak var nameLabel: UILabel?
  @IBOutlet public weak var cityLabel: UILabel?
  @IBOutlet public weak var cuisineLabel: UILabel?
  @IBOutlet public weak var ratingsLabel: UILabel? {
    didSet {
      // ratingsLabel?.textColor = UIColor.gray
    }
  }
  @IBOutlet public weak var votesLabel: UILabel?
  
  public func configureWith(_ restaurantViewModel: RestaurantViewModel) {
    if let thumb = restaurantViewModel.thumbURLString {
      thumbImageView?.contentMode = .scaleAspectFill
      thumbImageView?.loadImageUsingUrlString(urlString: thumb)
    }
    nameLabel?.text = restaurantViewModel.nameText
    cityLabel?.text = restaurantViewModel.cityText
    cuisineLabel?.text = restaurantViewModel.cuisineText
    votesLabel?.text = restaurantViewModel.reviewsCountText
    ratingsLabel?.attributedText = restaurantViewModel.ratingsText
    
  }
  
  override open func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override open func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
