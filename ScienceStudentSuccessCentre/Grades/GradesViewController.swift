//
//  GradesViewController.swift
//  
//
//  Created by Avery Vine on 2018-09-27.
//

import UIKit

class GradesViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    weak var delegate: GradesViewControllerDelegate?
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Terms", "Calculator", "Planner"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentSelectedAction(sender:)), for: .primaryActionTriggered)
        return segmentControl
    }()
    
    private lazy var termsViewController: TermsViewController = {
        var viewController = storyboard?.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var calculatorViewController: CalculatorViewController = {
        var viewController = storyboard?.instantiateViewController(withIdentifier: "CalculatorViewController") as! CalculatorViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var plannerViewController: PlannerViewController = {
        var viewController = storyboard?.instantiateViewController(withIdentifier: "PlannerViewController") as! PlannerViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        extendedLayoutIncludesOpaqueBars = true;
        navigationController?.view.backgroundColor = UIColor(.lightgrey)
        navigationItem.titleView = segmentControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switchToView(segmentIndex: segmentControl.selectedSegmentIndex)
    }
    
    @IBAction func segmentSelectedAction(sender: AnyObject) {
        switchToView(segmentIndex: sender.selectedSegmentIndex)
    }
    
    /// Switch to the tab view with the given index.
    ///
    /// This function switches to the new tab by removing any other tabs attached to the view, then adding the correct tab. Finally, the title is updated to match the tab.
    /// - Parameter segmentIndex: The index of the `SegmentControl` tab to switch to.
    private func switchToView(segmentIndex: Int) {
        delegate?.toggleOffTableViewEditMode()
        switch segmentIndex {
        case 0:
            remove(asChildViewController: calculatorViewController)
            remove(asChildViewController: plannerViewController)
            add(asChildViewController: termsViewController)
            navigationItem.title = "Terms"
        case 1:
            remove(asChildViewController: termsViewController)
            remove(asChildViewController: plannerViewController)
            add(asChildViewController: calculatorViewController)
            navigationItem.title = "CGPA Calculator"
        case 2:
            remove(asChildViewController: termsViewController)
            remove(asChildViewController: calculatorViewController)
            add(asChildViewController: plannerViewController)
            navigationItem.title = "CGPA Planner"
        default:
            break
        }
    }
    
    /// Adds a given view to the overarching view.
    ///
    /// This function adds the given view to the overarching view. If the new view is a `GradesViewControllerDelegate`, then the `delegate` for the overarching view is set to the new view, and the related table view buttons are displayed.
    /// - Parameter viewController: The view to add to the overarching view.
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
        
        if let ctrl = children.first(where: { $0 is GradesViewControllerDelegate }) {
            delegate = ctrl as? GradesViewControllerDelegate
            delegate?.showTableViewButtons()
        } else {
            navigationItem.setLeftBarButton(nil, animated: true)
            navigationItem.setRightBarButton(nil, animated: true)
        }
    }
    
    /// Removes a specified view from the overarching view.
    ///
    /// - Parameter viewController: The view to remove from the overarching view.
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
