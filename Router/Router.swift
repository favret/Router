//
//  Router.swift
//  Router
//
//  Created by favre on 23/08/2016.
//  Copyright © 2016 favre. All rights reserved.
//

import UIKit

/**
 The protocol to which all Route classes implicitly conform.

 Use this protocol to define all your route (e.g. UIStoryboardSegue).
 RouteType replace your UIStoryboardSegue declaration in storyboard but you can use both if you want to.

 *UIStoryboardSegue definition*

 A UIStoryboardSegue object is responsible for performing the visual transition between two view controllers. In addition, segue objects are used to prepare for the transition from one view controller to another. Segue objects contain information about the view controllers involved in a transition. When a segue is triggered, but before the visual transition occurs, the storyboard runtime calls the current view controller’s prepareForSegue:sender: method so that it can pass any needed data to the view controller that is about to be displayed.
 */
public protocol RouteType {

  /**
   UIStoryboardSegue's identifier.
   */
  var identifier: String { get }

  /**
   name of the Storyboard file who contains UIViewController destination.
   */
  var storyboardName: String { get }

  /**
   determine the kind of the segue. Can be Push, Modal or Custom.be
   If it's Custom, you have to create a Custom UIStoryboardSegue class and give it Class to Router.perform method.
   */
  var kindOfSegue: Router.KindOfSegue { get }

  /**
   the destination ViewController's identifier.
   */
  var viewControllerIdentifier: String { get }
}

extension RouteType {

  /**
   convert the current RouteType to an NSURL who respect generic URIs. (exemple: Router://Main/viewControllerIdentifier#push)
   */
  var url:NSURL {
    return (NSURLComponents.init(string: "route://\(self.storyboardName)/\(self.viewControllerIdentifier)#\(self.kindOfSegue.rawValue)")?.URL)!
  }
}

extension UIWindow {

  func visibleViewController() -> UIViewController? {
    if let rootViewController: UIViewController  = self.rootViewController {
      return UIWindow.getVisibleViewControllerFrom(rootViewController)
    }
    return nil
  }

  class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {

    if vc.isKindOfClass(UINavigationController.self) {

      let navigationController = vc as! UINavigationController
      return UIWindow.getVisibleViewControllerFrom( navigationController.visibleViewController!)

    } else if vc.isKindOfClass(UITabBarController.self) {

      let tabBarController = vc as! UITabBarController
      return UIWindow.getVisibleViewControllerFrom(tabBarController.selectedViewController!)

    } else {

      if let presentedViewController = vc.presentedViewController {

        return UIWindow.getVisibleViewControllerFrom(presentedViewController.presentedViewController!)

      } else {

        return vc;
      }
    }
  }
}

public class Router {

  /**
   */
  public enum KindOfSegue: String {
    case Push = "push"
    case Modal = "modal"
    case Custom = "custom"
  }

  public init() {

  }

  //Router://preparation/preparationDetailsViewController#push

  // MARK: - perform with URL

  /**
   Initiates the segue with the specified identifier from the current view controller's storyboard file.
   All mandatory information used to initiates the segue can be found on the URI String.

   the URI String syntax is generic URIs. The syntax of generic URIs and absolute URI references was first defined in Request for Comments (RFC) 2396, published in August 1998,[3] and finalized in RFC 3986, published in January 2005.

   exemple : Router://Main/viewControllerIdentifier#push

   - parameter urlString: the URI String. Its syntax is generic URIs. (exemple: Router://Main/viewControllerIdentifier#push)

   - parameter sender: The object that you want to use to initiate the segue. If nil then the source of Segue if the top visible UIViewController.
   */
  public func perform(urlString: String, sender: AnyObject? = nil) {
    guard let url = NSURL(string: urlString)
      else { return }

    self.perform(url, sender: sender, segueClass: UIStoryboardSegue.self)
  }

  /**
   Initiates the segue with the specified identifier from the current view controller's storyboard file.
   All mandatory information used to initiates the segue can be found on the URI String.

   the URI String syntax is generic URIs. The syntax of generic URIs and absolute URI references was first defined in Request for Comments (RFC) 2396, published in August 1998,[3] and finalized in RFC 3986, published in January 2005.

   exemple : Router://Main/viewControllerIdentifier#push

   - parameter urlString: the URI String. Its syntax is generic URIs. (exemple: Router://Main/viewControllerIdentifier#push)

   - parameter sender: The object that you want to use to initiate the segue. If nil then the source of Segue if the top visible UIViewController.

   - parameter segueClass: the UIStoryboardSegue than you want to use to perform the Segue
   */
  public func perform(urlString: String, sender: AnyObject? = nil, segueClass: UIStoryboardSegue.Type) {
    guard let url = NSURL(string: urlString)
      else { return }

    self.perform(url, sender: sender, segueClass: segueClass)
  }


  /**
   Initiates the segue with the specified identifier from the current view controller's storyboard file.
   All mandatory information used to initiates the segue can be found on the NSURL parameter.

   the NSURL parameter syntax is generic URIs. The syntax of generic URIs and absolute URI references was first defined in Request for Comments (RFC) 2396, published in August 1998,[3] and finalized in RFC 3986, published in January 2005.

   exemple : Router://Main/viewControllerIdentifier#push

   - parameter url: NSURL who define the Segue. Its syntax is generic URIs. (exemple: Router://Main/viewControllerIdentifier#push)

   - parameter sender: The object that you want to use to initiate the segue. If nil then the source of Segue if the top visible UIViewController.
   */
  public func perform(url:NSURL, sender: AnyObject? = nil) {
    self.perform(url, sender: sender, segueClass: UIStoryboardSegue.self)
  }

