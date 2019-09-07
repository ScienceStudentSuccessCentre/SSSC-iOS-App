//
//  CreateTermViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-01.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import Eureka

class CreateTermViewController: FormViewController, EurekaFormProtocol {
    private let terms = ["Fall", "Winter", "Summer"]
    private var years: [String]!
    private var term: String?
    private var year: String?
    weak var underlyingController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New Term"
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Cancel", style: .plain, target: self,
                                                        action: #selector(cancelButtonPressed)), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Create", style: .done, target: self,
                                                         action: #selector(createButtonPressed)), animated: true)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        setAvailableYears()
        createForm()
        
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = UIColor(named: "formBackground")
            tableView.separatorColor = UIColor(named: "separator")
        }
    }
    
    func createForm() {
        form
        +++ SelectableSection<ListCheckRow<String>>("Select a Term", selectionType: SelectionType.singleSelection(enableDeselection: false)) { row in
            for option in self.terms {
                row <<< ListCheckRow<String>(option) { listRow in
                    listRow.title = option
                    listRow.selectableValue = option
                    listRow.value = nil
                }.cellUpdate { cell, _ in
                    if #available(iOS 13.0, *) {
                        cell.backgroundColor = UIColor(named: "formAccent")
                        cell.textLabel?.textColor = UIColor.label
                    }
                }
            }
            row.onSelectSelectableRow = { cell, _ in
                self.term = cell.textLabel?.text
                self.validateForm()
            }
        }
        +++ SelectableSection<ListCheckRow<String>>("Select a Year", selectionType: SelectionType.singleSelection(enableDeselection: false)) { row in
            for option in self.years {
                row <<< ListCheckRow<String>(option) { listRow in
                    listRow.title = option
                    listRow.selectableValue = option
                    listRow.value = nil
                }.cellUpdate { cell, _ in
                    if #available(iOS 13.0, *) {
                        cell.backgroundColor = UIColor(named: "formAccent")
                        cell.textLabel?.textColor = UIColor.label
                    }
                }
            }
            row.onSelectSelectableRow = { cell, _ in
                self.year = cell.textLabel?.text
                self.validateForm()
            }
        }
    }
    
    /// Validates the current form values.
    ///
    /// Once all values are valid, the term creation button will be switched from disabled to enabled.
    func validateForm() {
        if term != nil && year != nil {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    /// Gets a set of 10 years for which terms can be created.
    ///
    /// This function sets the list of available term years to be the current year, one year in the future, and 8 years in the past.
    private func setAvailableYears() {
        years = [String]()
        let currYear = Calendar.current.dateComponents([.year], from: Date()).year
        for i in 0 ..< 10 {
            years.append(String((currYear ?? 2019) - i + 1))
        }
    }
    
    @objc private func createButtonPressed() {
        let newTerm = Term(id: nil, term: term!, year: year!)
        if !Database.instance.insert(term: newTerm) {
            print("Failed to create term")
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
}
