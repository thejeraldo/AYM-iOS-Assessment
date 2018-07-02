//
//  WeatherViewController.swift
//  AYM iOS Assessment
//
//  Created by Jeraldo Abille on 6/27/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import UIKit
import CoreLocation
import AYMWeatherView

class WeatherViewController: UIViewController, AYMWeatherViewDelegate {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var restaurantsButton: UIButton! {
    didSet {
      restaurantsButton.clipsToBounds = true
      restaurantsButton.layer.cornerRadius = restaurantsButton.frame.height * 0.5
    }
  }
  @IBOutlet weak var weatherView: AYMWeatherView! {
    didSet {
      weatherView.apiKey = "a052106f5d60e7b1389d825128d90275"
      weatherView.delegate = self
    }
  }
  
  // MARK: - View Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    weatherView.downloadWeatherForCurrentLocation()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func weatherViewDidPullDownToRefresh() {
    weatherView.downloadWeatherForCurrentLocation()
  }
  
  func weatherViewDidStartDownloadingData() {
    weatherView.endRefreshing()
    SVProgressHUD.show()
  }
  
  func weatherViewDidFinishDownloadingData() {
    weatherView.endRefreshing()
    SVProgressHUD.dismiss()
  }
  
  func weatherViewDidFailDownloadDataWithError(_ error: Error) {
    weatherView.endRefreshing()
    SVProgressHUD.showError(withStatus: "Something went wrong.")
  }
  
  @IBAction func showRestaurantsVC() {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantsViewController") as! RestaurantsViewController
    navigationController?.pushViewController(vc, animated: true)
  }
}
