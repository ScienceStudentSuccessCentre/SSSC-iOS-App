//
//  PlannerViewController.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-09-27.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import Eureka

class PlannerViewController: FormViewController, EurekaFormProtocol {
    
    var currentGpa: Double!
    let creditFormatter = NumberFormatter()
    let gpaFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creditFormatter.numberStyle = .decimal
        creditFormatter.maximumFractionDigits = 1
        creditFormatter.minimumFractionDigits = 1
        gpaFormatter.numberStyle = .decimal
        gpaFormatter.maximumFractionDigits = 1
        gpaFormatter.minimumFractionDigits = 1
        
        createForm()
    }
    
    func createForm() {
        form
            +++ Section(footer: "If you want to achieve a certain overall CGPA, you can use this section to determine what CGPA you should aim for the current term.")
            +++ Section("CGPA Required to Reach Desired CGPA")
            <<< DecimalRow() { row in
                row.tag = "currentGpa"
                row.title = "Current CGPA"
                row.placeholder = "4.9"
                row.formatter = gpaFormatter
                }.onChange { _ in
                    self.validateForm()
                }
            <<< DecimalRow() { row in
                row.tag = "creditsComplete"
                row.title = "Credits Complete"
                row.placeholder = "5.0"
                row.formatter = creditFormatter
                }.onChange { _ in
                    self.validateForm()
                }
            <<< DecimalRow() { row in
                row.tag = "desiredGpa"
                row.title = "Desired CGPA"
                row.placeholder = "6.0"
                row.formatter = creditFormatter
                }.onChange {_ in
                    self.validateForm()
                }
            <<< DecimalRow() { row in
                row.tag = "creditsInProgress"
                row.title = "Credits in Progress"
                row.placeholder = "2.5"
                row.formatter = creditFormatter
                }.onChange {_ in
                    self.validateForm()
                }
            +++ Section("Minimum CGPA Required for Current Courses")
            <<< DecimalRow() { row in
                row.tag = "requiredGpa"
                row.title = "CGPA"
                row.placeholder = "Enter Info Above"
                row.formatter = gpaFormatter
                row.baseCell.isUserInteractionEnabled = false
                }
    }
    
    func validateForm() {
        let values = form.values()
        let currentGpa = values["currentGpa"] as? Double ?? -1
        let creditsComplete = values["creditsComplete"] as? Double ?? -1
        let desiredGpa = values["desiredGpa"] as? Double ?? -1
        let creditsInProgress = values["creditsInProgress"] as? Double ?? -1
        let calculatedGpaRow = form.rowBy(tag: "requiredGpa")
        
        if currentGpa >= 0 && creditsComplete >= 0 && desiredGpa >= 0 && creditsInProgress > 0 {
            calculatedGpaRow?.baseValue = Grading.calculateRequiredGpa(currentGpa: currentGpa, creditsComplete: creditsComplete, desiredGpa: desiredGpa, creditsInProgress: creditsInProgress)
        } else {
            calculatedGpaRow?.baseValue = nil
        }
        calculatedGpaRow?.updateCell()
    }

}
