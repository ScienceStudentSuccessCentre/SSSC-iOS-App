//
//  Weight.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-25.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

class Weight {
    
    var id: String
    var name: String
    var value: Double
    var courseId: String
    
    init(id: String?, name: String, value: Double, courseId: String) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.value = value
        self.courseId = courseId
    }
    
    public static func getWeightByName(name: String, weights: [Weight]) -> Weight? {
        return weights.first(where: {$0.name == name}) ?? nil
    }
    
    public static func getNames(weights: [Weight]) -> [String] {
        var weightNames = [String]()
        for weight in weights {
            weightNames.append(weight.name)
        }
        return weightNames
    }
    
}
