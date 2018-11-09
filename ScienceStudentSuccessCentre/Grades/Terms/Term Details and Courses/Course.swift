//
//  Course.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-10-01.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import UIKit

class Course {
    
    var id: Int
    var name: String
    var code: String
    var credits: Double
    var isCGPACourse: Bool
    var finalGrade: String
    var termId: Int
    var colour: UIColor.Material
    
    init(id: Int, name: String, code: String, credits: Double, isCGPACourse: Bool, finalGrade: String, termId: Int, colour: UIColor.Material?) {
        self.id = id
        self.name = name
        self.code = code
        self.credits = credits
        self.isCGPACourse = isCGPACourse
        self.finalGrade = finalGrade
        self.termId = termId
        self.colour = colour ?? UIColor.Material.red
    }
    
    func getGrade() -> String {
        if finalGrade != "None" {
            return finalGrade
        }
        var totalEarned: Double = 0
        var totalWeight: Double = 0
        let assignments = Database.instance.getAssignmentsByCourseId(id: id)
        for assignment in assignments {
            totalEarned += Grading.calculatePercentage(earned: assignment.gradeEarned, total: assignment.gradeTotal) * assignment.weight / 100
            totalWeight += assignment.weight
        }
        if totalWeight <= 0 {
            return "N/A"
        } else {
            return Grading.calculateLetterGrade(earned: totalEarned, total: totalWeight)
        }
    }
    
}
