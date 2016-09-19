//
//  File.swift
//  Router
//
//  Created by favre on 26/08/2016.
//  Copyright © 2016 favre. All rights reserved.
//

import Foundation

public enum Route: RouteType {
  case test
  
  public var identifier: String {
    switch self {
    case .test: return "testSegue"
    }
  }
  
  public var storyboardName: String {
    switch self {
    case .test: return "Main"
    }
  }
  
  public var viewControllerIdentifier: String {
    switch self {
    case .test: return "TestViewController"
    }
  }
  
  public var kindOfSegue: Router.KindOfSegue {
    switch self {
    case .test: return .Push
    }
  }
}
