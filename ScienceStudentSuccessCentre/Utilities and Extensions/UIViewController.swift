//
//  UIViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-06-11.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentGenericError() {
        let alert = UIAlertController(title: "Something went wrong!",
                                      message: "Please try again later. If this issue persists, please let the SSSC know!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    @available(iOS 13.0, *)
    func prepareStandardTitleNavigationBarAppearance(barTintColour: UIColor) {
        if let appearance = self.navigationController?.navigationBar.standardAppearance {
            appearance.backgroundColor = barTintColour
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.standardAppearance = appearance
        }
    }
    
    @available(iOS 13.0, *)
    func prepareLargeTitleNavigationBarAppearance() {
        if let appearance = self.navigationController?.navigationBar.standardAppearance {
            appearance.backgroundColor = UIColor(.steelblue)
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
}
