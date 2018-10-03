//
//  Term.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-09-28.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

class Term {
    
    var id: Int
    var term: String
    var year: String
    var name: String
    
    init(id: Int64, term: String, year: String) {
        self.id = Int(id)
        self.term = term
        self.year = year
        self.name = term + " " + year
    }
    
}
