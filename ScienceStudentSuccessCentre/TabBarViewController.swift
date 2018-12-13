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
    
    /// Overrides tapping the tab bar icons to run custom behaviour.
    ///
    /// This function will determine if the tapped tab bar is that of the `EventsViewController`. If so, and that view controller is the one already visible, it will be scrolled to the top.
    /// - Parameters:
    ///   - tabBarController: The tab bar controller
    ///   - viewController: The view controller associated with the tapped tab
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
