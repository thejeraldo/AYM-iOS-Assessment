//
//  Extensions.swift
//  Common
//
//  Created by Jeraldo Abille on 7/1/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import Foundation

let imageCache = NSCache<AnyObject, AnyObject>()

public extension UIImageView {
  func loadImageUsingUrlString(urlString: String) {
    image = nil
    if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
      self.image = imageFromCache
      return
    }
    
    URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, _, error) in
      guard error == nil else {
        print("Error downloading image. \(error!)")
        return
      }
      
      DispatchQueue.main.async {
        let imageToCache = UIImage(data: data!)
        imageCache.setObject(imageCache, forKey: urlString as AnyObject)
        self.image = imageToCache
      }
    }.resume()
  }
}

public extension Array {
  public func chunks(_ chunkSize: Int) -> [[Element]] {
    return stride(from: 0, to: self.count, by: chunkSize).map {
      Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
    }
  }
}

public extension String {
  public func capitalizingFirstLetter() -> String {
    return prefix(1).uppercased() + dropFirst()
  }
  
  public mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
}

public extension UIAlertController {
  public func presentInOwnWindow(animated: Bool, completion: (() -> Void)?) {
    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    alertWindow.windowLevel = UIWindowLevelAlert + 1;
    alertWindow.makeKeyAndVisible()
    alertWindow.rootViewController?.present(self, animated: animated, completion: completion)
  }
}
