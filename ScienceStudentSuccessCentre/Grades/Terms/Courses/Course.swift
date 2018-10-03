//
//  Course.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-10-01.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

class Course {
    
    var id: Int
    var name: String
    var code: String
    var credits: Double
    var isCGPACourse: Bool
    var termId: Int
    
    init(id: Int, name: String, code: String, credits: Double, isCGPACourse: Bool, termId: Int) {
        self.id = id
        self.name = name
        self.code = code
        self.credits = credits
        self.isCGPACourse = isCGPACourse
        self.termId = termId
    }
    
}
