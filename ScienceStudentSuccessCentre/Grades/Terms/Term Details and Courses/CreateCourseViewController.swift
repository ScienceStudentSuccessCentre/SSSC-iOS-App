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
    let creditFormatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        creditFormatter.numberStyle = NumberFormatter.Style.decimal
        creditFormatter.maximumFractionDigits = 1
        creditFormatter.minimumFractionDigits = 1

        navigationItem.title = "New Course"
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed)), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createButtonPressed)), animated: true)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
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
            <<< InlineColorPickerRow() { (row) in
                row.tag = "colour"
                row.title = "Select a Colour"
                row.isCircular = false
                row.showsPaletteNames = false
                row.value = UIColor(.red)
            }.cellSetup { (cell, row) in
                let palette = ColorPalette(name: "Material", palette: UIColor.Material.getColourPalette())
                row.palettes = [palette]
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
        let colour = UIColor.Material.fromUIColor(color: values["colour"] as? UIColor ?? nil)
        let course = Course(id: 0, name: name, code: code, credits: credits, isCGPACourse: isCGPACourse, termId:    term.id, colour: colour)
        if !Database.instance.addCourse(course: course) {
            print("Failed to create course")
            //TODO: let the user know somehow
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonPressed() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}
