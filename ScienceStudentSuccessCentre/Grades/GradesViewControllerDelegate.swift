//
//  GradesViewControllerDelegate.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-28.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

/// A protocol that lets other views control any view that has this protocol.
///
/// This protocol provides functions for interacting with tableview buttons, as well as refreshing the data in the tableview.
protocol GradesViewControllerDelegate: class {
    func toggleOffTableViewEditMode()
    func showTableViewButtons()
    func refreshTableViewData()
}
