//
//  WeatherViewController.swift
//  AYM iOS Assessment
//
//  Created by Jeraldo Abille on 6/27/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import UIKit
import AYMWeatherView

class WeatherViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var weatherView: AYMWeatherView! {
    didSet {
      weatherView.apiKey = ""
      weatherView.units = .celsius
    }
  }
  
  // MARK: - View Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
