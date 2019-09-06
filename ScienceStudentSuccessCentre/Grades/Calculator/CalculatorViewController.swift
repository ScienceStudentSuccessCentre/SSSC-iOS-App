//
//  CalculatorViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-09-27.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SearchableList {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var gpaDetailsView: UIView!
    @IBOutlet var overallGpaLabel: UILabel!
    @IBOutlet var majorGpaLabel: UILabel!
    
    private var courses = [Course]()
    private var terms = [Course: Term]()
    
    private let gpaFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        gpaFormatter.numberStyle = .decimal
        gpaFormatter.maximumFractionDigits = 1
        gpaFormatter.minimumFractionDigits = 1
        
        extendedLayoutIncludesOpaqueBars = true
        tableView.register(UINib(nibName: "\(CourseSummaryCell.self)", bundle: nil), forCellReuseIdentifier: "\(CourseSummaryCell.self)")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CourseSummaryCell.self)", for: indexPath) as? CourseSummaryCell  else {
            fatalError("The dequeued cell is not an instance of \(CourseSummaryCell.self).")
        }
        let course = courses[indexPath.row]
        let term = terms[course]
        cell.configure(with: course, term: term)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "calculatorDetail", sender: self)
    }
    
    /// Loads and displays all of the user's courses, sorted by term.
    ///
    /// This function will get all of the user's courses. If the users wants to only display completed courses, all courses without final grades will be filtered out. Finally, courses are sorted by term and displayed to the user.
    private func loadCourses() {
        let defaults = UserDefaults.standard
        let includeInProgressCourses = defaults.bool(forKey: "includeInProgressCourses")
        
        courses.removeAll()
        courses = Database.instance.getCourses()
        if !includeInProgressCourses {
            courses = courses.filter({ $0.finalGrade != "None" })
        }
        sortCoursesByTerm()
        self.tableView.reloadData()
    }
    
    /// A sorting function that gets all terms from the database, then sorts loaded courses based off the reverse chronological order of those terms.
    private func sortCoursesByTerm() {
        let allTerms = Database.instance.getTerms()
        courses = courses.sorted { course1, course2  in
            if terms[course1] == nil {
                terms[course1] = allTerms.filter({ $0.id == course1.termId }).first
            }
            if terms[course2] == nil {
                terms[course2] = allTerms.filter({ $0.id == course2.termId }).first
            }
            if let term1 = terms[course1], let term2 = terms[course2] {
                if term1.year != term2.year {
                    return term1.year > term2.year
                } else {
                    if term1.term == "Fall" || (term1.term == "Summer" && term2.term == "Winter") {
                        return true
                    }
                    return false
                }
            }
            return false
        }
    }
    
    /// Calculates and displays the overall GPA and major GPA across all courses and terms.
    private func updateGpaDetails() {
        let overallGpa = Grading.calculateOverallGpa(courses: courses)
        
        let majorCourses = courses.filter({ $0.isMajorCourse })
        let majorGpa = Grading.calculateOverallGpa(courses: majorCourses)
        
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
        if segue.identifier == "calculatorDetail",
            let controller = segue.destination as? CourseDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            controller.course = courses[indexPath.row]
        }
    }
}
