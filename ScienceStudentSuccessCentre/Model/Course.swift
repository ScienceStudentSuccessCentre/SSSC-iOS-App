//
//  Course.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-01.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import UIKit

/// A Course belongs to a Term (and thus has an associated `termId`), and has several Assignments and Weights associated with it.
class Course {
    
    var id: String
    var name: String
    var code: String
    var credits: Double
    var isMajorCourse: Bool
    var finalGrade: String
    var termId: String
    var colour: UIColor.Material
    
    /// Creates a Course object.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the course. If it's a brand new course, leave this as `nil` and one will be generated.
    ///   - name: The course's name, e.g. "Operating Systems".
    ///   - code: The course code, e.g. "COMP 3000".
    ///   - credits: The number of credits this course is worth, e.g. 0.5
    ///   - isMajorCourse: Whether or not this course should count towards the user's Major CGPA.
    ///   - finalGrade: The final grade the user earned in the course ("None" if incomplete).
    ///   - termId: The id of the Term to which this course belongs.
    ///   - colour: A UIColor.Material colour for the course (red by default).
    init(id: String?, name: String, code: String, credits: Double, isMajorCourse: Bool, finalGrade: String?, termId: String, colour: UIColor.Material?) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.code = code
        self.credits = credits
        self.isMajorCourse = isMajorCourse
        self.finalGrade = finalGrade ?? "None"
        self.termId = termId
        self.colour = colour ?? UIColor.Material.red
    }
    
    
    /// Calculates the grade for this course by iterating over all assignments for this course and summing their grades and weights, before passing it off to the Percentage calculator.
    ///
    /// - Returns: The percent grade for this course, or `-1` if the grade cannot be calculated.
    func getPercentGrade() -> Double {
        var totalEarned: Double = 0
        var totalWeight: Double = 0
        let assignments = Database.instance.getAssignmentsByCourseId(id: id)
        for assignment in assignments {
            let numAssignmentsWithWeight = assignments.filter({ $0.weight.id == assignment.weight.id }).count
            let calculatedWeight = assignment.weight.value / Double(numAssignmentsWithWeight)
            totalEarned += Grading.calculatePercentage(earned: assignment.gradeEarned, total: assignment.gradeTotal) * calculatedWeight / 100
            totalWeight += calculatedWeight
        }
        return Grading.calculatePercentage(earned: totalEarned, total: totalWeight)
    }
    
    
    /// Retrieves the letter grade for this course by getting the result of the Letter Grade calculator, unless there is a final grade specified for this course.
    ///
    /// - Returns: The letter grade for this course, or `N/A` if the grade cannot be calculated.
    func getLetterGrade() -> String {
        if finalGrade != "None" {
            return finalGrade
        }
        return Grading.calculateLetterGrade(percentage: getPercentGrade())
    }
    
    
    /// Gets a summary of the user's grade for this course (i.e. both letter grade and percentage). If a final grade is specified, just the final grade is returned (no percentage).
    ///
    /// - Remark: This makes use of both the `getPercentGrade()` and `getLetterGrade()` functions to generate the summary.
    /// - Returns: A formatted summary of the course grade.
    func getGradeSummary() -> String {
        if finalGrade != "None" {
            return finalGrade
        }
        let percentGrade = getPercentGrade().rounded(toPlaces: 1)
        if percentGrade < 0 {
            return "N/A"
        }
        let letterGrade = getLetterGrade()
        return String(percentGrade) + "% (" + letterGrade + ")"
    }
    
}

extension Course: Hashable {
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
