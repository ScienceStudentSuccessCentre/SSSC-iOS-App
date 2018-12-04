//
//  GradesViewController.swift
//  
//
//  Created by Avery Vine on 2018-09-27.
//

import UIKit

class GradesViewController: UIViewController {
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var segmentControlView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    weak var delegate: GradesViewControllerDelegate?
    
    private lazy var termsViewController: TermsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var calculatorViewController: CalculatorViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CalculatorViewController") as! CalculatorViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var plannerViewController: PlannerViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "PlannerViewController") as! PlannerViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.view.backgroundColor = UIColor(.lightgrey)
        segmentControlView.addBorders(edges: [.bottom], color: UIColor(.bluegrey), width: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switchToView(segmentIndex: segmentControl.selectedSegmentIndex)
    }
    
    @IBAction func segmentSelectedAction(sender: AnyObject) {
        switchToView(segmentIndex: sender.selectedSegmentIndex)
    }
    
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
            navigationItem.rightBarButtonItems = nil
        }
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "termsViewController", let destinationController = segue.destination as? TermsViewController {
            destinationController.delegate = self
        }
    }
}

extension GradesViewController: SegmentControlDelegate {
    
    func updateSegmentControlPosition(delta: CGFloat) {
        let prevX = segmentControlView.frame.origin.x
        let prevY = segmentControlView.frame.origin.y
        let prevWidth = segmentControlView.frame.size.width
        let prevHeight = segmentControlView.frame.size.height
        segmentControlView.frame = CGRect(x: prevX, y: prevY + delta, width: prevWidth, height: prevHeight)
    }
    
}
