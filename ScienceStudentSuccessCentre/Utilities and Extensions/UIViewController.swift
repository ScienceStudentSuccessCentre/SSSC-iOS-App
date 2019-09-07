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
    
    func prepareNavigationBarAppearance(barTintColour: UIColor = UIColor(.steelblue)) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = barTintColour
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = barTintColour
        }
        navigationController?.view.backgroundColor = UIColor(.lightgrey)
    }
}
