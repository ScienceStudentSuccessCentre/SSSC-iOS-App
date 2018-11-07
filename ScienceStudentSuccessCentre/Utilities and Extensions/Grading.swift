//
//  Grading.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-07.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

class Grading {
    
    static func calculatePercentage(earned: Double, total: Double) -> Int {
        return Int(earned / total * 100)
    }
    
}
