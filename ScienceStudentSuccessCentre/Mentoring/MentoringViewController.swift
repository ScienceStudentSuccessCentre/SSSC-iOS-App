//
//  MentoringViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-09-04.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit
import SafariServices

class MentoringViewController: UIViewController {
    @IBOutlet var bookingButton: UIButton!
    
    @IBAction func bookingButtonPressed() {
        guard let url = URL(string: "https://central.carleton.ca") else { return }
        let webpage = SSSCSafariViewController(url: url)
        present(webpage, animated: true)
    }
}
