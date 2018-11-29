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
    @IBOutlet var termsView: UIView!
    @IBOutlet var calculatorView: UIView!
    @IBOutlet var plannerView: UIView!
    
    weak var delegate: GradesViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControlView.addBorders(edges: [.bottom], color: UIColor(.bluegrey), width: 0.5)
        
        if let ctrl = children.first(where: { $0 is GradesViewControllerDelegate }) {
            delegate = ctrl as? GradesViewControllerDelegate
        }
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
            termsView.isHidden = false
            calculatorView.isHidden = true
            plannerView.isHidden = true
            navigationItem.title = "Terms"
            delegate?.updateTableViewButtons(show: true)
        case 1:
            termsView.isHidden = true
            calculatorView.isHidden = false
            plannerView.isHidden = true
            navigationItem.title = "GPA Calculator"
            delegate?.updateTableViewButtons(show: false)
        case 2:
            termsView.isHidden = true
            calculatorView.isHidden = true
            plannerView.isHidden = false
            navigationItem.title = "GPA Planner"
            delegate?.updateTableViewButtons(show: false)
        default:
            break
        }
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
