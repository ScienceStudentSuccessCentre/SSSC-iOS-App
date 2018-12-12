//
//  Grading.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-07.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

/// Utility class that groups all grade-related calculations together.
class Grading {
    
    /// Calculates a grade as a percentage.
    ///
    /// - Parameters:
    ///   - earned: The mark earned, out of the total marks available.
    ///   - total: The total marks available.
    /// - Returns: The grade as a percentage, or -1 if the total marks available is less than or equal to 0.
    static func calculatePercentage(earned: Double, total: Double) -> Double {
        if total <= 0 {
            return -1
        }
        return earned / total * 100
    }
    
    /// Calculates a grade as a letter grade from A+ to F.
    ///
    /// - Parameters:
    ///   - earned: The mark earned, out of the total marks available.
    ///   - total: The total marks available.
    /// - Returns: The grade as a letter grade, or "N/A" if one cannot be calculated.
    static func calculateLetterGrade(earned: Double, total: Double) -> String {
        return calculateLetterGrade(percentage: calculatePercentage(earned: earned, total: total))
    }
    
    /// Calculates a grade as a letter grade from A+ to F.
    ///
    /// - Parameter percentage: The grade for which to calculate a letter grade, as a percentage.
    /// - Returns: The grade as a letter grade, or "N/A" if one cannot be calculated.
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
    
    /// Calculates the grade point worth for a course.
    ///
    /// - Parameters:
    ///   - letterGrade: The course grade as a letter grade from A+ to F
    ///   - creditWorth: The number of credits the course is worth
    /// - Returns: The grade point worth of the course, or -1 if one cannot be calculated.
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
    
    /// Calculates the grade required on a final exam to achieve a desired grade in a course.
    ///
    /// - Parameters:
    ///   - currentGrade: The current grade in the course
    ///   - desiredGrade: The desired grade for the course
    ///   - weight: The weight of the final exam
    ///   - courseId: The ID of the course for which to calculate the required grade
    /// - Returns: The grade required on the final exam to achieve a desired grade in a course.
    static func calculatedRequiredGrade(currentGrade: Double, desiredGrade: Double, weight: Weight, courseId: String) -> Double {
        let allAssignmentsWithWeight = Database.instance.getAssignmentsByCourseId(id: courseId).filter({ $0.weight.id == weight.id }).count
        let calculatedWeight = weight.value / Double(allAssignmentsWithWeight + 1)
        var requiredGrade = ((desiredGrade - currentGrade) / calculatedWeight * 100) + currentGrade
        if requiredGrade < 0 {
            requiredGrade = 0
        }
        return requiredGrade
    }
    
    /// Calculates the overall GPA for a list of courses.
    ///
    /// - Parameter courses: The list of courses for which to calculate an overall GPA
    /// - Returns: The overall GPA of the courses provided, or -1 if one cannot be calculated.
    static func calculateOverallGpa(courses: [Course]!) -> Double {
        var totalGradePoints: Double = 0
        var totalCreditsWithGrades: Double = 0
        for course in courses {
            let gradePoints = Grading.calculateGradePoints(letterGrade: course.getLetterGrade(), creditWorth: course.credits)
            if gradePoints >= 0 {
                totalGradePoints += gradePoints
                totalCreditsWithGrades += course.credits
            }
        }
        if totalCreditsWithGrades > 0 {
            return (totalGradePoints / totalCreditsWithGrades)
        }
        return -1
    }
    
    /// Calculates the GPA required for a term in order to achieve a desired overall GPA.
    ///
    /// - Parameters:
    ///   - currentGpa: The user's current overall GPA
    ///   - creditsComplete: The number of course credits the user has completed
    ///   - desiredGpa: The overall GPA desired by the user
    ///   - creditsInProgress: The number of course credits the user is currently taking
    /// - Returns: The term GPA required to achieve a desired overall GPA
    static func calculateRequiredGpa(currentGpa: Double, creditsComplete: Double, desiredGpa: Double, creditsInProgress: Double) -> Double {
        return (desiredGpa * (creditsInProgress + creditsComplete) - currentGpa * (creditsComplete)) / creditsInProgress
    }
    
    /// Calculates an overall GPA based off an estimated current term GPA.
    ///
    /// - Parameters:
    ///   - currentGpa: The user's current overall GPA
    ///   - creditsComplete: The number of course credits the user has completed
    ///   - predictedGpa: The GPA the user predicts they will get for the current term
    ///   - creditsInProgress: The number of course credits the user is currently taking
    /// - Returns: The overall GPA based off an estimated current term GPA
    static func calculatePredictedGpa(currentGpa: Double, creditsComplete: Double, predictedGpa: Double, creditsInProgress: Double) -> Double {
        return ((currentGpa * creditsComplete) + (predictedGpa * creditsInProgress)) / (creditsComplete + creditsInProgress)
    }
    
}
