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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTermButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTermPressed))
        editTermsButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTermPressed))
        
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
    
    @objc func addTermPressed() {
        print("Adding")
    }
    
    @objc func editTermPressed() {
        print("Editing")
    }
    
    func toggleTableViewButtonsInNavigationBar(show: Bool) {
        if show {
            navigationController?.navigationBar.topItem?.setRightBarButton(addTermButton, animated: true)
            navigationController?.navigationBar.topItem?.setLeftBarButton(editTermsButton, animated: true)
        } else {
            navigationController?.navigationBar.topItem?.setRightBarButton(nil, animated: true)
            navigationController?.navigationBar.topItem?.setLeftBarButton(nil, animated: true)
        }
    }
    
}
