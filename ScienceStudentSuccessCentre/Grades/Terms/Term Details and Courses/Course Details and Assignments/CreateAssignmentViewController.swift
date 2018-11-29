//
//  CreateAssignmentViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-05.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import Eureka

class CreateAssignmentViewController: FormViewController, EurekaFormProtocol {
    
    var course: Course!
    var assignment: Assignment!
    private var weights: [Weight]!
    private var weightNames = [String]()
    private let gradeFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradeFormatter.numberStyle = .decimal
        gradeFormatter.maximumFractionDigits = 2
        gradeFormatter.minimumFractionDigits = 0
        
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed)), animated: true)
        
        if (assignment == nil) {
            navigationItem.title = "New Assignment"
            navigationItem.setRightBarButton(UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createButtonPressed)), animated: true)
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.title = "Edit Assignment"
            navigationItem.setRightBarButton(UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(createButtonPressed)), animated: true)
        }
        
        weights = Database.instance.getWeightsByCourseId(id: course.id)
        weightNames = Weight.getNames(weights: weights)
        createForm()
    }
    
    func createForm() {
        form
            +++ Section(header: "Assignment Info", footer: weights.count == 0 ? "In order to add assignments, please create assignment weights for this course. This can be done from the previous screen." : "")
            <<< TextRow() { row in
                row.tag = "name"
                row.title = "Name"
                row.placeholder = "Assignment 1"
                row.cell.textField.autocapitalizationType = .words
            }.onChange { _ in
                self.validateForm()
            }
            <<< DecimalRow() { row in
                row.tag = "gradeEarned"
                row.title = "Grade Earned"
                row.placeholder = "26"
                row.formatter = gradeFormatter
            }.onChange { _ in
                self.validateForm()
            }
            <<< DecimalRow() { row in
                row.tag = "gradeTotal"
                row.title = "Maximum Grade"
                row.placeholder = "30"
                row.formatter = gradeFormatter
            }.onChange { _ in
                self.validateForm()
            }
            <<< PushRow<String>() { row in
                row.tag = "weight"
                row.title = "Weight"
                row.options = weightNames
                row.value = nil
            }.onChange {_ in
                self.validateForm()
            }
        
        if (assignment != nil) {
            form.rowBy(tag: "name")?.baseValue = assignment.name
            form.rowBy(tag: "gradeEarned")?.baseValue = assignment.gradeEarned
            form.rowBy(tag: "gradeTotal")?.baseValue = assignment.gradeTotal
            form.rowBy(tag: "weight")?.baseValue = assignment.weight.name
        }
    }
    
    func validateForm() {
        let values = form.values()
        let name = values["name"] as? String ?? ""
        let gradeEarned = values["gradeEarned"] as? Double ?? -1
        let gradeTotal = values["gradeTotal"] as? Double ?? -1
        let weightName = values["weight"] as? String ?? ""
        let weight = Weight.getWeightByName(name: weightName, weights: weights)
        if !name.isEmpty && gradeEarned >= 0 && gradeTotal >= 0 && weight != nil {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc private func createButtonPressed() {
        let values = form.values()
        let name = values["name"] as? String ?? ""
        let gradeEarned = values["gradeEarned"] as? Double ?? 0
        let gradeTotal = values["gradeTotal"] as? Double ?? 0
        let weightName = values["weight"] as? String ?? ""
        let weight = Weight.getWeightByName(name: weightName, weights: weights)
        let assignment = Assignment(id: self.assignment != nil ? self.assignment.id : nil, name: name, gradeEarned: gradeEarned, gradeTotal: gradeTotal, weight: weight!, courseId: course.id)
        if !Database.instance.insertOrUpdate(assignment: assignment) {
            print("Failed to create assignment")
            //TODO: let the user know somehow
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonPressed() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
