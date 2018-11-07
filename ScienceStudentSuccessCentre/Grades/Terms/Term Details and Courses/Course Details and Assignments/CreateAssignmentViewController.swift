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
    let gradeFormatter = NumberFormatter()
    
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
        
        createForm()
    }
    
    func createForm() {
        form
            +++ Section("Assignment Info")
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
            <<< DecimalRow() { row in
                row.tag = "weight"
                row.title = "Weight %"
                row.placeholder = "10%"
                row.formatter = gradeFormatter
                }.onChange { _ in
                    self.validateForm()
                }
        
        if (assignment != nil) {
            form.rowBy(tag: "name")?.baseValue = assignment.name
            form.rowBy(tag: "gradeEarned")?.baseValue = assignment.gradeEarned
            form.rowBy(tag: "gradeTotal")?.baseValue = assignment.gradeTotal
            form.rowBy(tag: "weight")?.baseValue = assignment.weight
        }
    }
    
    func validateForm() {
        let values = form.values()
        let name = values["name"] as? String ?? ""
        let gradeEarned = values["gradeEarned"] as? Double ?? -1
        let gradeTotal = values["gradeTotal"] as? Double ?? -1
        let weight = values["weight"] as? Double ?? -1
        if !name.isEmpty && 0 ... gradeTotal ~= gradeEarned && gradeTotal >= 0 && 0 ... 100 ~= weight {
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
        let weight = values["weight"] as? Double ?? 0
        let assignment = Assignment(id: self.assignment != nil ? self.assignment.id : -1, name: name, gradeEarned: gradeEarned, gradeTotal: gradeTotal, weight: weight, courseId: self.course != nil ? course.id : self.assignment.courseId)
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
