//
//  NetworkClient.swift
//  AYMCommerce iOS Assessment
//
//  Created by Jeraldo Abille on 6/27/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
  case GET    = "GET"
  case POST   = "POST"
  case PUT    = "PUT"
  case PATCH  = "PATCH"
  case DELETE = "DELETE"
}

public struct NetworkClient {
  static func fetch<T: Codable>(url: URL, method: HTTPMethod, parameters: [String: String]?, headers: [String: String]?, responseType: T.Type, completion: @escaping (_ t: T?, _ error: Error?) -> ()) {
    var urlComponents = URLComponents(string: url.absoluteString)
    var queryItems = [URLQueryItem]()
    if let _ = parameters {
      for (key, value) in parameters! {
        let queryItem = URLQueryItem(name: key, value: value)
        queryItems.append(queryItem)
      }
    }
    urlComponents?.queryItems = queryItems
    
    guard let url = urlComponents?.url else {
      // Invalid url error.
      let error = NSError(domain: "", code: 405, userInfo: [NSLocalizedDescriptionKey: "Invalid url."])
      print("Network client error: \(error)")
      DispatchQueue.main.async {
        completion(nil, error as Error)
      }
      return
    }
    
    var urlRequest = URLRequest(url: url)
    if let _ = headers {
      for (key, value) in headers! {
        urlRequest.addValue(value, forHTTPHeaderField: key)
      }
    }
    let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      guard error == nil else {
        print("Network client error: \(error!)")
        DispatchQueue.main.async {
          completion(nil, error!)
        }
        return
      }
      
      guard let data = data else {
        print("Received nil data.")
        DispatchQueue.main.async {
          completion(nil, nil)
        }
        return
      }
      
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .secondsSince1970
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let result = try? decoder.decode(responseType.self, from: data)
      DispatchQueue.main.async {
        completion(result, nil)
      }
    }
    dataTask.resume()
  }
}
















