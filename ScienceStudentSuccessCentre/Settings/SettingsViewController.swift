//
//  SettingsViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-30.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController, EurekaFormProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        let defaults = UserDefaults.standard
        let includeInProgressCourses = defaults.bool(forKey: "includeInProgressCourses")
        form.rowBy(tag: "includeInProgressCourses")?.baseValue = includeInProgressCourses
    }
    
    /// Creates a Eureka form for both Settings and Acknowledgments.
    func createForm() {
        form
            +++ Section(header: "Settings - CGPA Calculator", footer: "If toggled on, courses without a Final Grade specified will be included in CGPA calculations on the CGPA Calculator page.")
            <<< SwitchRow() { row in
                row.tag = "includeInProgressCourses"
                row.title = "Include Courses in Progress"
            }.onChange { _ in
                self.validateForm()
            }
            +++ Section(header: "\nBack Up Grades Data", footer: "Open the exported attachement on your device to launch the Science Student Success Centre app and restore your data.")
            <<< ButtonRow() { row in
                row.tag = "exportData"
                row.title = "Back Up Grades"
                row.onCellSelection(self.exportGradesTapped)
            }
            +++ Section(header: "\nAcknowledgments", footer: "This app was developed for the Carleton University Science Student Success Centre by Avery Vine. Special thanks to Kshamina Ghelani, Selasi Kudolo, Gina Bak, Anisha Ghelani, Lily Visanuvimol, Divin Kang, and everyone else at the SSSC who helped out along the way.\n\nReleased under GNU General Public License v3.0 | Copyright @ 2018")
    }
    
    /// Validates the current form values, and applies any settings changes necessary.
    func validateForm() {
        if let includeInProgressCourses = form.rowBy(tag: "includeInProgressCourses")?.baseValue as? Bool {
            let defaults = UserDefaults.standard
            defaults.set(includeInProgressCourses, forKey: "includeInProgressCourses")
        }
    }
    
    /// Runs when the "Back Up Grades" button is tapped.
    ///
    /// This function gathers all of the data from the database, serializes it, and passes the newly created `.sssc` file to the iOS Share Sheet.
    /// - Parameters:
    ///   - cell: The cell that was tapped (which should be the "Back Up Grades" button cell)
    ///   - row: The row that was tapped (which should be the "Back Up Grades" button row)
    private func exportGradesTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        if let data = Database.instance.exportData() {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let file = dir.appendingPathComponent("GradeData.sssc")
                do {
                    try data.write(to: file, options: .atomic)
                    let activityVC = UIActivityViewController(activityItems: [file], applicationActivities: nil)
                    self.present(activityVC, animated: true, completion: nil)
                } catch {
                    print("Failed to export grade data")
                    let alert = UIAlertController(title: "Failed to export!", message: "We were unable to export your grade data. Please try again! If this issue persists, contact the SSSC.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

}
