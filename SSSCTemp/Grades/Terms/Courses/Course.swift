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
    var isCGPACourse: Bool
    
    init(id: Int64, name: String, code: String, isCGPACourse: Bool) {
        self.id = Int(id)
        self.name = name
        self.code = code
        self.isCGPACourse = isCGPACourse
    }
    
}
