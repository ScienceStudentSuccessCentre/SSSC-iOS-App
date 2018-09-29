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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTermButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTermPressed))
        editTermsButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTermPressed))
        doneEditingTermsButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editTermPressed))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TermTableViewCell", for: indexPath) as? TermTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TermTableViewCell.")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            self.catNames.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func addTermPressed() {
        print("Adding")
    }
    
    @objc func editTermPressed() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            getNavigationItem()?.setLeftBarButton(doneEditingTermsButton, animated: true)
        } else {
            getNavigationItem()?.setLeftBarButton(editTermsButton, animated: true)
        }
    }
    
    func toggleTableViewButtonsInNavigationBar(show: Bool) {
        if show {
            getNavigationItem()?.setRightBarButton(addTermButton, animated: false)
            if tableView.isEditing {
                getNavigationItem()?.setLeftBarButton(doneEditingTermsButton, animated: false)
            } else {
                getNavigationItem()?.setLeftBarButton(editTermsButton, animated: false)
            }
        } else {
            getNavigationItem()?.setRightBarButton(nil, animated: true)
            getNavigationItem()?.setLeftBarButton(nil, animated: true)
        }
    }
    
    private func getNavigationItem() -> UINavigationItem? {
        return navigationController?.navigationBar.topItem
    }
    
}
