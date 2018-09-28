//
//  GradesViewController.swift
//  
//
//  Created by Avery Vine on 2018-09-27.
//

import UIKit

class GradesViewController: UIViewController {
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var termsView: UIView!
    @IBOutlet var calculatorView: UIView!
    @IBOutlet var plannerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25),NSAttributedString.Key.foregroundColor: UIColor.white]
        
        calculatorView.isHidden = true
        plannerView.isHidden = true
    }
    
    @IBAction func segmentSelectedAction(sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case 0:
            termsView.isHidden = false
            calculatorView.isHidden = true
            plannerView.isHidden = true
        case 1:
            termsView.isHidden = true
            calculatorView.isHidden = false
            plannerView.isHidden = true
        case 2:
            termsView.isHidden = true
            calculatorView.isHidden = true
            plannerView.isHidden = false
        default:
            break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
