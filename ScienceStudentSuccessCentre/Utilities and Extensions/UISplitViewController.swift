//
//  UISplitViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-05-26.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

extension UISplitViewController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return splitViewController?.viewControllers.first?.preferredStatusBarStyle ?? .lightContent
    }
}
