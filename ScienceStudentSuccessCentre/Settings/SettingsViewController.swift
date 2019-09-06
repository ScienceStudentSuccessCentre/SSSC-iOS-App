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
        
        self.extendedLayoutIncludesOpaqueBars = true
        if #available(iOS 13.0, *) {
            prepareLargeTitleNavigationBarAppearance()
            tableView.backgroundColor = UIColor(named: "formBackground")
        }
        
        createForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let defaults = UserDefaults.standard
        let includeInProgressCourses = defaults.bool(forKey: "includeInProgressCourses")
        let respectSystemDarkMode = defaults.bool(forKey: "respectSystemDarkMode")
        let permanentDarkMode = defaults.bool(forKey: "permanentDarkMode")
        form.rowBy(tag: "includeInProgressCourses")?.baseValue = includeInProgressCourses
        form.rowBy(tag: "respectSystemDarkMode")?.baseValue = respectSystemDarkMode
        form.rowBy(tag: "permanentDarkMode")?.baseValue = permanentDarkMode
    }
    
    func createForm() {
        form
            +++ Section(header: "CGPA Calculator",
                        footer: "If toggled on, courses without a Final Grade specified will be included in CGPA calculations on the CGPA Calculator page.")
            <<< SwitchRow { row in
                row.tag = "includeInProgressCourses"
                row.title = "Include In-Progress Courses"
            }.cellUpdate { cell, _ in
                if #available(iOS 13.0, *) {
                    cell.backgroundColor = UIColor(named: "formAccent")
                    cell.textLabel?.textColor = UIColor.label
                }
            }.onChange { _ in
                self.validateForm()
            }
            
            +++ Section(header: "Dark Mode",
                        footer: "If Respect Dark Mode toggled on, the app will automatically switch into dark mode when your device is put into dark mode.")
            <<< SwitchRow { row in
                row.tag = "respectSystemDarkMode"
                row.title = "Respect System Dark Mode"
            }.cellUpdate { cell, _ in
                if #available(iOS 13.0, *) {
                    cell.backgroundColor = UIColor(named: "formAccent")
                    cell.textLabel?.textColor = UIColor.label
                }
            }.onChange { _ in
                self.validateForm()
            }
            <<< SwitchRow { row in
                row.tag = "permanentDarkMode"
                row.title = "Permanent Dark Mode"
                row.hidden = Condition.function(["respectSystemDarkMode"], { form in
                    return (form.rowBy(tag: "respectSystemDarkMode") as? SwitchRow)?.value ?? false
                })
            }.cellUpdate { cell, _ in
                if #available(iOS 13.0, *) {
                    cell.backgroundColor = UIColor(named: "formAccent")
                    cell.textLabel?.textColor = UIColor.label
                }
            }
            
            +++ Section(header: "\nBack Up Grades Data",
                        footer: "Open the exported attachement on your device to launch the Science Student Success Centre app and restore your data.")
            <<< ButtonRow { row in
                row.tag = "exportData"
                row.title = "Back Up Grades"
                row.onCellSelection(self.exportGradesTapped)
            }.cellUpdate { cell, _ in
                if #available(iOS 13.0, *) {
                    cell.backgroundColor = UIColor(named: "formAccent")
                }
            }
            
            +++ Section(header: "\nAcknowledgments",
                        // swiftlint:disable:next line_length
                        footer: "This app was developed for the Carleton University Science Student Success Centre by Avery Vine. Special thanks to Kshamina Ghelani, Selasi Kudolo, Gina Bak, Anisha Ghelani, Lily Visanuvimol, Divin Kang, and everyone else at the SSSC who helped out along the way.\n\nReleased under GNU General Public License v3.0 | Copyright @ 2018")
    }
    
    func validateForm() {
        let defaults = UserDefaults.standard
        if let includeInProgressCourses = form.rowBy(tag: "includeInProgressCourses")?.baseValue as? Bool {
            defaults.set(includeInProgressCourses, forKey: "includeInProgressCourses")
        }
        
        if let respectSystemDarkMode = form.rowBy(tag: "respectSystemDarkMode")?.baseValue as? Bool {
            defaults.set(respectSystemDarkMode, forKey: "respectSystemDarkMode")
            
            if let permanentDarkMode = form.rowBy(tag: "permanentDarkMode")?.baseValue as? Bool {
                defaults.set(permanentDarkMode, forKey: "permanentDarkMode")
            }
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
                    if let popOver = activityVC.popoverPresentationController {
                        popOver.sourceView = cell
                        popOver.sourceRect = CGRect(x: cell.bounds.midX, y: cell.bounds.maxY, width: 0, height: 0)
                    }
                    self.present(activityVC, animated: true)
                } catch {
                    print("Failed to export grade data")
                    let alert = UIAlertController(title: "Failed to export!",
                                                  message: "We were unable to export your grade data. Please try again!",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
                        self.navigationController?.dismiss(animated: true)
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
