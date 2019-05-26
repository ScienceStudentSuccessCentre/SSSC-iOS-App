//
//  CoursesViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-09-28.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class TermDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var gpa: UILabel!
    @IBOutlet var credits: UILabel!
    @IBOutlet var termDetailsView: UIView!
    @IBOutlet var tableView: UITableView!
    
    private var addCourseButton: UIBarButtonItem!
    private var editCoursesButton: UIBarButtonItem!
    private var doneEditingCoursesButton: UIBarButtonItem!
    
    private let gpaFormatter = NumberFormatter()
    
    var term: Term!
    var courses = [Course]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        termDetailsView.addBorders(edges: [.top], color: UIColor(.bluegrey), width: 0.4)
        
        navigationItem.title = term.name
        
        gpaFormatter.numberStyle = .decimal
        gpaFormatter.maximumFractionDigits = 1
        gpaFormatter.minimumFractionDigits = 1
        
        tableView.delegate = self
        tableView.dataSource = self
        
        prepareNavigationBarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCourses()
        updateTermDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        toggleOffTableViewEditMode()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CourseTableViewCell.self)", for: indexPath) as? CourseTableViewCell  else {
            fatalError("The dequeued cell is not an instance of \(CourseTableViewCell.self).")
        }
        let course = courses[indexPath.row]
        cell.courseCode.text = course.code
        cell.courseName.text = course.name
        cell.grade.text = course.getLetterGrade()
        cell.gradeView.backgroundColor = UIColor(course.colour)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let course = courses[indexPath.row]
            if Database.instance.delete(courseId: course.id) {
                self.courses.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    if self.courses.count == 0 {
                        self.toggleOffTableViewEditMode()
                    }
                }
                updateTermDetails()
            }
        }
    }
    
    /// Sets up the various navigation bar buttons (associates them with their actions).
    private func prepareNavigationBarButtons() {
        addCourseButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCoursePressed))
        editCoursesButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editCoursesPressed))
        doneEditingCoursesButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editCoursesPressed))
        
        navigationItem.setRightBarButtonItems([addCourseButton, editCoursesButton], animated: true)
    }
    
    @objc private func addCoursePressed() {
        performSegue(withIdentifier: "editCourse", sender: self)
    }
    
    @objc private func editCoursesPressed() {
        toggleTableViewEditMode()
    }
    
    /// Toggles off table view editing, if it is on.
    private func toggleOffTableViewEditMode() {
        if tableView.isEditing {
            toggleTableViewEditMode()
        }
    }
    
    /// Toggles table view buttons between Add/Done and Add/Edit, depending on whether table view editing is on or not.
    private func toggleTableViewEditMode() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            navigationItem.setRightBarButtonItems([addCourseButton, doneEditingCoursesButton], animated: true)
        } else {
            navigationItem.setRightBarButtonItems([addCourseButton, editCoursesButton], animated: true)
        }
    }
    
    /// Loads all of the user's courses for the term being displayed, and displays them to the user.
    private func loadCourses() {
        courses.removeAll()
        courses = Database.instance.getCoursesByTermId(id: term.id)
        self.tableView.reloadData()
    }
    
    /// Calculates and displays the overall GPA and the total credits for the term being displayed.
    private func updateTermDetails() {
        let termGpa = Grading.calculateOverallGpa(courses: courses)
        var newGpaText = "Term CGPA: N/A"
        if termGpa != -1 {
            if let termGpaFormatted = gpaFormatter.string(from: termGpa as NSNumber) {
                newGpaText = "Term CGPA: " + termGpaFormatted
            }
        }
        gpa.text = newGpaText
        
        var totalCredits: Double = 0
        for course in courses {
            totalCredits += course.credits
        }
        credits.text = "Total Credits: \(totalCredits)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "courseDetail",
            let cell = sender as? CourseTableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            let controller = segue.destination as! CourseDetailViewController
            controller.course = courses[indexPath.row]
        }
        if segue.identifier == "editCourse" {
            let controller = segue.destination.children.first as! CreateCourseViewController
            controller.term = term
        }
    }
}
