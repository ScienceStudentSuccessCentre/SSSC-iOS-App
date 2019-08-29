//
//  PlannerViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-09-27.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import Eureka

class PlannerViewController: FormViewController, EurekaFormProtocol, GradesSegment {
    let segmentTitle = "CGPA Planner"
    
    private var currentGpa: Double!
    private let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        
        createForm()
        
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = UIColor(named: "formBackground")
        }
    }
    
    /// Creates a Eureka form for performing various GPA projections and calculations.
    ///
    /// - Remark: A quick note about this form. Since Eureka only supports having a single form at a time on a ViewController, I decided to implement both calculators in the same form. Fields should be differentiated between forms by the "_form#" portion of their row tags. Validation of each form is done separately. Check out `validateForm()`, `validateForm1()`, and `validateForm2()` for validation.
    func createForm() {
        form
        +++ Section(footer: "If you want to achieve a certain overall CGPA, use the section below to determine what CGPA you should aim for the current term.")
        +++ Section("Term CGPA for desired overall CGPA")
        <<< DecimalRow { row in
            row.tag = "currentGpa_form1"
            row.title = "Current CGPA"
            row.placeholder = "8.9"
            row.formatter = formatter
        }.cellUpdate { cell, _ in
            if #available(iOS 13.0, *) {
                cell.backgroundColor = UIColor(named: "formAccent")
                cell.textLabel?.textColor = UIColor.label
                cell.textField?.textColor = UIColor.label
            }
        }.onChange { _ in
            self.validateForm()
        }
        <<< DecimalRow { row in
            row.tag = "creditsComplete_form1"
            row.title = "Credits Complete"
            row.placeholder = "5.0"
            row.formatter = formatter
        }.cellUpdate { cell, _ in
            if #available(iOS 13.0, *) {
                cell.backgroundColor = UIColor(named: "formAccent")
                cell.textLabel?.textColor = UIColor.label
                cell.textField?.textColor = UIColor.label
            }
        }.onChange { _ in
            self.validateForm()
        }
        <<< DecimalRow { row in
            row.tag = "desiredGpa_form1"
            row.title = "Desired CGPA"
            row.placeholder = "10.0"
            row.formatter = formatter
        }.cellUpdate { cell, _ in
            if #available(iOS 13.0, *) {
                cell.backgroundColor = UIColor(named: "formAccent")
                cell.textLabel?.textColor = UIColor.label
                cell.textField?.textColor = UIColor.label
            }
        }.onChange {_ in
            self.validateForm()
        }
        <<< DecimalRow { row in
            row.tag = "creditsInProgress_form1"
            row.title = "Credits in Progress"
            row.placeholder = "2.5"
            row.formatter = formatter
        }.cellUpdate { cell, _ in
            if #available(iOS 13.0, *) {
                cell.backgroundColor = UIColor(named: "formAccent")
                cell.textLabel?.textColor = UIColor.label
                cell.textField?.textColor = UIColor.label
            }
        }.onChange {_ in
            self.validateForm()
        }
        <<< DecimalRow { row in
            row.tag = "requiredGpa_form1"
            row.title = "Calculated CGPA"
            row.placeholder = "Enter Info Above"
            row.formatter = formatter
            row.disabled = true
        }.cellUpdate { cell, _ in
            if #available(iOS 13.0, *) {
                cell.backgroundColor = UIColor(named: "formAccent")
                cell.textField?.textColor = UIColor.label
            }
        }
        +++ Section(footer: "\nYou can use the section below to determine your overall CGPA based off a predicted CGPA for this term.")
        +++ Section("Overall CGPA with predicted term CGPA")
        <<< DecimalRow { row in
            row.tag = "currentGpa_form2"
            row.title = "Current CGPA"
            row.placeholder = "8.9"
            row.formatter = formatter
        }.cellUpdate { cell, _ in
            if #available(iOS 13.0, *) {
                cell.backgroundColor = UIColor(named: "formAccent")
                cell.textLabel?.textColor = UIColor.label
                cell.textField?.textColor = UIColor.label
            }
        }.onChange { _ in
            self.validateForm()
        }
        <<< DecimalRow { row in
            row.tag = "creditsComplete_form2"
            row.title = "Credits Complete"
            row.placeholder = "5.0"
            row.formatter = formatter
        }.cellUpdate { cell, _ in
            if #available(iOS 13.0, *) {
                cell.backgroundColor = UIColor(named: "formAccent")
                cell.textLabel?.textColor = UIColor.label
                cell.textField?.textColor = UIColor.label
            }
        }.onChange { _ in
            self.validateForm()
        }
        <<< DecimalRow { row in
            row.tag = "predictedGpa_form2"
            row.title = "Predicted CGPA"
            row.placeholder = "9.4"
            row.formatter = formatter
        }.cellUpdate { cell, _ in
            if #available(iOS 13.0, *) {
                cell.backgroundColor = UIColor(named: "formAccent")
                cell.textLabel?.textColor = UIColor.label
                cell.textField?.textColor = UIColor.label
            }
        }.onChange {_ in
            self.validateForm()
        }
        <<< DecimalRow { row in
            row.tag = "creditsInProgress_form2"
            row.title = "Credits in Progress"
            row.placeholder = "2.5"
            row.formatter = formatter
        }.cellUpdate { cell, _ in
            if #available(iOS 13.0, *) {
                cell.backgroundColor = UIColor(named: "formAccent")
                cell.textLabel?.textColor = UIColor.label
                cell.textField?.textColor = UIColor.label
            }
        }.onChange {_ in
            self.validateForm()
        }
        <<< DecimalRow { row in
            row.tag = "overallGpa_form2"
            row.title = "Overall CGPA"
            row.placeholder = "Enter Info Above"
            row.formatter = formatter
            row.disabled = true
        }.cellUpdate { cell, _ in
            if #available(iOS 13.0, *) {
                cell.backgroundColor = UIColor(named: "formAccent")
                cell.textField?.textColor = UIColor.label
            }
        }
    }
    
    /// Validates the current form values, for all the "different" forms.
    func validateForm() {
        validateForm1()
        validateForm2()
    }
    
    /// Validates the current form values for form 1.
    ///
    /// This function will run the required term GPA calculation if all conditions are met.
    /// Validity conditions:
    /// - A current GPA is filled in
    /// - A number of completed credits is filled in
    /// - A desired GPA is filled in
    /// - The number of credits in progress is greater than 0
    private func validateForm1() {
        let values = form.values()
        let currentGpa = values["currentGpa_form1"] as? Double ?? -1
        let creditsComplete = values["creditsComplete_form1"] as? Double ?? -1
        let desiredGpa = values["desiredGpa_form1"] as? Double ?? -1
        let creditsInProgress = values["creditsInProgress_form1"] as? Double ?? -1
        let calculatedGpaRow = form.rowBy(tag: "requiredGpa_form1")
        
        if currentGpa >= 0 && creditsComplete >= 0 && desiredGpa >= 0 && creditsInProgress > 0 {
            let calculatedGpa = Grading.calculateRequiredGpa(currentGpa: currentGpa,
                                                             creditsComplete: creditsComplete,
                                                             desiredGpa: desiredGpa,
                                                             creditsInProgress: creditsInProgress)
            calculatedGpaRow?.baseValue = calculatedGpa
        } else {
            calculatedGpaRow?.baseValue = nil
        }
        calculatedGpaRow?.updateCell()
    }
    
    /// Validates the current form values for form 2.
    ///
    /// This function will run the projected overall GPA calculation if all conditions are met.
    /// Validity conditions:
    /// - A current GPA is filled in
    /// - A number of completed credits is filled in
    /// - A predicted GPA is filled in
    /// - The number of credits in progress is greater than 0
    private func validateForm2() {
        let values = form.values()
        let currentGpa = values["currentGpa_form2"] as? Double ?? -1
        let creditsComplete = values["creditsComplete_form2"] as? Double ?? -1
        let predictedGpa = values["predictedGpa_form2"] as? Double ?? -1
        let creditsInProgress = values["creditsInProgress_form2"] as? Double ?? -1
        let calculatedGpaRow = form.rowBy(tag: "overallGpa_form2")
        
        if currentGpa >= 0 && creditsComplete >= 0 && predictedGpa >= 0 && creditsInProgress > 0 {
            let calculatedGpa = Grading.calculatePredictedGpa(currentGpa: currentGpa,
                                                              creditsComplete: creditsComplete,
                                                              predictedGpa: predictedGpa,
                                                              creditsInProgress: creditsInProgress)
            calculatedGpaRow?.baseValue = calculatedGpa
        } else {
            calculatedGpaRow?.baseValue = nil
        }
        calculatedGpaRow?.updateCell()
    }
}
