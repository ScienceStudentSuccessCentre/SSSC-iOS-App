//
//  UISplitViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-05-26.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

extension UISplitViewController: UISplitViewControllerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return splitViewController?.viewControllers.first?.preferredStatusBarStyle ?? .lightContent
    }
    
    /// This is to ensure that smaller devices (like iPhones) will show the master view (this view controller) first, before any detail views.
    public func splitViewController(_ splitViewController: UISplitViewController,
                                    collapseSecondary secondaryViewController: UIViewController,
                                    onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