  /**
   Initiates the segue with the specified identifier from the current view controller's storyboard file.
   All mandatory information used to initiates the segue can be found on the NSURL parameter.

   the NSURL parameter syntax is generic URIs. The syntax of generic URIs and absolute URI references was first defined in Request for Comments (RFC) 2396, published in August 1998,[3] and finalized in RFC 3986, published in January 2005.

   exemple : Router://Main/viewControllerIdentifier#push

   - parameter url: NSURL who define the Segue. Its syntax is generic URIs. (exemple: Router://Main/viewControllerIdentifier#push)

   - parameter sender: The object that you want to use to initiate the segue. If nil then the source of Segue if the top visible UIViewController.

   - parameter segueClass: the UIStoryboardSegue than you want to use to perform the Segue
   */
  public func perform(url:NSURL, sender: AnyObject? = nil, segueClass: UIStoryboardSegue.Type) {
    guard
      let host = url.host,
      let path = url.path?.stringByReplacingOccurrencesOfString("/", withString: ""),
      let fragment = url.fragment?.lowercaseString,
      let identifier = url.absoluteString
      else { return }

    self.perform(segueIdentifier: identifier, storyboardName:host, viewControllerIdentifier:path, sender:sender, kindOfSegue: KindOfSegue(rawValue:fragment)!, segueClass:segueClass)
  }

  // MARK: - perform with route

  /**
   Initiates the segue with the specified identifier from the current view controller's storyboard file.
   All mandatory information used to initiates the segue can be found on the RouteType parameter.

   - parameter route: RouteType who define the Segue.

   - parameter sender: The object that you want to use to initiate the segue. If nil then the source of Segue if the top visible UIViewController.
   */
  public func perform(route:RouteType, sender: AnyObject? = nil) {
    self.perform(route, sender: sender, segueClass: UIStoryboardSegue.self)
  }

  /**
   Initiates the segue with the specified identifier from the current view controller's storyboard file.
   All mandatory information used to initiates the segue can be found on the RouteType parameter.

   - parameter route: RouteType who define the Segue.

   - parameter sender: The object that you want to use to initiate the segue. If nil then the source of Segue if the top visible UIViewController.

   - parameter segueClass: the UIStoryboardSegue than you want to use to perform the Segue
   */
  public func perform(route:RouteType, sender: AnyObject? = nil, segueClass: UIStoryboardSegue.Type) {
    self.perform(segueIdentifier:route.identifier, storyboardName:route.storyboardName, viewControllerIdentifier:route.viewControllerIdentifier, sender:sender, kindOfSegue: route.kindOfSegue, segueClass:segueClass)
  }

  // MARK: - Base

  /**
   Determine the viewController that will be used for perform the Segue. It can be the sender or the top visible viewController.

   - parameter sender: The object that you want to use to initiate the segue.

   - returns: the founded UIViewController. if nil then no UIViewController is available and the Segue will not be performed.
   */
  private func getSourceViewController(sender:AnyObject?) -> UIViewController? {
    if let sender = sender as? UIViewController {
      return sender
    }

    guard
      let appDelegate = UIApplication.sharedApplication().delegate! as? UIApplicationDelegate,
      let window = appDelegate.window
      else { return nil }

    return window?.visibleViewController()
  }

  /**
   instantiate a UIStoryboardSegue that will be performed.

   - parameter identifier: The identifier you want to associate with this particular instance of the segue. You can use this identifier to differentiate one type of segue from another at runtime.

   - parameter source: The view controller visible at the start of the segue.

   - parameter destination: The view controller to display after the completion of the segue.

   - parameter kindOfSegue: The kind of animation used by the instantiate Segue.

   - parameter segueClass: The UIStoryboardSegue.Type of the instantiate Segue.

   - returns: instance of UIStoryboardSegue.Type.
   */
  private func createSegue(identifier identifier: String, source: UIViewController, destination: UIViewController, kindOfSegue:KindOfSegue, segueClass: UIStoryboardSegue.Type) -> UIStoryboardSegue{

    if  segueClass == UIStoryboardSegue.self {
      return segueClass.init(identifier: identifier, source: source, destination: destination, performHandler: {
        switch kindOfSegue {
        case .Push:
          source.navigationController?.pushViewController(destination, animated: true)
        case .Modal:
          source.presentViewController(destination, animated: true, completion: nil)

        default:()
        }
      })
    }

    return segueClass.init(identifier: identifier, source: source, destination: destination)
  }

  /**
   Base of all perform methods. Create a Segue of type segueClass parameter and perform it.

   - parameter segueIdentifier: The identifier you want to associate with this particular instance of the segue. You can use this identifier to differentiate one type of segue from another at runtime.

   - parameter storyboardName: The name of the storyboard that contain the destination ViewController.

   - parameter viewControllerIdentifier: the destination ViewController's identifier.

   - parameter kindOfSegue: The kind of animation used by the instantiate Segue.

   - parameter segueClass: The UIStoryboardSegue.Type of the instantiate Segue.
   */
  public func perform(segueIdentifier segueIdentifier:String, storyboardName:String, viewControllerIdentifier:String, sender: AnyObject?, kindOfSegue:KindOfSegue, segueClass: UIStoryboardSegue.Type) {

    guard let source = self.getSourceViewController(sender)
      else { return }

    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    let destination = storyboard.instantiateViewControllerWithIdentifier(viewControllerIdentifier)

    let segue = self.createSegue(identifier: segueIdentifier, source: source, destination: destination, kindOfSegue: kindOfSegue, segueClass: segueClass)

    source.prepareForSegue(segue, sender: source)
    segue.perform()
  }

}
