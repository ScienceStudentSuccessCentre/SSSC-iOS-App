//
//  CourseDetailViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-03.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var courseCode: UILabel!
    @IBOutlet var courseTitle: UILabel!
    @IBOutlet var courseTitleView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var courseGrade: UILabel!
    @IBOutlet var courseGradeView: UIView!
    @IBOutlet var calcReqFinalGrade: UIButton!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    var course: Course!
    var assignments = [Assignment]()
    private var accessoryButtonIndexPath: IndexPath! = nil
    
    private var courseInfoButton: UIBarButtonItem!
    private var editAssignmentsButton: UIBarButtonItem!
    private var doneEditingAssignmentsButton: UIBarButtonItem!
    private var addAssignmentButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        courseTitleView.addBorders(edges: [.bottom], color: UIColor(.bluegrey), width: 1)
        courseGradeView.addBorders(edges: [.top], color: UIColor(.bluegrey), width: 0.4)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        prepareNavigationBarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dbCourse = Database.instance.getCourseById(id: course.id)
        if dbCourse != nil {
            course = dbCourse
        }
        prepareNavigationBarAppearance(barTintColour: UIColor(course.colour))
        courseCode.text = course.code
        courseTitle.text = course.name
        loadAssignments()
        updateCourseDetails()
        
        guard let cells = tableView.visibleCells as? [AssignmentTableViewCell] else { return }
        for cell in cells {
            cell.setColour(colour: UIColor(course.colour))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        toggleOffTableViewEditMode()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        prepareNavigationBarAppearance()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as AssignmentTableViewCell
        let assignment = assignments[indexPath.row]
        cell.assignmentName.text = assignment.name
        cell.letterGrade.text = assignment.letterGrade()
        cell.percentageGrade.text = "Grade: " + assignment.percentage()
        cell.setColour(colour: UIColor(course.colour))
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        accessoryButtonIndexPath = indexPath
        self.performSegue(withIdentifier: "editAssignment", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let assignment = assignments[indexPath.row]
            if Database.instance.delete(assignmentId: assignment.id) {
                self.assignments.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    if self.assignments.count == 0 {
                        self.toggleOffTableViewEditMode()
                    }
                }
                updateCourseDetails()
            }
        }
    }
    
    private func prepareNavigationBarButtons() {
        let editCourseButton = UIButton(type: .infoLight)
        editCourseButton.addTarget(self, action: #selector(editCoursePressed), for: .touchUpInside)
        
        courseInfoButton = UIBarButtonItem(customView: editCourseButton)
        courseInfoButton.accessibilityIdentifier = "EditCourse"
        editAssignmentsButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAssignmentsPressed))
        doneEditingAssignmentsButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editAssignmentsPressed))
        addAssignmentButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAssignmentPressed))
        
        navigationItem.setRightBarButtonItems([courseInfoButton, addAssignmentButton, editAssignmentsButton], animated: true)
    }
    
    @IBAction private func calcReqFinalExamButtonPressed() {
        performSegue(withIdentifier: "calcReqFinalGrade", sender: self)
    }
    
    @objc private func editCoursePressed() {
        performSegue(withIdentifier: "editCourse", sender: self)
    }
    
    @objc private func editAssignmentsPressed() {
        toggleTableViewEditMode()
    }
    
    @objc private func addAssignmentPressed() {
        performSegue(withIdentifier: "createAssignment", sender: self)
    }
    
    private func toggleOffTableViewEditMode() {
        if tableView.isEditing {
            toggleTableViewEditMode()
        }
    }
    
    private func loadAssignments() {
        assignments.removeAll()
        assignments = Database.instance.getAssignmentsByCourseId(id: course.id)
        self.tableView.reloadData()
    }
    
    /// Calculates and displays the overall grade for the course being displayed, and shows/hides the final grade calculator button.
    private func updateCourseDetails() {
        courseGrade.text = "Overall Grade: " + course.getGradeSummary()
        
        DispatchQueue.main.async {
            if self.course.finalGrade != "None" || self.assignments.count == 0 {
                self.calcReqFinalGrade.isHidden = true
                self.bottomConstraint?.isActive = false
            } else {
                self.calcReqFinalGrade.isHidden = false
                self.bottomConstraint?.isActive = true
            }
            self.view.layoutIfNeeded()
        }
    }
    
    /// Toggles the table view buttons between CourseInfo/Add/Done and CourseInfo/Add/Edit, depending on whether table view editing is on or off.
    private func toggleTableViewEditMode() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            navigationItem.setRightBarButtonItems([courseInfoButton, addAssignmentButton, doneEditingAssignmentsButton], animated: true)
        } else {
            navigationItem.setRightBarButtonItems([courseInfoButton, addAssignmentButton, editAssignmentsButton], animated: true)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "editAssignment" {
                if accessoryButtonIndexPath == nil {
                    return false
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "editCourse":
            guard let controller = segue.destination.children.first as? CreateCourseViewController
                else { return }
            controller.course = course
            controller.underlyingController = self
        case "createAssignment":
            guard let controller = segue.destination.children.first as? CreateAssignmentViewController
                else { return }
            controller.course = course
            controller.underlyingController = self
        case "editAssignment":
            guard let controller = segue.destination.children.first as? CreateAssignmentViewController
                else { return }
            controller.assignment = assignments[accessoryButtonIndexPath.row]
            controller.course = course
            controller.underlyingController = self
        case "calcReqFinalGrade":
            guard let controller = segue.destination.children.first as? CalculateRequiredFinalViewController
                else { return }
            controller.course = course
        default:
            return
        }
    }
}
