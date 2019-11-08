//
//  GradesViewController.swift
//  
//
//  Created by Avery Vine on 2018-09-27.
//

import UIKit

protocol GradesViewControllerDelegate: AnyObject {
    func toggleOffTableViewEditMode()
    func showTableViewButtons()
    func refreshTableViewData()
}

class GradesViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    weak var delegate: GradesViewControllerDelegate?
    
    private lazy var searchController: UISearchController = {
        let resultsViewController = CourseSearchViewController(actionDelegate: self)
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = resultsViewController
        searchController.searchBar.delegate = resultsViewController
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "Course Search"
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
            searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "searchBarBackground")
            searchController.searchBar.searchTextField.tintColor = .label
        }
        return searchController
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Terms", "Calculator", "Planner"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentSelectedAction(sender:)), for: .primaryActionTriggered)
        if #available(iOS 13.0, *) {
            segmentControl.overrideUserInterfaceStyle = .dark
        }
        return segmentControl
    }()
    
    private lazy var termsViewController: TermsViewController = {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "\(TermsViewController.self)") as? TermsViewController else {
            fatalError()
        }
        viewController.navigationItem.title = "Terms"
        viewController.navigationItem.searchController = searchController
        return viewController
    }()
    
    private lazy var calculatorViewController: CalculatorViewController = {
        guard let viewController = storyboard?.instantiateViewController(
            withIdentifier: "\(CalculatorViewController.self)") as? CalculatorViewController else {
            fatalError()
        }
        viewController.navigationItem.title = "CGPA Calculator"
        viewController.navigationItem.searchController = searchController
        return viewController
    }()
    
    private lazy var plannerViewController: PlannerViewController = {
        guard let viewController = storyboard?.instantiateViewController(
            withIdentifier: "\(PlannerViewController.self)") as? PlannerViewController else {
            fatalError()
        }
        viewController.navigationItem.title = "CGPA Planner"
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = true
        
        navigationItem.titleView = segmentControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareNavigationBarAppearance()
        
        switchToView(segmentIndex: segmentControl.selectedSegmentIndex)
    }
    
    @IBAction func segmentSelectedAction(sender: AnyObject) {
        switchToView(segmentIndex: sender.selectedSegmentIndex)
    }
    
    /// Switch to the tab view with the given index.
    ///
    /// This function switches to the new tab by removing any other tabs attached to the view, then adding the correct tab.
    /// - Parameter segmentIndex: The index of the `SegmentControl` tab to switch to.
    private func switchToView(segmentIndex: Int) {
        let allViews: [UIViewController] = [termsViewController, calculatorViewController, plannerViewController]
        let view = allViews[segmentIndex]
        
        guard !self.children.contains(view) else { return }
        
        delegate?.toggleOffTableViewEditMode()
        allViews.forEach { remove(asChildViewController: $0) }
        add(asChildViewController: view)
        navigationItem.title = view.navigationItem.title
        navigationItem.searchController = view.navigationItem.searchController
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
        
        if let delegate = viewController as? GradesViewControllerDelegate {
            delegate.showTableViewButtons()
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

extension GradesViewController: CourseSearchActionDelegate {
    func didTapCourse(_ course: Course) {
        dismiss(animated: true, completion: {
            guard let courseDetailVC = self.storyboard?.instantiateViewController(
                withIdentifier: "\(CourseDetailViewController.self)") as? CourseDetailViewController else { return }
            courseDetailVC.course = course
            self.searchController.searchBar.text = nil
            self.navigationController?.pushViewController(courseDetailVC, animated: true)
        })
    }
}
