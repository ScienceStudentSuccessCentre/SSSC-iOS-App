//
//  Assignment.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-03.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation


/// An Assignment belongs to a Course, and is associated to a Weight.
class Assignment : Codable {
    
    var id: String
    var name: String
    var gradeEarned: Double
    var gradeTotal: Double
    var weight: Weight
    var courseId: String
    
    
    /// Creates an Assignment object.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for this assignment. If left `nil`, one will be generated.
    ///   - name: The name given to this assignment (e.g. "Assignment 1").
    ///   - gradeEarned: The grade the user earned out of a total possible grade (`gradeTotal`).
    ///   - gradeTotal: The highest possible grade for this assignment.
    ///   - weight: The weight this assignment has when calculating an overall course grade.
    ///   - courseId: The ID of the course with which this assignment is associated.
    init(id: String?, name: String, gradeEarned: Double, gradeTotal: Double, weight: Weight, courseId: String) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.gradeEarned = gradeEarned
        self.gradeTotal = gradeTotal
        self.weight = weight
        self.courseId = courseId
    }
    
    
    /// Calculatee the grade the user earned for this assignment, as a percentage.
    ///
    /// - Returns: The percent grade for this assignment, or `nil` if one cannot be calculated.
    func percentage() -> String {
        let percentage = Grading.calculatePercentage(earned: gradeEarned, total: gradeTotal).rounded(toPlaces: 1)
        if percentage != -1 {
            return String(percentage) + "%"
        }
        return "N/A"
    }
    
    
    /// Calculates the grade the user earned for this assignment, as a letter grade.
    ///
    /// - Returns: The letter grade for this assignment, or `N/A` if one cannot be calculated.
    func letterGrade() -> String {
        return Grading.calculateLetterGrade(earned: gradeEarned, total: gradeTotal)
    }
    
}
