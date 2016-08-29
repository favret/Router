//
//  ViewController.swift
//  Router
//
//  Created by favre on 23/08/2016.
//  Copyright © 2016 favre. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    print(segue.identifier)
  }
  
  @IBAction func buttonAction(sender:AnyObject?) {
    let router = Router()
    let url = NSURL(string: "route://Main/TestViewController#push")
    router.perform(url!)
    
    //router.perform(url!, sender: self)
    //router.perform("route://Main/TestViewController#push")
    //router.perform("route://Main/TestViewController#push", sender: self)
    //router.perform("route://Main/TestViewController#custom", sender: self, segueClass: CustomSegue.self)
    //router.perform(Route.Test, sender: self)
    //router.perform(Route.Test)
  }
  
}

