//
//  UIViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 1/24/19.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Generates and presents a generic error alert.
    func presentGenericErrorAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Something went wrong!", message: "Please try again later. If this issue persists, please let the SSSC know!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
