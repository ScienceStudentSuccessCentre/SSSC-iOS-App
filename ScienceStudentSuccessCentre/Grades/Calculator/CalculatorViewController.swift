//
//  CalculatorViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-09-27.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var gpaDetailsView: UIView!
    @IBOutlet var gpa: UILabel!
    @IBOutlet var majorGpa: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalculatorTableViewCell", for: indexPath) as? CalculatorTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CalculatorTableViewCell.")
        }
        return cell
    }

}
