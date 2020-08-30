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
    let email: String
    
    init?() {
        guard let name = LocalSavedData.studentName, let number = LocalSavedData.studentNumber, let email = LocalSavedData.studentEmail else {
            return nil
        }
        self.name = name
        self.number = number
        self.email = email
    }
    
    init(name: String, number: Int, email: String) {
        LocalSavedData.studentName = name
        LocalSavedData.studentNumber = number
        LocalSavedData.studentEmail = email
        self.name = name
        self.number = number
        self.email = email
    }
}
