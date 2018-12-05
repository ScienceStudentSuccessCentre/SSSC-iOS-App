//
//  Assignment.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-03.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

class Assignment {
    
    var id: String
    var name: String
    var gradeEarned: Double
    var gradeTotal: Double
    var weight: Weight
    var courseId: String
    
    init(id: String?, name: String, gradeEarned: Double, gradeTotal: Double, weight: Weight, courseId: String) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.gradeEarned = gradeEarned
        self.gradeTotal = gradeTotal
        self.weight = weight
        self.courseId = courseId
    }
    
    func percentage() -> String {
        let percentage = Grading.calculatePercentage(earned: gradeEarned, total: gradeTotal).rounded(toPlaces: 1)
        if percentage != -1 {
            return String(percentage) + "%"
        }
        return "N/A"
    }
    
    func letterGrade() -> String {
        return Grading.calculateLetterGrade(earned: gradeEarned, total: gradeTotal)
    }
    
    static func getAssignmentsByWeight(weight: Weight, assignments: [Assignment]) -> [Assignment] {
        var assignmentsWithWeight = [Assignment]()
        for assignment in assignments {
            if assignment.weight.id == weight.id {
                assignmentsWithWeight.append(assignment)
            }
        }
        return assignmentsWithWeight
    }
    
}
