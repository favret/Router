//
//  File.swift
//  Router
//
//  Created by favre on 26/08/2016.
//  Copyright © 2016 favre. All rights reserved.
//

import Foundation

public enum Route: RouteType {
  case Test
  
  public var identifier: String {
    switch self {
    case .Test: return "testSegue"
    }
  }
  
  public var storyboardName: String {
    switch self {
    case .Test: return "Main"
    }
  }
  
  public var viewControllerIdentifier: String {
    switch self {
    case .Test: return "TestViewController"
    }
  }
  
  public var kindOfSegue: Router.KindOfSegue {
    switch self {
    case .Test: return .Push
    }
  }
}