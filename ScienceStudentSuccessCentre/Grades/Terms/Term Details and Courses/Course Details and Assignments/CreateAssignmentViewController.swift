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
    weak var underlyingController: UIViewController?
    
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
        
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Cancel", style: .plain, target: self,
                                                        action: #selector(cancelButtonPressed)), animated: true)
        
        if assignment == nil {
            navigationItem.title = "New Assignment"
            navigationItem.setRightBarButton(UIBarButtonItem(title: "Create", style: .done, target: self,
                                                             action: #selector(createButtonPressed)), animated: true)
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.title = "Edit Assignment"
            navigationItem.setRightBarButton(UIBarButtonItem(title: "Update", style: .done, target: self,
                                                             action: #selector(createButtonPressed)), animated: true)
        }
        
        weights = Database.instance.getWeightsByCourseId(id: course.id)
        weightNames = weights.map({ $0.name })
        
        createForm()
        if assignment != nil {
            fillForm()
            validateForm()
        }
        
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = UIColor(named: "formBackground")
            tableView.separatorColor = UIColor(named: "separator")
        }
    }
    
    func createForm() {
        form
        +++ Section(header: "Assignment Info",
                    footer: weights.count == 0
                        // swiftlint:disable:next line_length
                        ? "NOTE: In order to add assignments, please create assignment weights for this course. This can be done using the (i) button on the previous screen!"
                        : "")
        <<< TextRow { row in
            row.tag = "name"
            row.title = "Name"
            row.placeholder = "Assignment 1"
            row.cell.textField.autocapitalizationType = .words
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
            row.tag = "gradeEarned"
            row.title = "Grade Earned"
            row.placeholder = "26"
            row.formatter = gradeFormatter
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
            row.tag = "gradeTotal"
            row.title = "Maximum Grade"
            row.placeholder = "30"
            row.formatter = gradeFormatter
        }.cellUpdate { cell, _ in
            if #available(iOS 13.0, *) {
                cell.backgroundColor = UIColor(named: "formAccent")
                cell.textLabel?.textColor = UIColor.label
                cell.textField?.textColor = UIColor.label
            }
        }.onChange { _ in
            self.validateForm()
        }
        <<< PushRow<String> { row in
            row.tag = "weight"
            row.title = "Weight"
            row.options = weightNames
            row.value = nil
        }.cellUpdate { cell, _ in
            if #available(iOS 13.0, *) {
                cell.backgroundColor = UIColor(named: "formAccent")
                cell.textLabel?.textColor = UIColor.label
            }
        }.onPresent { _, detailView in
            if #available(iOS 13.0, *) {
                detailView.view.layoutSubviews()
                detailView.tableView.backgroundColor = UIColor(named: "formBackground")
                detailView.tableView.separatorColor = UIColor(named: "separator")
                detailView.selectableRowCellUpdate = { cell, _ in
                    cell.tintColor = UIColor(named: "tint")
                    cell.backgroundColor = UIColor(named: "formAccent")
                    cell.textLabel?.textColor = UIColor.label
                }
            }
        }.onChange {_ in
            self.validateForm()
        }
    }
    
    /// Fills in form values from the Assignment object provided to this view controller.
    private func fillForm() {
        form.rowBy(tag: "name")?.baseValue = assignment.name
        form.rowBy(tag: "gradeEarned")?.baseValue = assignment.gradeEarned
        form.rowBy(tag: "gradeTotal")?.baseValue = assignment.gradeTotal
        form.rowBy(tag: "weight")?.baseValue = assignment.weight.name
    }
    
    /// Validates the current form values.
    ///
    /// If all values are valid, the Assignment creation/update button will be enabled. Otherwise, the button will remain disabled. For the form to be valid:
    /// - A name must exist
    /// - An earned grade must be filled in
    /// - A total grade must be filled in
    /// - A weight must be associated with this assignment
    func validateForm() {
        let values = form.values()
        let name = values["name"] as? String ?? ""
        let gradeEarned = values["gradeEarned"] as? Double ?? -1
        let gradeTotal = values["gradeTotal"] as? Double ?? -1
        let weightName = values["weight"] as? String ?? ""
        let weight = weights.first(where: {$0.name == weightName})
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
        let weight = weights.first(where: {$0.name == weightName})
        let assignment = Assignment(id: self.assignment?.id, name: name,
                                    gradeEarned: gradeEarned, gradeTotal: gradeTotal,
                                    weight: weight!, courseId: course.id)
        if !Database.instance.insertOrUpdate(assignment: assignment) {
            print("Failed to create assignment")
            presentGenericError()
        }
        navigationController?.dismiss(animated: true)
        
        if #available(iOS 13.0, *) {
            underlyingController?.viewWillAppear(true)
        }
    }
    
    @objc private func cancelButtonPressed() {
        navigationController?.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.textColor = UIColor(named: "tint")
        }
    }
}
