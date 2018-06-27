//
//  EndPointProtocol.swift
//  AYMCommerce iOS Assessment
//
//  Created by Jeraldo Abille on 6/27/18.
//  Copyright © 2018 thejeraldo. All rights reserved.
//

import Foundation

protocol EndPointProtocol {
  var baseURL: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
}
