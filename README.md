# Router
Declare Segue without storyboard. Use syntax of generic URIs.

## What is Router ?

- Centralize all your navigation.
- Use generic URIs to define your route.
- Don't loose time with crash due to missing character, use enum instead.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Router into your Xcode project using CocoaPods, it in your `Podfile`:

```ruby
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
  pod 'Router', :git => 'https://github.com/favret/Router.git', :tag => '1.0.0'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Router into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "favret/Router" => 1.0.0
```

Run `carthage update` to build the framework and drag the built `Router.framework` into your Xcode project.

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate Router into your project manually as an Embedded Framework.

## Usage

### Create your Router

```swift
public class MyRouter: Router {
 . . .
} 
```

First, you have to create a class who inherit `Router`.

### create your route

```swift
 enum Routes: String {
    case MyRoute = "route://Main/myViewController#modal"
    case SecondRoute = "route://Main/secondViewController#push"
    case ThirdRoute = "route://Main/thirdViewController#modal"
 }
```
In your class `MyRouter`, define all your route. 
You can see in the above exemple that the uri is decompose like that :
- `host`, is the name of the storyboard
- `path`, is the viewController identifier
- `fragment`, is the navigation's type of the route.

### Then use it

```swift
class SomeViewController: UIViewController {
  . . .
  MyRouter.perform(.MyRoute, sender: self)
  . . .
  MyRouter.perform(.SecondRoute)
  . . .
  MyRouter.perform(.ThirdRoute, sender: self, segueClass: MyCustomSegue.self)
}
```
As you can see, you can perform a route in many way. Basically, the `perform` methods looks like 
```swift
func perform(_ url: String, sender: AnyObject? = nil, segueClass: UIStoryboardSegue.Type)
```
- `url`, can ben an `URL`, `String` or `RouteType`
- `sender`, if you don't specify it, then the sender will be the first visible ViewController
- `segueClass`, if you don't specify it, then the segueClass will be `UIStoryboardSegue.self`


## Exemple

```swift
import Foundation
import Router

public class MyRouter: Router {
 enum Routes: String {
    case MyRoute = "route://Main/myViewController#modal"
    case SecondRoute = "route://Main/secondViewController#push"
    case ThirdRoute = "route://Main/thirdViewController#modal"
 }
 
 public func perform(route: Routes, sender: AnyObject? = nil) {
   self.perform(route.rawValue, sender: sender)
 }
}

. . .

class SomeViewController: UIViewController {

  func action() {
    MyRouter.perform(.MyRoute, sender: self)
  }
}
```
