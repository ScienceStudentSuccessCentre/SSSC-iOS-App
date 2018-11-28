//
//  Grading.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-07.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

class Grading {
    
    static func calculatePercentage(earned: Double, total: Double) -> Double {
        if total <= 0 {
            return -1
        }
        return earned / total * 100
    }
    
    static func calculateLetterGrade(earned: Double, total: Double) -> String {
        return calculateLetterGrade(percentage: calculatePercentage(earned: earned, total: total))
    }
    
    static func calculateLetterGrade(percentage: Double) -> String {
        var letterGrade: String
        switch percentage {
        case 0 ..< 50:
            letterGrade = "F"
        case 50 ..< 53:
            letterGrade = "D-"
        case 53 ..< 57:
            letterGrade = "D"
        case 57 ..< 60:
            letterGrade = "D+"
        case 60 ..< 63:
            letterGrade = "C-"
        case 63 ..< 67:
            letterGrade = "C"
        case 67 ..< 70:
            letterGrade = "C+"
        case 70 ..< 73:
            letterGrade = "B-"
        case 73 ..< 77:
            letterGrade = "B"
        case 77 ..< 80:
            letterGrade = "B+"
        case 80 ..< 85:
            letterGrade = "A-"
        case 85 ..< 90:
            letterGrade = "A"
        case _ where percentage >= 90:
            letterGrade = "A+"
        default:
            letterGrade = "N/A"
        }
        return letterGrade
    }
    
    static func calculateGradePoints(letterGrade: String, creditWorth: Double) -> Double {
        var numericalGrade: Double
        switch letterGrade {
        case "F":
            numericalGrade = 0
        case "D-":
            numericalGrade = 1
        case "D":
            numericalGrade = 2
        case "D+":
            numericalGrade = 3
        case "C-":
            numericalGrade = 4
        case "C":
            numericalGrade = 5
        case "C+":
            numericalGrade = 6
        case "B-":
            numericalGrade = 7
        case "B":
            numericalGrade = 8
        case "B+":
            numericalGrade = 9
        case "A-":
            numericalGrade = 10
        case "A":
            numericalGrade = 11
        case "A+":
            numericalGrade = 12
        default:
            numericalGrade = -1
        }
        if numericalGrade != -1 {
            numericalGrade *= creditWorth
        }
        return numericalGrade
    }
    
    static func calculateGpa(percentage: Double) -> String {
        var gpa: Double
        switch percentage {
        case 0 ..< 50:
            gpa = percentage / 100
        case 50 ..< 53:
            gpa = (percentage / 100) + 1
        case 53 ..< 57:
            gpa = (percentage / 100) + 2
        case 57 ..< 60:
            gpa = (percentage / 100) + 3
        case 60 ..< 63:
            gpa = (percentage / 100) + 4
        case 63 ..< 67:
            gpa = (percentage / 100) + 5
        case 67 ..< 70:
            gpa = (percentage / 100) + 6
        case 70 ..< 73:
            gpa = (percentage / 100) + 7
        case 73 ..< 77:
            gpa = (percentage / 100) + 8
        case 77 ..< 80:
            gpa = (percentage / 100) + 9
        case 80 ..< 85:
            gpa = (percentage / 100) + 10
        case 85 ..< 90:
            gpa = (percentage / 100) + 11
        case _ where percentage >= 90:
            gpa = 12
        default:
            gpa = -1
        }
        if gpa == -1 {
            return "N/A"
        }
        return String(gpa.rounded(toPlaces: 1))
    }
    
    static func calculatedRequiredGrade(currentGrade: Double, desiredGrade: Double, weight: Weight, courseId: String) -> Double {
        let allAssignmentsWithWeight = Database.instance.getAssignmentsByCourseId(id: courseId).filter({ $0.weight.id == weight.id }).count
        let calculatedWeight = weight.value / Double(allAssignmentsWithWeight + 1)
        var requiredGrade = ((desiredGrade - currentGrade) / calculatedWeight * 100) + currentGrade
        if requiredGrade < 0 {
            requiredGrade = 0
        }
        return requiredGrade
    }
    
}
