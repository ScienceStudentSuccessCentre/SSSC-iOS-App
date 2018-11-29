//
//  TabBarViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-09-25.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var previousController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if previousController == viewController || previousController == nil {
            if let navigationController = viewController as? UINavigationController {
                if let eventViewController = navigationController.viewControllers.first as? EventsViewController {
                    if eventViewController.isViewLoaded && eventViewController.view.window != nil {
                        eventViewController.scrollToTop()
                    }
                }
            }
        }
        previousController = viewController
    }
    
}
