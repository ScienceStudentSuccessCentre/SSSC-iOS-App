//
//  GradesViewController.swift
//  
//
//  Created by Avery Vine on 2018-09-27.
//

import UIKit

protocol GradesViewControllerDelegate: class {
    func toggleTableViewButtonsInNavigationBar(show: Bool)
    func toggleOffTableViewEditMode()
}

class GradesViewController: UIViewController {
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var termsView: UIView!
    @IBOutlet var calculatorView: UIView!
    @IBOutlet var plannerView: UIView!
    
    weak var delegate: GradesViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25),NSAttributedString.Key.foregroundColor: UIColor.white]
        
        if let ctrl = children.first(where: { $0 is GradesViewControllerDelegate }) {
            delegate = ctrl as? GradesViewControllerDelegate
        }
        
        switchToView(segmentIndex: 0)
    }
    
    @IBAction func segmentSelectedAction(sender: AnyObject) {
        switchToView(segmentIndex: sender.selectedSegmentIndex)
    }
    
    private func switchToView(segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            termsView.isHidden = false
            calculatorView.isHidden = true
            plannerView.isHidden = true
            navigationItem.title = "Terms"
        case 1:
            termsView.isHidden = true
            calculatorView.isHidden = false
            plannerView.isHidden = true
            navigationItem.title = "GPA Calculator"
            delegate?.toggleOffTableViewEditMode()
        case 2:
            termsView.isHidden = true
            calculatorView.isHidden = true
            plannerView.isHidden = false
            navigationItem.title = "GPA Planner"
            delegate?.toggleOffTableViewEditMode()
        default:
            break
        }
        
        delegate?.toggleTableViewButtonsInNavigationBar(show: segmentIndex == 0)
    }
}
