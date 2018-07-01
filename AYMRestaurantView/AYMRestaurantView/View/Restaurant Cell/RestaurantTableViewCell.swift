//
//  RestaurantTableViewCell.swift
//  AYMRestaurantView
//
//  Created by Jeraldo Abille on 7/1/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import UIKit

open class RestaurantTableViewCell: UITableViewCell {
  
  @IBOutlet public weak var thumbImageView: UIImageView?
  @IBOutlet public weak var nameLabel: UILabel?
  @IBOutlet public weak var ratingsLabel: UILabel?
  
  public func configureWith(_ restaurantViewModel: RestaurantViewModel) {
    nameLabel?.text = restaurantViewModel.cityText
    ratingsLabel?.text = restaurantViewModel.ratingsText
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
