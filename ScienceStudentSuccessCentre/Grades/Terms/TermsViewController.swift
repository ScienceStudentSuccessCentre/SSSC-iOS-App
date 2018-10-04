//
//  TermsViewController.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-09-27.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GradesViewControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    private var addTermButton: UIBarButtonItem!
    private var editTermsButton: UIBarButtonItem!
    private var doneEditingTermsButton: UIBarButtonItem!
    
    private var terms = [Term]()
    private var isCurrentView = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTermButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTermPressed))
        editTermsButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTermPressed))
        doneEditingTermsButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editTermPressed))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTerms()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isCurrentView = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        toggleOffTableViewEditMode()
        updateTableViewButtons(show: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isCurrentView = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TermTableViewCell", for: indexPath) as? TermTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TermTableViewCell.")
        }
        let term = terms[indexPath.row]
        cell.termName.text = term.name
        cell.termAbbr.text = String(term.term.prefix(1)) + String(term.year.suffix(2))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let term = terms[indexPath.row]
            if Database.instance.deleteTerm(id: term.id) {
                self.terms.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                DispatchQueue.main.sync {
                    if self.terms.count == 0 {
                        self.toggleOffTableViewEditMode()
                        self.toggleTableViewButtons()
                    }
                }
            }
        }
    }
    
    @objc func addTermPressed() {
        performSegue(withIdentifier: "createTerm", sender: self)
    }
    
    @objc func editTermPressed() {
        toggleTableViewEditMode()
        toggleTableViewButtons()
    }
    
    func toggleOffTableViewEditMode() {
        if tableView.isEditing {
            toggleTableViewEditMode()
        }
    }
    
    func toggleTableViewEditMode() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    func updateTableViewButtons(show: Bool) {
        if show && isCurrentView {
            toggleTableViewButtons()
        } else {
            getNavigationItem()?.setLeftBarButton(nil, animated: true)
            getNavigationItem()?.setRightBarButton(nil, animated: true)
        }
    }
    
    func toggleTableViewButtons() {
        if tableView.isEditing {
            getNavigationItem()?.setLeftBarButton(doneEditingTermsButton, animated: true)
        } else {
            getNavigationItem()?.setLeftBarButton(editTermsButton, animated: false)
        }
        getNavigationItem()?.setRightBarButton(addTermButton, animated: true)
    }
    
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
        self.tableView.reloadData()
    }
    
    private func getNavigationItem() -> UINavigationItem? {
        return navigationController?.navigationBar.topItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "termDetail" {
            let controller = segue.destination as! TermDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            controller.term = terms[indexPath.row]
        }
    }
    
}
