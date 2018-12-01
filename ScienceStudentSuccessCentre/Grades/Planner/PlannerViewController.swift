//
//  PlannerViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-09-27.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import Eureka

class PlannerViewController: FormViewController, EurekaFormProtocol {
    
    private var currentGpa: Double!
    private let formatter = NumberFormatter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        
        createForm()
    }
    
    func createForm() {
        form
            +++ Section(footer: "If you want to achieve a certain overall CGPA, you can use this section to determine what CGPA you should aim for the current term.")
            +++ Section("Term CGPA for desired overall CGPA")
            <<< DecimalRow() { row in
                row.tag = "currentGpa_form1"
                row.title = "Current CGPA"
                row.placeholder = "8.9"
                row.formatter = formatter
            }.onChange { _ in
                self.validateForm()
            }
            <<< DecimalRow() { row in
                row.tag = "creditsComplete_form1"
                row.title = "Credits Complete"
                row.placeholder = "5.0"
                row.formatter = formatter
            }.onChange { _ in
                self.validateForm()
            }
            <<< DecimalRow() { row in
                row.tag = "desiredGpa_form1"
                row.title = "Desired CGPA"
                row.placeholder = "10.0"
                row.formatter = formatter
            }.onChange {_ in
                self.validateForm()
            }
            <<< DecimalRow() { row in
                row.tag = "creditsInProgress_form1"
                row.title = "Credits in Progress"
                row.placeholder = "2.5"
                row.formatter = formatter
            }.onChange {_ in
                self.validateForm()
            }
            <<< DecimalRow() { row in
                row.tag = "requiredGpa_form1"
                row.title = "Calculated CGPA"
                row.placeholder = "Enter Info Above"
                row.formatter = formatter
                row.disabled = true
            }
            +++ Section(footer: "You can use this section to determine your overall CGPA based off a predicted CGPA for this term.")
            +++ Section("Overall CGPA with predicted term CGPA")
            <<< DecimalRow() { row in
                row.tag = "currentGpa_form2"
                row.title = "Current CGPA"
                row.placeholder = "8.9"
                row.formatter = formatter
            }.onChange { _ in
                self.validateForm()
            }
            <<< DecimalRow() { row in
                row.tag = "creditsComplete_form2"
                row.title = "Credits Complete"
                row.placeholder = "5.0"
                row.formatter = formatter
            }.onChange { _ in
                self.validateForm()
            }
            <<< DecimalRow() { row in
                row.tag = "predictedGpa_form2"
                row.title = "Predicted CGPA"
                row.placeholder = "9.4"
                row.formatter = formatter
            }.onChange {_ in
                self.validateForm()
            }
            <<< DecimalRow() { row in
                row.tag = "creditsInProgress_form2"
                row.title = "Credits in Progress"
                row.placeholder = "2.5"
                row.formatter = formatter
            }.onChange {_ in
                self.validateForm()
            }
            <<< DecimalRow() { row in
                row.tag = "overallGpa_form2"
                row.title = "Overall CGPA"
                row.placeholder = "Enter Info Above"
                row.formatter = formatter
                row.disabled = true
            }
    }
    
    func validateForm() {
        validateForm1()
        validateForm2()
    }
    
    private func validateForm1() {
        let values = form.values()
        let currentGpa = values["currentGpa_form1"] as? Double ?? -1
        let creditsComplete = values["creditsComplete_form1"] as? Double ?? -1
        let desiredGpa = values["desiredGpa_form1"] as? Double ?? -1
        let creditsInProgress = values["creditsInProgress_form1"] as? Double ?? -1
        let calculatedGpaRow = form.rowBy(tag: "requiredGpa_form1")
        
        if currentGpa >= 0 && creditsComplete >= 0 && desiredGpa >= 0 && creditsInProgress > 0 {
            calculatedGpaRow?.baseValue = Grading.calculateRequiredGpa(currentGpa: currentGpa, creditsComplete: creditsComplete, desiredGpa: desiredGpa, creditsInProgress: creditsInProgress)
        } else {
            calculatedGpaRow?.baseValue = nil
        }
        calculatedGpaRow?.updateCell()
    }
    
    private func validateForm2() {
        let values = form.values()
        let currentGpa = values["currentGpa_form2"] as? Double ?? -1
        let creditsComplete = values["creditsComplete_form2"] as? Double ?? -1
        let predictedGpa = values["predictedGpa_form2"] as? Double ?? -1
        let creditsInProgress = values["creditsInProgress_form2"] as? Double ?? -1
        let calculatedGpaRow = form.rowBy(tag: "overallGpa_form2")
        
        if currentGpa >= 0 && creditsComplete >= 0 && predictedGpa >= 0 && creditsComplete > 0 {
            calculatedGpaRow?.baseValue = Grading.calculatePredictedGpa(currentGpa: currentGpa, creditsComplete: creditsComplete, predictedGpa: predictedGpa, creditsInProgress: creditsInProgress)
        } else {
            calculatedGpaRow?.baseValue = nil
        }
        calculatedGpaRow?.updateCell()
    }

}
