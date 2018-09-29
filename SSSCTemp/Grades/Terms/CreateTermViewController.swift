//
//  CreateTermViewController.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-09-29.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class CreateTermViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonPressed)), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Create", style: UIBarButtonItem.Style.done, target: self, action: #selector(createButtonPressed)), animated: true)
    }
    
    @objc private func createButtonPressed() {
        if !createSampleTerm() {
            print("Failed to create sample term")
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonPressed() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func createSampleTerm() -> Bool {
        return Database.instance.addTerm(name: "TestTerm")
    }

}
