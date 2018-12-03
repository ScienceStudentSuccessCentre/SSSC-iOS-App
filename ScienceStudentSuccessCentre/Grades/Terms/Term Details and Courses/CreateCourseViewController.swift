//
//  CreateCourseViewController.swift
//  ScienceStudentSuccessCentre
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
    private var weights = [Weight]()
    private var initialWeights = [Weight]()
    private let creditFormatter = NumberFormatter()
    private let weightFormatter = NumberFormatter()
    
    private let letterGrades = ["None", "A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        creditFormatter.numberStyle = .decimal
        creditFormatter.maximumFractionDigits = 1
        creditFormatter.minimumFractionDigits = 1
        
        weightFormatter.numberStyle = .percent
        weightFormatter.multiplier = 1
        
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed)), animated: true)
        
        if (course == nil) {
            navigationItem.title = "New Course"
            navigationItem.setRightBarButton(UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createButtonPressed)), animated: true)
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.title = "Edit Course"
            navigationItem.setRightBarButton(UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(createButtonPressed)), animated: true)
            
            weights = Database.instance.getWeightsByCourseId(id: course.id)
            initialWeights = weights
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
                row.tag = "isMajorCourse"
                row.title = "Counts Towards Major CGPA"
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
            +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete], header: "Assignment Weights", footer: "Assignment weights should total 100%.") { section in
                section.addButtonProvider = { section in
                    return ButtonRow() {
                        $0.title = "Add New Weight"
                    }
                }
                section.multivaluedRowToInsertAt = { index in
                    return SplitRow<TextRow, IntRow>() {
                        $0.rowLeft = TextRow() {
                            $0.placeholder = "Final Exam"
                            $0.cell.textField.autocapitalizationType = .words //TODO: this doesn't appear to be working
                        }
                        
                        $0.rowRight = IntRow() {
                            $0.placeholder = "30%"
                            $0.formatter = self.weightFormatter
                        }
                        
                        $0.tag = nil
                    }.onChange { _ in
                        self.validateForm()
                    }
                }
                section.tag = "weights"
            }
            +++ Section(header: "Override Calculated Grade", footer: "If you have already received a final letter grade from Carleton for this course, enter it here to ensure GPA calculation accuracy.")
            <<< PushRow<String>() { row in
                row.tag = "finalGrade"
                row.title = "Final Grade"
                row.options = letterGrades
                row.value = letterGrades.first
            }.onChange { _ in
                self.validateForm()
            }
        
        if (course != nil) {
            form.rowBy(tag: "name")?.baseValue = course.name
            form.rowBy(tag: "code")?.baseValue = course.code
            form.rowBy(tag: "credits")?.baseValue = course.credits
            form.rowBy(tag: "isMajorCourse")?.baseValue = course.isMajorCourse
            form.rowBy(tag: "finalGrade")?.baseValue = course.finalGrade
            form.rowBy(tag: "colour")?.baseValue = UIColor(course.colour)
            var weightsSection = form.sectionBy(tag: "weights") as! MultivaluedSection
            for weight in weights {
                let newRow = SplitRow<TextRow, IntRow>() {
                    $0.rowLeft = TextRow() {
                        $0.value = weight.name
                        $0.cell.textField.autocapitalizationType = .words //TODO: this doesn't appear to be working
                    }
                    
                    $0.rowRight = IntRow() {
                        $0.value = Int(weight.value)
                        $0.formatter = self.weightFormatter
                    }
                    
                    $0.tag = weight.id
                    
                }.onChange { _ in
                    self.validateForm()
                }
                weightsSection.append(newRow)
            }
            
            // adjust the Add New Weight button so it's below the actual weights
            let addButton = weightsSection.removeFirst()
            weightsSection.append(addButton)
        }

    }
    
    override func rowsHaveBeenAdded(_ rows: [BaseRow], at indexes: [IndexPath]) {
        super.rowsHaveBeenAdded(rows, at: indexes)
        self.validateForm()
    }
    
    override func rowsHaveBeenRemoved(_ rows: [BaseRow], at indexes: [IndexPath]) {
        super.rowsHaveBeenRemoved(rows, at: indexes)
        //TODO: stop editing accessory buttons from appearing after a row is removed
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        super.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
        if editingStyle == .delete {
            isEditing = false
            self.validateForm()
        }
    }
    
    func validateForm() {
        let values = form.values()
        let name = values["name"] as? String ?? ""
        let code = values["code"] as? String ?? ""
        let credits = values["credits"] as? Double ?? 0
        let finalGrade = values["finalGrade"] as? String ?? "None"
        
        let weightsSection = form.sectionBy(tag: "weights") as! MultivaluedSection
        let weightValues = weightsSection.values() as! [SplitRowValue<String, Int>]
        var weightNames = [String]()
        var validWeights = true
        var weightTotal = 0
        for weightValue in weightValues {
            let weightName = weightValue.left ?? ""
            let weightPercentage = weightValue.right ?? -1
            if (weightName.isEmpty && 0 ... 100 ~= weightPercentage) || !(0 ... 100 ~= weightPercentage) || weightNames.contains(weightName) {
                validWeights = false
                break
            }
            if 0 ... 100 ~= weightPercentage {
                weightTotal += weightPercentage
            }
            weightNames.append(weightName)
        }
        if (weightTotal != 100 && weightTotal != 0) || (weightValues.count == 0 && finalGrade == "None") {
            validWeights = false
        }
        
        if !name.isEmpty && !code.isEmpty && credits > 0 && validWeights {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    private func createCourse() {
        let values = form.values()
        let name = values["name"] as? String ?? ""
        let code = values["code"] as? String ?? ""
        let credits = values["credits"] as? Double ?? 0
        let isMajorCourse = values["isMajorCourse"] as? Bool ?? false
        let finalGrade = values["finalGrade"] as? String ?? "None"
        let colour = UIColor.Material.fromUIColor(color: values["colour"] as? UIColor ?? nil)
        
        let course = Course(id: self.course != nil ? self.course.id : nil, name: name, code: code, credits: credits, isMajorCourse: isMajorCourse, finalGrade: finalGrade, termId: self.term != nil ? term.id : self.course.termId, colour: colour)
        self.course = course
        if !Database.instance.insertOrUpdate(course: course) {
            print("Failed to create course")
            //TODO: let the user know somehow
        }
    }
    
    private func updateWeights() {
        let weightsSection = form.sectionBy(tag: "weights") as! MultivaluedSection
        weights.removeAll()
        
        weightsSection.forEach({ row in
            if let weightValue = row.baseValue as? SplitRowValue<String, Int> {
                if let name = weightValue.left {
                    let value = Double(weightValue.right ?? -1)
                    let weightId = row.tag
                    let weight = Weight(id: weightId, name: name, value: value, courseId: course.id)
                    weights.append(weight)
                }
            }
        })
        
        let assignments = Database.instance.getAssignmentsByCourseId(id: course.id)
        let weightIds = weights.map({ $0.id })
        let initialWeightIds = initialWeights.map( {$0.id })
        if assignments.filter({ initialWeightIds.contains($0.weight.id) }).count > assignments.filter({ weightIds.contains($0.weight.id) }).count {
            invalidWeightDeletion()
        } else {
            for weight in initialWeights {
                if weights.filter({ $0.id == weight.id }).count == 0 {
                    if !Database.instance.delete(weightId: weight.id) {
                        print("Failed to delete weight")
                        //TODO: let the user know somehow
                    }
                }
            }
            
            for weight in weights {
                if !Database.instance.insertOrUpdate(weight: weight) {
                    print("Failed to create weight")
                    //TODO: let the user know somehow
                }
            }
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func invalidWeightDeletion() {
        let alert = UIAlertController(title: "Can't modify weights!", message: "Please modify or delete all assignments that are marked with the weights you are trying to delete. All other course modifications were saved.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func createButtonPressed() {
        createCourse()
        updateWeights()
    }
    
    @objc private func cancelButtonPressed() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}
