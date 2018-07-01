//
//  AYMRestaurantView.swift
//  AYMRestaurantView
//
//  Created by Jeraldo Abille on 7/1/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import UIKit
import CoreLocation
import Common

open class AYMRestaurantView: UIView {
  
  // MARK: - Public Properties
  
  public var zomatoAPIKey: String
  public var restaurants = [Restaurant]()
  
  @IBOutlet public weak var tableView: UITableView? {
    didSet {
      tableView?.dataSource = self
      tableView?.delegate = self
    }
  }
  
  // MARK: - Private Properties
  private lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.delegate = self
    return locationManager
  }()
  fileprivate var contentView: UIView?
  
  public init(zomatoAPIKey: String) {
    self.zomatoAPIKey = zomatoAPIKey
    super.init(frame: CGRect.zero)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    self.zomatoAPIKey = ""
    super.init(coder: aDecoder)
    
    guard let view = loadViewFromNib() else {
      return
    }
    view.frame = bounds
    addSubview(view)
    contentView = view
  
    let cellNib = UINib(nibName: "RestaurantTableViewCell", bundle: Bundle(for: RestaurantTableViewCell.self))
    tableView?.register(cellNib, forCellReuseIdentifier: "restaurantCell")
  }
  
  open func downloadRestaurants() {
    let status = CLLocationManager.authorizationStatus()
    if status == .notDetermined {
      locationManager.requestAlwaysAuthorization()
    }
    if status == .denied || status == .restricted {
      showAppSettingsAlert()
    }
    if status == .authorizedWhenInUse || status == .authorizedAlways {
      locationManager.startUpdatingLocation()
    }
    if CLLocationManager.locationServicesEnabled() == false {
      showEnableLocationServiceAlert()
    }
  }
  
  private func loadViewFromNib() -> UIView? {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "AYMRestaurantView", bundle: bundle)
    return nib.instantiate(withOwner: self, options: nil).first as? UIView
  }
}

extension AYMRestaurantView: UITableViewDataSource, UITableViewDelegate {
  public func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return restaurants.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! RestaurantTableViewCell
    let restaurant = restaurants[indexPath.row] as Restaurant
    let restaurantViewModel = RestaurantViewModel(restaurant: restaurant)
    cell.configureWith(restaurantViewModel)
    return cell
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 136
  }
}

// MARK: - Requests

extension AYMRestaurantView {
  
  public typealias restaurantsCompletion = (_ error: Error?) -> ()
  
  public func downloadRestaurants(coord: CLLocationCoordinate2D, completion: @escaping restaurantsCompletion) {
    assert(zomatoAPIKey.isEmpty == false, "Please provide an API key.")
    
    let api = RestaurantAPI()
    api.geocode(apiKey: zomatoAPIKey, coord: coord) { (geocode, error) in
      guard error == nil else {
        print("Error geocoding. \(error!)")
        completion(error!)
        return
      }
      
      if let _ = geocode {
        let entityId = "\(geocode!.location?.entityId ?? 0)"
        let entityType = geocode?.location?.entityType ?? ""
        api.search(apiKey: self.zomatoAPIKey, coord: coord, entityId: entityId, entityType: entityType, completion: { (searchResults, error) in
          guard error == nil else {
            print("Error searching restaurants. \(error!)")
            completion(error!)
            return
          }
          
          if let topRestaurants = searchResults?.restaurants {
            self.restaurants = topRestaurants
            self.tableView?.reloadData()
          }
          
          completion(nil)
        })
      }
    }
  }
}

// MARK: - CLLocationManagerDelegate

extension AYMRestaurantView: CLLocationManagerDelegate {
  public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    print("location manager did change authorization status.")
  }
  
  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("location manager did fail with error \(error).")
  }
  
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("location manager did update locations.")
    let location = locations.last
    let timestamp = location?.timestamp
    let cachedBefore = timestamp?.timeIntervalSinceNow
    if fabs(cachedBefore!) < 60.0 {
      let coord = location?.coordinate
      manager.stopUpdatingLocation()
      let geocoder = CLGeocoder()
      geocoder.reverseGeocodeLocation(location!) { (placemarks, error) in
        guard error == nil else {
          print("Reverse geocoding location error. \(error!)")
          return
        }
        if let placemark = placemarks?.last {
          self.downloadRestaurants(coord: coord!, completion: { (error) in
            guard error == nil else {
              // call delegate
              return
            }
            // call delegate
          })
        }
      }
    }
  }
}

extension AYMRestaurantView {
  private func showEnableLocationServiceAlert() {
    let alert = UIAlertController(title: "Turn on Location Services for your iPhone", message: "1. Open the Settings app\n2. Select Privacy\n 3. Select Loation Services\n 4. Turn on Location Services", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
      
    }))
    alert.presentInOwnWindow(animated: true, completion: nil)
  }
  
  private func showAppSettingsAlert() {
    let alert = UIAlertController(title: "Turn on your location settings to continue", message: "1. Select Location\n2. Tap on Always or While Using", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Go To Settings", style: .default, handler: { action in
      
      let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)!
      UIApplication.shared.open(settingsUrl)
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
      
    }))
    alert.presentInOwnWindow(animated: true, completion: nil)
  }
}
