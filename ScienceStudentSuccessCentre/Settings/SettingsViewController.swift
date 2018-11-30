//
//  SettingsViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-30.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController, EurekaFormProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createForm()
    }
    
    func createForm() {
        form
            +++ Section(header: "Settings", footer: "If toggled on, courses without a Final Grade specified will be included in CGPA calculations on the CGPA Calculator page.")
            <<< SwitchRow() { row in
                row.title = "Include In-Progress Courses"
            }.onChange { _ in
                self.validateForm()
            }
            +++ Section(header: "Credits", footer: "- Created by Avery Vine")
    }
    
    func validateForm() {
        
    }

}
