//
//  GradesViewControllerDelegate.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-28.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

protocol GradesViewControllerDelegate: class {
    func toggleOffTableViewEditMode()
    func updateTableViewButtons(show: Bool)
}
