//
//  TermsViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-09-27.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class TermsViewController: UITableViewController, SearchableList {
    private var terms = [Term]()
    
    private var addTermButton: UIBarButtonItem!
    private var editTermsButton: UIBarButtonItem!
    private var doneEditingTermsButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTerms()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        toggleOffTableViewEditMode()
    }
    
    @objc func addTermPressed() {
        performSegue(withIdentifier: "createTerm", sender: self)
    }

    @objc func editTermPressed() {
        toggleTableViewEditMode()
        toggleTableViewButtons()
    }
    
    func toggleTableViewEditMode() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }

    /// Toggles the table view buttons between Done/Add and Edit/Add, depending on whether the table view is editing or not.
    func toggleTableViewButtons() {
        if let navigationItem = navigationController?.navigationBar.topItem {
            navigationItem.setRightBarButton(addTermButton, animated: true)
            if tableView.isEditing {
                navigationItem.setLeftBarButton(doneEditingTermsButton, animated: true)
            } else {
                navigationItem.setLeftBarButton(editTermsButton, animated: true)
            }
        }
    }
    
    private func loadTerms() {
        terms.removeAll()
        terms = Database.instance.getTerms()
        terms = terms.sorted {
            if $0.year != $1.year {
                return $0.year > $1.year
            } else {
                if $0.term == "Fall" || ($0.term == "Summer" && $1.term == "Winter") {
                    return true
                }
                return false
            }
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "termDetail",
            let cell = sender as? TermTableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            let controller = segue.destination as? TermDetailViewController {
            controller.term = terms[indexPath.row]
        }
        if segue.identifier == "createTerm",
            let controller = segue.destination.children.first as? CreateTermViewController {
            controller.underlyingController = self
        }
    }
    
    private func prepareNavigationBarButtons() {
        addTermButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTermPressed))
        editTermsButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTermPressed))
        doneEditingTermsButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editTermPressed))
    }
}

extension TermsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as TermTableViewCell
        let term = terms[indexPath.row]
        cell.termName.text = term.name
        cell.termAbbr.text = term.shortForm
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let term = terms[indexPath.row]
            if Database.instance.delete(termId: term.id) {
                self.terms.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    if self.terms.count == 0 {
                        self.toggleOffTableViewEditMode()
                        self.toggleTableViewButtons()
                    }
                }
            }
        }
    }
}

extension TermsViewController: GradesViewControllerDelegate {
    func toggleOffTableViewEditMode() {
        if tableView.isEditing {
            toggleTableViewEditMode()
        }
    }

    func showTableViewButtons() {
        toggleTableViewButtons()
    }

    func refreshTableViewData() {
        loadTerms()
    }
}
