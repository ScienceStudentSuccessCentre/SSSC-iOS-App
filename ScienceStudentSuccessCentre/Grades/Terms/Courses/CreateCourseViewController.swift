//
//  CreateCourseViewController.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-10-02.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import Eureka

class CreateCourseViewController: FormViewController, EurekaFormProtocol {
    
    var term: Term!

    override func viewDidLoad() {
        super.viewDidLoad()

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
            <<< SwitchRow() { row in
                row.tag = "isCGPACourse"
                row.title = "Counts Towards Major GPA"
            }
    }
    
    func validateForm() {
        let values = form.values()
        let name = values["name"] as? String ?? ""
        let code = values["code"] as? String ?? ""
        if !name.isEmpty && !code.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc private func createButtonPressed() {
        let values = form.values()
        let name = values["name"] as? String ?? ""
        let code = values["code"] as? String ?? ""
        let isCGPACourse = values["isCGPACourse"] as? Bool ?? false
        if !Database.instance.addCourse(name: name, code: code, isCGPACourse: isCGPACourse, termId: term.id) {
            print("Failed to create course")
            //TODO: let the user know somehow
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonPressed() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}
