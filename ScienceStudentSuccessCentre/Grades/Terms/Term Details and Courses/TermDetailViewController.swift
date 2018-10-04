//
//  CoursesViewController.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-09-28.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class TermDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var gpa: UILabel!
    @IBOutlet var credits: UILabel!
    @IBOutlet var tableView: UITableView!
    
    private var addCourseButton: UIBarButtonItem!
    private var editCoursesButton: UIBarButtonItem!
    private var doneEditingCoursesButton: UIBarButtonItem!
    
    var term: Term!
    var courses = [Course]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCourseButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCoursePressed))
        editCoursesButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editCoursesPressed))
        doneEditingCoursesButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editCoursesPressed))
        
        navigationItem.title = term.name
        navigationItem.setRightBarButtonItems([addCourseButton, editCoursesButton], animated: true)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCourses()
        updateTermDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        toggleOffTableViewEditMode()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CourseTableViewCell", for: indexPath) as? CourseTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CourseTableViewCell.")
        }
        let course = courses[indexPath.row]
        cell.courseName.text = course.name
        cell.courseCode.text = course.code
        cell.gradeView.backgroundColor = course.getColour()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "courseDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let course = courses[indexPath.row]
            if Database.instance.deleteCourse(id: course.id) {
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
    
    @objc private func addCoursePressed() {
        performSegue(withIdentifier: "createCourse", sender: self)
    }
    
    @objc private func editCoursesPressed() {
        toggleTableViewEditMode()
    }
    
    private func toggleOffTableViewEditMode() {
        if tableView.isEditing {
            toggleTableViewEditMode()
        }
    }
    
    private func toggleTableViewEditMode() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            navigationItem.setRightBarButtonItems([addCourseButton, doneEditingCoursesButton], animated: true)
        } else {
            navigationItem.setRightBarButtonItems([addCourseButton, editCoursesButton], animated: true)
        }
    }
    
    private func loadCourses() {
        courses.removeAll()
        courses = Database.instance.getCoursesByTermId(id: term.id)
        self.tableView.reloadData()
    }
    
    private func updateTermDetails() {
        var totalCredits: Double = 0
        for course in courses {
            totalCredits += course.credits
        }
        credits.text = "Total Credits: \(totalCredits)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "courseDetail" {
            let controller = segue.destination as! CourseDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            controller.course = courses[indexPath.row]
        }
        if segue.identifier == "createCourse" {
            let controller = segue.destination.children.first as! CreateCourseViewController
            controller.term = term
        }
    }

}
