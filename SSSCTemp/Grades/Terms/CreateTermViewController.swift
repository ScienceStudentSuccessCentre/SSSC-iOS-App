//
//  CreateTermViewController.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-10-01.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import Eureka

class CreateTermViewController: FormViewController, EurekaFormProtocol {
    
    private let terms = ["Fall", "Winter", "Summer"]
    private let years = ["2019", "2018", "2017", "2016", "2015", "2014"]
    private var term: String?
    private var year: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New Term"
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed)), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createButtonPressed)), animated: true)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        createForm()
    }
    
    func createForm() {
        form
        +++ SelectableSection<ListCheckRow<String>>("Select a Term", selectionType: SelectionType.singleSelection(enableDeselection: false)) { row in
            for option in self.terms {
                row <<< ListCheckRow<String>(option) { listRow in
                    listRow.title = option
                    listRow.selectableValue = option
                    listRow.value = nil
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
                }
            }
            row.onSelectSelectableRow = { cell, _ in
                self.year = cell.textLabel?.text
                self.validateForm()
            }
        }
    }
    
    func validateForm() {
        if term != nil && year != nil {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc private func createButtonPressed() {
        if !Database.instance.addTerm(term: term!, year: year!) {
            print("Failed to create term")
            //TODO: let the user know somehow
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonPressed() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

}
