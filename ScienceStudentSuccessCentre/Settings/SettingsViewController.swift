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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        let defaults = UserDefaults.standard
        let includeInProgressCourses = defaults.bool(forKey: "includeInProgressCourses")
        form.rowBy(tag: "includeInProgressCourses")?.baseValue = includeInProgressCourses
    }
    
    func createForm() {
        form
            +++ Section(header: "Settings - CGPA Calculator", footer: "If toggled on, courses without a Final Grade specified will be included in CGPA calculations on the CGPA Calculator page.")
            <<< SwitchRow() { row in
                row.tag = "includeInProgressCourses"
                row.title = "Include Courses in Progress"
            }.onChange { _ in
                self.validateForm()
            }
            +++ Section(header: "\nAcknowledgments", footer: "This app was developed for the Carleton University Science Student Success Centre by Avery Vine. Special thanks to Kshamina Ghelani, Selasi Kudolo, Gina Bak, Anisha Ghelani, Lily Visanuvimol, Divin Kang, and everyone else at the SSSC who helped out along the way.\n\nReleased under MIT License | Copyright @ 2018")
    }
    
    func validateForm() {
        if let includeInProgressCourses = form.rowBy(tag: "includeInProgressCourses")?.baseValue as? Bool {
            let defaults = UserDefaults.standard
            defaults.set(includeInProgressCourses, forKey: "includeInProgressCourses")
        }
    }

}
