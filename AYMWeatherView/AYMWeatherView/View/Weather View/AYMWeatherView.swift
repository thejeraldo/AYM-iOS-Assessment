//
//  AYMWeatherView.swift
//  AYMWeatherView
//
//  Created by Jeraldo Abille on 6/27/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import UIKit
import CoreLocation

public protocol AYMWeatherViewDelegate: class {
  // Required
  func weatherViewDidStartDownloadingData()
  func weatherViewDidFinishDownloadingData()
  func weatherViewDidFailDownloadDataWithError(_ error: Error)
  // Optional
  func weatherViewDidPullDownToRefresh()
  func weatherViewDidSelectDailyForecast(_ forecast: DailyForecast, at indexPath: IndexPath)
}

public extension AYMWeatherViewDelegate {
  func weatherViewDidPullDownToRefresh() {
    
  }

  func weatherViewDidSelectDailyForecast(_ forecast: DailyForecast, at indexPath: IndexPath) {
    
  }
}

open class AYMWeatherView: UIView {
  
  // MARK: - Public Properties
  
  open var apiKey: String
  open var city: String?
  public var fiveDayForecast = [DailyForecast]()
  public weak var delegate: AYMWeatherViewDelegate?
  
  @IBOutlet public weak var cityLabel: UILabel!
  @IBOutlet public weak var dayLabel: UILabel!
  @IBOutlet public weak var descriptionLabel: UILabel!
  @IBOutlet public weak var conditionImageView: UIImageView!
  @IBOutlet public weak var temperatureLabel: UILabel!
  @IBOutlet public weak var unitsLabel: UILabel!
  @IBOutlet public weak var humidityLabel: UILabel!
  @IBOutlet public weak var pressureLabel: UILabel!
  @IBOutlet public weak var windLabel: UILabel!
  
  // MARK: - Private Properties
  var weatherViewModel: WeatherViewModel?
  private lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.delegate = self
    return locationManager
  }()
  
  @IBOutlet private weak var tableView: UITableView! {
    didSet {
      self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
      tableView.dataSource = self
      tableView.delegate = self
      tableView.showsVerticalScrollIndicator = false
      tableView.separatorStyle = .none
      tableView.allowsSelection = false
      tableView.tableHeaderView = UIView()
      tableView.tableFooterView = UIView()
      // Refresh Control
      let refreshControl = UIRefreshControl()
      let attribs: [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10, weight: .regular),
        NSAttributedStringKey.foregroundColor: UIColor.gray
      ]
      refreshControl.attributedTitle = NSAttributedString(string: "↓ Pull Down To Refresh", attributes: attribs)
      refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
      tableView.refreshControl = refreshControl
    }
  }
  @IBOutlet private weak var forecastCollectionView: UICollectionView! {
    didSet {
      let bundle = Bundle(for: type(of: self))
      let collectionViewNib = UINib(nibName: "ForecastCollectionViewCell", bundle: bundle)
      self.forecastCollectionView.register(collectionViewNib, forCellWithReuseIdentifier: "forecastCell")
      
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.itemSize = CGSize(width: 75, height: 154)
      layout.sectionInset = UIEdgeInsets.zero
      layout.minimumInteritemSpacing = 0
      layout.minimumLineSpacing = 0
      self.forecastCollectionView.setCollectionViewLayout(layout, animated: false)
      self.forecastCollectionView.dataSource = self
    }
  }
  @IBOutlet private weak var weatherViewContainer: UIView!
  fileprivate var contentView: UIView?
  
  // MARK: - Initialization
  
  /// Initialize WeatherView with an OpenWeatherMap API Key.
  public init(apiKey: String) {
    self.apiKey = apiKey
    super.init(frame: CGRect.zero)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    self.apiKey = ""
    super.init(coder: aDecoder)
    
    guard let view = loadViewFromNib() else {
      return
    }
    view.frame = bounds
    addSubview(view)
    contentView = view
    
    setDefaultValues()
  }
  
  /// Requests for the user's location.
  /// Will download weather from the API after getting the user's coordinates.
  open func downloadWeatherForCurrentLocation() {
    self.delegate?.weatherViewDidStartDownloadingData()
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
  
  /// Tells the delegate that the user pulled down to refresh.
  @objc open func refresh() {
    self.delegate?.weatherViewDidPullDownToRefresh()
  }
  
  /// Ends refreshing.
  open func endRefreshing() {
    self.tableView.refreshControl?.endRefreshing()
  }
  
  // MARK: - Private Methods
  
  private func loadViewFromNib() -> UIView? {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "AYMWeatherView", bundle: bundle)
    return nib.instantiate(withOwner: self, options: nil).first as? UIView
  }
  
  private func setDefaultValues() {
    cityLabel.text = ""
    dayLabel.text = ""
    descriptionLabel.text = ""
    conditionImageView.image = nil
    temperatureLabel.text = "--"
    unitsLabel.text = "°C"
    humidityLabel.text = "--"
    pressureLabel.text = "--"
    windLabel.text = "--"
    fiveDayForecast = [DailyForecast]()
    forecastCollectionView.reloadData()
  }
  
  private func updateUI() {
    cityLabel.text = city
    dayLabel.text = weatherViewModel?.dayText
    descriptionLabel.text = weatherViewModel?.descriptionText
    conditionImageView.image = weatherViewModel?.conditionImage
    temperatureLabel.text = weatherViewModel?.temperatureText
    unitsLabel.text = weatherViewModel?.temperatureUnitText
    humidityLabel.text = weatherViewModel?.humidityText
    pressureLabel.text = weatherViewModel?.pressureText
    windLabel.text = weatherViewModel?.windText
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension AYMWeatherView: UITableViewDataSource, UITableViewDelegate {
  public func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.contentView.addSubview(weatherViewContainer)
    weatherViewContainer.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
    weatherViewContainer.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
    weatherViewContainer.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
    weatherViewContainer.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
    weatherViewContainer.layoutIfNeeded()
    cell.backgroundColor = weatherViewContainer.backgroundColor
    return cell
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.frame.height
  }
  
  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(Float.leastNormalMagnitude)
  }
}

