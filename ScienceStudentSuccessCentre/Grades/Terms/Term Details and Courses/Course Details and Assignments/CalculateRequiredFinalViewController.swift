//
//  CalculateRequiredFinalViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-26.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import Eureka

class CalculateRequiredFinalViewController: FormViewController, EurekaFormProtocol {
    var course: Course!
    private var weights = [Weight]()
    private var weightNames = [String]()
    private var gradeFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradeFormatter.numberStyle = .percent
        gradeFormatter.maximumFractionDigits = 2
        gradeFormatter.minimumFractionDigits = 0
        gradeFormatter.multiplier = 1
        
        navigationItem.title = "Required Final Exam Grade"
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonPressed)), animated: true)
        
        weights = Database.instance.getWeightsByCourseId(id: course.id)
        weightNames = weights.map({ $0.name })
        
        createForm()
    }
    
    /// Creates a Eureka form for calculating required final exam grades for a desired course grade.
    func createForm() {
        form
        +++ Section(footer: "If you want a certain final grade in a course, you can use this section to determine what grade you should aim for on your final exam.")
        +++ Section("Course Details - " + course.code)
        <<< DecimalRow() { row in
            row.tag = "currentGrade"
            row.title = "Current Course Grade"
            row.placeholder = "85%"
            row.value = course.getPercentGrade().rounded(toPlaces: 2)
            row.formatter = gradeFormatter
        }.onChange { _ in
            self.validateForm()
        }
        <<< DecimalRow() { row in
            row.tag = "desiredGrade"
            row.title = "Desired Final Grade"
            row.placeholder = "90%"
            row.formatter = gradeFormatter
        }.onChange { _ in
            self.validateForm()
        }
        <<< PushRow<String>() { row in
            row.tag = "weight"
            row.title = "Final Exam Weight"
            row.options = weightNames
            row.value = nil
        }.onChange {_ in
            self.validateForm()
        }
        +++ Section("Minimum Final Exam Grade Required")
        <<< DecimalRow() { row in
            row.tag = "requiredGrade"
            row.title = "Grade"
            row.placeholder = "Enter Info Above"
            row.formatter = gradeFormatter
            row.baseCell.isUserInteractionEnabled = false
        }
    }
    
    /// Validates the current form values.
    ///
    /// This function will run the required final exam grade calculation if all conditions are met.
    /// Validity conditions:
    /// - A current grade is filled in
    /// - A desired grade is filled in, between 0 and 100
    /// - A final exam weight is chosen
    func validateForm() {
        let values = form.values()
        let currentGrade = values["currentGrade"] as? Double ?? -1
        let desiredGrade = values["desiredGrade"] as? Double ?? -1
        let weightName = values["weight"] as? String ?? ""
        let weight = weights.first(where: {$0.name == weightName})
        let calculatedGradeRow = form.rowBy(tag: "requiredGrade")
        
        if currentGrade >= 0 && 0 ... 100 ~= desiredGrade && weight != nil {
            calculatedGradeRow?.baseValue = Grading.calculatedRequiredGrade(currentGrade: currentGrade, desiredGrade: desiredGrade, weight: weight!, courseId: course.id)
        } else {
            calculatedGradeRow?.baseValue = nil
        }
        calculatedGradeRow?.updateCell()
    }
    
    @objc private func doneButtonPressed() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
