//
//  CourseDetailViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-03.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController {
    
    var course: Course!
    var assignments = [Assignment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = course.name
    }

}