// MARK: - UICollectionViewDataSource

extension AYMWeatherView: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return fiveDayForecast.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as! ForecastCollectionViewCell
    let forecast = fiveDayForecast[indexPath.row]
    let forecastViewModel = DailyForecastViewModel(forecast)
    cell.configureWith(forecastViewModel)
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension AYMWeatherView: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let forecast = fiveDayForecast[indexPath.row]
    self.delegate?.weatherViewDidSelectDailyForecast(forecast, at: indexPath)
  }
}

// MARK: - Location

extension AYMWeatherView: CLLocationManagerDelegate {
  public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    print("location manager did change authorization status.")
  }
  
  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("location manager did fail with error \(error).")
    self.endRefreshing()
    self.delegate?.weatherViewDidFailDownloadDataWithError(error)
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
          self.city = placemark.locality
          self.downloadWeather(coord: coord!, completion: { (error) in
            self.endRefreshing()
            guard error == nil else {
              self.delegate?.weatherViewDidFailDownloadDataWithError(error!)
              return
            }
            self.delegate?.weatherViewDidFinishDownloadingData()
          })
        }
      }
    }
  }
}

// MARK: - Requests

extension AYMWeatherView {
  
  public typealias weatherCompletion = (_ error: Error?) -> ()
  
  
  /// Download weather and forecast from OpenWeatherMap API.
  ///
  /// - Parameters:
  ///   - coord: The coordinates in CLLocationCoordinate2D
  ///   - completion: Completion block that returns an error if download fails.
  public func downloadWeather(coord: CLLocationCoordinate2D, completion: @escaping weatherCompletion) {
    assert(apiKey.isEmpty == false, "Please provide an API key.")
    
    let api = WeatherAPI()
    api.getWeather(apiKey: apiKey, coordinates: coord) { (weather, error) in
      guard error == nil else {
        print("Error downloading weather. \(error!)")
        completion(error!)
        return
      }
      
      if let _ = weather {
        self.weatherViewModel = WeatherViewModel(weather!)
        self.updateUI()
      }
      
      api.getForecast(apiKey: self.apiKey, coordinates: coord, completion: { (forecast, error) in
        guard error == nil else {
          print("Error downloading forecast. \(error!)")
          completion(error!)
          return
        }
        
        if let dailyForecast = forecast?.fiveDayForecast() {
          self.fiveDayForecast = dailyForecast
          self.forecastCollectionView.reloadData()
        }
        
        self.endRefreshing()
        completion(nil)
      })
    }
  }
}

extension AYMWeatherView {
  private func showEnableLocationServiceAlert() {
    let alert = UIAlertController(title: "Turn on Location Services for your iPhone", message: "1. Open the Settings app\n2. Select Privacy\n 3. Select Loation Services\n 4. Turn on Location Services", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
      self.endRefreshing()
    }))
    alert.presentInOwnWindow(animated: true, completion: nil)
  }
  
  private func showAppSettingsAlert() {
    let alert = UIAlertController(title: "Turn on your location settings to continue", message: "1. Select Location\n2. Tap on Always or While Using", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Go To Settings", style: .default, handler: { action in
      self.endRefreshing()
      let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)!
      UIApplication.shared.open(settingsUrl)
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
      self.endRefreshing()
    }))
    alert.presentInOwnWindow(animated: true, completion: nil)
  }
}
