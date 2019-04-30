//
//  TermsViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-09-27.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class TermsViewController: UITableViewController {
    private var terms = [Term]()
    
    private var addTermButton: UIBarButtonItem!
    private var editTermsButton: UIBarButtonItem!
    private var doneEditingTermsButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTerms()
    }

    override func viewWillDisappear(_ animated: Bool) {
        toggleOffTableViewEditMode()
    }
    
    @objc func addTermPressed() {
        performSegue(withIdentifier: "createTerm", sender: self)
    }

    @objc func editTermPressed() {
        toggleTableViewEditMode()
        toggleTableViewButtons()
    }
    
    /// Toggles whether the table view is editing or not.
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
    
    /// Loads all of the terms from the database, and displays them to the user in chronologically sorted order.
    private func loadTerms() {
        terms.removeAll()
        terms = Database.instance.getTerms()
        terms = terms.sorted {
            if $0.year != $1.year {
                return $0.year > $1.year
            }
            else {
                if $0.term == "Fall" || ($0.term == "Summer" && $1.term == "Winter") {
                    return true
                }
                return false
            }
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "termDetail" {
            let controller = segue.destination as! TermDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            controller.term = terms[indexPath.row]
        }
    }
    
    /// Sets up the various navigation bar buttons (associates them with their actions).
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TermTableViewCell.self)", for: indexPath) as? TermTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(TermTableViewCell.self).")
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "termDetail", sender: self)
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
