//
//  Grading.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-07.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

class Grading {
    
    static func formatPercentage(percentage: Double) -> String {
        let percentFormatter = NumberFormatter()
        percentFormatter.maximumFractionDigits = 1
        percentFormatter.minimumFractionDigits = 0
        return percentFormatter.string(from: percentage as NSNumber) ?? ""
    }
    
    static func calculatePercentage(earned: Double, total: Double) -> Double {
        let percent = earned / total * 100
        return percent.rounded(toPlaces: 1)
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
    
}
