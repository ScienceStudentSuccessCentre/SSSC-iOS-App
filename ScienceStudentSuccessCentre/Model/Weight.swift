//
//  Weight.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-25.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation


/// A Weight belongs to a Course, and is associated with multiple Assignments.
class Weight : Codable {
    var id: String
    var name: String
    var value: Double
    var courseId: String
    
    
    /// Creates a Weight object.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this weight. If `nil` is provided, one will be generated.
    ///   - name: The name for this weight (e.g. "Assignments").
    ///   - value: The percent of the course that this weight makes up.
    ///   - courseId: The ID of the course with which this weight is associated.
    init(id: String?, name: String, value: Double, courseId: String) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.value = value
        self.courseId = courseId
    }
}
