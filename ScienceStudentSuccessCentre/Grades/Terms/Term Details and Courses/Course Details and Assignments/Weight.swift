//
//  Weight.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-25.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

class Weight {
    
    var id: Int
    var name: String
    var value: Double
    var courseId: Int
    
    init(id: Int, name: String, value: Double, courseId: Int) {
        self.id = id
        self.name = name
        self.value = value
        self.courseId = courseId
    }
    
}
