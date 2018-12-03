//
//  Term.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-09-28.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

class Term {
    
    var id: String
    var term: String
    var year: String
    var name: String
    var shortForm: String {
        get {
            return String(term.prefix(1)) + String(year.suffix(2))
        }
    }
    
    init(id: String?, term: String, year: String) {
        self.id = id ?? UUID().uuidString
        self.term = term
        self.year = year
        self.name = term + " " + year
    }
    
}