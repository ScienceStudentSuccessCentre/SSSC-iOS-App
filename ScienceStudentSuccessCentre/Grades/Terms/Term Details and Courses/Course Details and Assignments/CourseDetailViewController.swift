//
//  CourseDetailViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-03.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var courseTitle: UILabel!
    @IBOutlet var courseTitleView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var course: Course!
    var assignments = [Assignment]()
    
    private var courseInfoButton: UIBarButtonItem!
    private var editAssignmentsButton: UIBarButtonItem!
    private var addAssignmentButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        courseTitleView.addBorders(edges: [.bottom], color: UIColor(.bluegrey), width: 1)
        
        let editCourseButton = UIButton(type: .infoLight)
        editCourseButton.addTarget(self, action: #selector(editCoursePressed), for: .touchUpInside)
        
        courseInfoButton = UIBarButtonItem(customView: editCourseButton)
        editAssignmentsButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAssignmentsPressed))
        addAssignmentButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAssignmentPressed))
        
        navigationItem.setRightBarButtonItems([courseInfoButton, addAssignmentButton, editAssignmentsButton], animated: true)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dbCourse = Database.instance.getCourseById(id: course.id)
        if (dbCourse != nil) {
            course = dbCourse
        }
        courseTitle.text = course.name
        navigationController?.navigationBar.barTintColor = UIColor(course.colour).adjustedForNavController()
        for cell in tableView.visibleCells as! [AssignmentTableViewCell] {
            cell.setColour(colour: UIColor(course.colour))
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        navigationController?.navigationBar.barTintColor = UIColor(.bluegrey)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return assignments.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentTableViewCell", for: indexPath) as? AssignmentTableViewCell  else {
            fatalError("The dequeued cell is not an instance of AssignmentTableViewCell.")
        }
//        let assignment = assignments[indexPath.row]
//        cell.assignmentName.text = assignment.name
//        cell.grade.text = String(assignment.grade)
//        cell.weight.text = String(assignment.weight)
        cell.setColour(colour: UIColor(course.colour))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "assignmentDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            let assignment = assignments[indexPath.row]
//            if Database.instance.delete(courseId: course.id) {
//                self.courses.remove(at: indexPath.row)
//                DispatchQueue.main.async {
//                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
//                    if self.courses.count == 0 {
//                        self.toggleOffTableViewEditMode()
//                    }
//                }
//                updateTermDetails()
//            }
        }
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
