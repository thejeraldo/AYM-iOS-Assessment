//
//  RestaurantsViewController.swift
//  AYM iOS Assessment
//
//  Created by Jeraldo Abille on 7/1/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import UIKit
import AYMRestaurantView

class RestaurantsViewController: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet weak var restaurantView: AYMRestaurantView! {
    didSet {
      restaurantView.zomatoAPIKey = "020541769015d08a109afa60dde2703a"
      restaurantView.delegate = self
    }
  }
  
  // MARK: - View Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    title = "Nearby Restaurants"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barTintColor = UIColor(named: "restaurants-navigation-background")
    navigationController?.navigationBar.tintColor = UIColor.white
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedStringKey.foregroundColor: UIColor.white
    ]
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    restaurantView.downloadRestaurants()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}


extension RestaurantsViewController: AYMRestaurantViewDelegate {
  func restaurantViewDidPullDownToRefresh() {
    restaurantView.downloadRestaurants()
  }
  
  func restaurantViewDidStartDownloadingData() {
    
  }
  
  func restaurantViewDidFinishDownloadingData() {
    
  }
  
  func restaurantViewDidFailDownloadDataWithError(_ error: Error) {
    
  }
}
