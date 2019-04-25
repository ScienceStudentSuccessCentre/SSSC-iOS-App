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
    /// This function will scroll the view controller to the top if it is an `EventsViewController`, or execute the default behaviour (dismissing the controller to reach the `EventsViewController`) otherwise.
    /// - Parameters:
    ///   - tabBarController: The tab bar controller.
    ///   - viewController: The view controller associated with the tapped tab.
    /// - Returns: Whether to select the tapped view controller or not.
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == viewControllers?[selectedIndex] {
            guard let splitVC = viewController as? UISplitViewController,
                let navController = splitVC.viewControllers.first as? UINavigationController else {
                    return true
            }
            if let eventsVC = navController.viewControllers.last as? EventsViewController {
                if !eventsVC.isScrolledToTop {
                    eventsVC.scrollToTop()
                    return false
                }
            }
            navController.popViewController(animated: true)
        }
        
        return true
    }
    
}

extension UIViewController {
    var isScrolledToTop: Bool {
        if let tableVC = self as? UITableViewController {
            return tableVC.tableView.contentOffset.y == 0
        }
        for subView in view.subviews {
            if let scrollView = subView as? UIScrollView {
                return (scrollView.contentOffset.y == 0)
            }
        }
        return true
    }
}
