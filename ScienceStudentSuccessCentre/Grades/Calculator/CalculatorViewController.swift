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
    @IBOutlet var overallGpaLabel: UILabel!
    @IBOutlet var majorGpaLabel: UILabel!
    
    private var courses = [Course]()
    private var terms = [Course : Term]()
    
    private let gpaFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        gpaFormatter.numberStyle = .decimal
        gpaFormatter.maximumFractionDigits = 1
        gpaFormatter.minimumFractionDigits = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCourses()
        updateGpaDetails()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalculatorTableViewCell", for: indexPath) as? CalculatorTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CalculatorTableViewCell.")
        }
        let course = courses[indexPath.row]
        let term = terms[course]
        cell.courseColourView.backgroundColor = UIColor(course.colour)
        cell.termAndCourseGrade.text = (term != nil ? (term!.name + " - ") : "") + course.code
        cell.courseName.text = course.name
        cell.courseLetterGrade.text = course.getLetterGrade()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "calculatorDetail", sender: self)
    }
    
    private func loadCourses() {
        courses.removeAll()
        courses = Database.instance.getCourses()
        self.tableView.reloadData()
    }
    
    private func updateGpaDetails() {
        let overallGpa = Grading.calculateOverallGpa(courses: courses)
        let majorGpa = Grading.calculateOverallGpa(courses: Course.filterMajorCourses(courses: courses))
        
        var newGpaText = "Overall CGPA: N/A"
        if overallGpa != -1 {
            if let overallGpaFormatted = gpaFormatter.string(from: overallGpa as NSNumber) {
                newGpaText = "Overall CGPA: " + overallGpaFormatted
            }
        }
        overallGpaLabel.text = newGpaText
        
        newGpaText = "Major CGPA: N/A"
        if majorGpa != -1 {
            if let majorGpaFormatted = gpaFormatter.string(from: majorGpa as NSNumber) {
                newGpaText = "Major CGPA: " + majorGpaFormatted
            }
        }
        majorGpaLabel.text = newGpaText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calculatorDetail" {
            let controller = segue.destination as! CourseDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            controller.course = courses[indexPath.row]
        }
    }

}
