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
    let percentFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        percentFormatter.numberStyle = .percent
        percentFormatter.multiplier = 1
        
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
            <<< IntRow() { row in
                row.tag = "grade"
                row.title = "Grade"
                row.placeholder = "100%"
                row.formatter = percentFormatter
                }.onChange { _ in
                    self.validateForm()
                }
        
        if (assignment != nil) {
            form.rowBy(tag: "name")?.baseValue = course.name
            form.rowBy(tag: "grade")?.baseValue = course.credits
        }
    }
    
    func validateForm() {
        let values = form.values()
        let name = values["name"] as? String ?? ""
        let grade = values["grade"] as? Double ?? 100
        if !name.isEmpty && grade >= 0 && grade <= 100 {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc private func createButtonPressed() {
        let values = form.values()
//        let name = values["name"] as? String ?? ""
//        let code = values["code"] as? String ?? ""
//        let credits = values["credits"] as? Double ?? 0
//        let isCGPACourse = values["isCGPACourse"] as? Bool ?? false
//        let colour = UIColor.Material.fromUIColor(color: values["colour"] as? UIColor ?? nil)
//        let course = Course(id: self.course != nil ? self.course.id : -1, name: name, code: code, credits: credits, isCGPACourse: isCGPACourse, termId: self.term != nil ? term.id : self.course.termId, colour: colour)
//        if !Database.instance.insertOrUpdate(course: course) {
//            print("Failed to create course")
//            //TODO: let the user know somehow
//        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonPressed() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
