//
//  CreateCourseViewController.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-10-02.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import Eureka
import ColorPickerRow

class CreateCourseViewController: FormViewController, EurekaFormProtocol {
    
    var term: Term!
    var course: Course!
    let creditFormatter = NumberFormatter()
    
    let letterGrades = ["None", "A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        creditFormatter.numberStyle = .decimal
        creditFormatter.maximumFractionDigits = 1
        creditFormatter.minimumFractionDigits = 1
        
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed)), animated: true)
        
        if (course == nil) {
            navigationItem.title = "New Course"
            navigationItem.setRightBarButton(UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createButtonPressed)), animated: true)
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.title = "Edit Course"
            navigationItem.setRightBarButton(UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(createButtonPressed)), animated: true)
        }
        
        createForm()
    }
    
    func createForm() {
        form
            +++ Section("Course Info")
            <<< TextRow() { row in
                row.tag = "name"
                row.title = "Name"
                row.placeholder = "Operating Systems"
                row.cell.textField.autocapitalizationType = .words
            }.onChange { _ in
                self.validateForm()
            }
            <<< TextRow() { row in
                row.tag = "code"
                row.title = "Code"
                row.placeholder = "COMP 3000"
                row.cell.textField.autocapitalizationType = .allCharacters
            }.onChange { _ in
                self.validateForm()
            }
            <<< DecimalRow() { row in
                row.tag = "credits"
                row.title = "Credits"
                row.placeholder = "0.5"
                row.formatter = creditFormatter
            }.onChange { _ in
                self.validateForm()
            }
            <<< SwitchRow() { row in
                row.tag = "isCGPACourse"
                row.title = "Counts Towards Major GPA"
            }
            +++ Section("Course Colour")
            <<< InlineColorPickerRow() { row in
                row.tag = "colour"
                row.title = "Select a Colour"
                row.isCircular = false
                row.showsPaletteNames = false
                row.value = UIColor(.red)
            }.cellSetup { (cell, row) in
                let palette = ColorPalette(name: "Material", palette: UIColor.Material.getColourPalette())
                row.palettes = [palette]
            }
            +++ Section("Override Calculated Grade")
            <<< PushRow<String>() { row in
                row.tag = "finalGrade"
                row.title = "Final Grade"
                row.options = letterGrades
                row.value = letterGrades.first
            }
        
        if (course != nil) {
            form.rowBy(tag: "name")?.baseValue = course.name
            form.rowBy(tag: "code")?.baseValue = course.code
            form.rowBy(tag: "credits")?.baseValue = course.credits
            form.rowBy(tag: "isCGPACourse")?.baseValue = course.isCGPACourse
            form.rowBy(tag: "finalGrade")?.baseValue = course.finalGrade
            form.rowBy(tag: "colour")?.baseValue = UIColor(course.colour)
        }
    }
    
    func validateForm() {
        let values = form.values()
        let name = values["name"] as? String ?? ""
        let code = values["code"] as? String ?? ""
        let credits = values["credits"] as? Double ?? 0
        if !name.isEmpty && !code.isEmpty && credits > 0 {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc private func createButtonPressed() {
        let values = form.values()
        let name = values["name"] as? String ?? ""
        let code = values["code"] as? String ?? ""
        let credits = values["credits"] as? Double ?? 0
        let isCGPACourse = values["isCGPACourse"] as? Bool ?? false
        let finalGrade = values["finalGrade"] as? String ?? "None"
        let colour = UIColor.Material.fromUIColor(color: values["colour"] as? UIColor ?? nil)
        let course = Course(id: self.course != nil ? self.course.id : -1, name: name, code: code, credits: credits, isCGPACourse: isCGPACourse, finalGrade: finalGrade, termId: self.term != nil ? term.id : self.course.termId, colour: colour)
        if !Database.instance.insertOrUpdate(course: course) {
            print("Failed to create course")
            //TODO: let the user know somehow
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonPressed() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}
