//
//  Assignment.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-03.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

class Assignment {
    var id: Int
    var name: String
    var weight: Double
    var grade: Double
    
    init(id: Int, name: String, weight: Double, grade: Double) {
        self.id = id
        self.name = name
        self.weight = weight
        self.grade = grade
    }
}
