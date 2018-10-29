//
//  CourseDetailViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-03.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController {
    
    @IBOutlet var courseTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var course: Course!
    var assignments = [Assignment]()
    
    private var courseInfoButton: UIBarButtonItem!
    private var editAssignmentsButton: UIBarButtonItem!
    private var addAssignmentButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editCourseButton = UIButton(type: .infoLight)
        editCourseButton.addTarget(self, action: #selector(editCoursePressed), for: .touchUpInside)
        
        courseInfoButton = UIBarButtonItem(customView: editCourseButton)
        editAssignmentsButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAssignmentsPressed))
        addAssignmentButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAssignmentPressed))
        
        navigationItem.setRightBarButtonItems([courseInfoButton, addAssignmentButton, editAssignmentsButton], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dbCourse = Database.instance.getCourseById(id: course.id)
        if (dbCourse != nil) {
            course = dbCourse
        }
        navigationController?.navigationBar.barTintColor = UIColor(course.colour)
        courseTitle.text = course.name
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        navigationController?.navigationBar.barTintColor = .darkGray
    }
    
    @objc private func editCoursePressed() {
        performSegue(withIdentifier: "editCourse", sender: self)
    }
    
    @objc private func editAssignmentsPressed() {
        
    }
    
    @objc private func addAssignmentPressed() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCourse" {
            let controller = segue.destination.children.first as! CreateCourseViewController
            controller.course = course
        }
    }
}
