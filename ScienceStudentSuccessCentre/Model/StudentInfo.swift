//
//  StudentInfo.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2020-08-12.
//  Copyright © 2020 Avery Vine. All rights reserved.
//

import Foundation

struct StudentInfo {
    let name: String
    let number: Int
    let degree: String
    
    init?() {
        guard let name = LocalSavedData.studentName, let number = LocalSavedData.studentNumber, let degree = LocalSavedData.degree else {
            return nil
        }
        self.name = name
        self.number = number
        self.degree = degree
    }
    
    init(name: String, number: Int, degree: String) {
        LocalSavedData.studentName = name
        LocalSavedData.studentNumber = number
        LocalSavedData.degree = degree
        self.name = name
        self.number = number
        self.degree = degree
    }
}
