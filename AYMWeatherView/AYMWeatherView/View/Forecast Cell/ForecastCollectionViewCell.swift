//
//  ForecastCollectionViewCell.swift
//  AYMWeatherView
//
//  Created by Jeraldo Abille on 6/28/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import UIKit

internal class ForecastCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var maxTempLabel: UILabel!
  @IBOutlet weak var minTempLabel: UILabel!
  @IBOutlet weak var conditionImageView: UIImageView!
  
  internal func configureWith(_ forecastViewModel: DailyForecastViewModel) {
    dayLabel.text = forecastViewModel.dayText
    conditionImageView.image = forecastViewModel.conditionImage
    maxTempLabel.text = forecastViewModel.maxTempString
    minTempLabel.text = forecastViewModel.minTempString
  }
}
