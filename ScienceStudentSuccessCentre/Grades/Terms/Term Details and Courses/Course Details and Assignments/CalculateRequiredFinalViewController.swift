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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Required Final Exam Grade"
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonPressed)), animated: true)
        
        createForm()
    }
    
    func createForm() {
        
    }
    
    func validateForm() {
        calculateRequiredFinalExamGrade()
    }
    
    private func calculateRequiredFinalExamGrade() {
        
    }
    
    @objc private func doneButtonPressed() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
