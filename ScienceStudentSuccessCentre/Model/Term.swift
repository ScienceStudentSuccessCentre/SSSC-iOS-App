//
//  Term.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-09-28.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

/// A Term consists mainly of a unique ID, a "term" (a.k.a. season), and a year. The remaining fields are generated from those primary fields.
class Term: Codable {
    var id: String
    var term: String
    var year: String
    
    /// The full name of the term as a string (i.e. season + year).
    var name: String {
        return term + " " + year
    }
    
    /// This is a summarization of the term's name. E.g. "Fall 2018" becomes "F18".
    var shortForm: String {
        return String(term.prefix(1)) + String(year.suffix(2))
    }
    
    /// Creates a Term object.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the term. If this is a brand new term, leave this as `nil` and one will be generated.
    ///   - term: The school season (Fall, Winter, Summer).
    ///   - year: The school year.
    init(id: String?, term: String, year: String) {
        self.id = id ?? UUID().uuidString
        self.term = term
        self.year = year
    }
}
