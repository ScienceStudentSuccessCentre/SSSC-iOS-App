//
//  TabBarViewController.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-09-25.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tell our UITabBarController subclass to handle its own delegate methods
        self.delegate = self
    }
    
    // called whenever a tab button is tapped
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController is EventNavigationController {
            print("Event tab")
        } else {
            print("Not event tab")
        }
    }
}
