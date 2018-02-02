//
//  Event.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-01-31.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

class Event {
    
    var name: String
    var description: String
    var month: String
    var monthInt: Int
    var year: Int
    var date: Int
    var time: String
//    var timeInt: Int
    var location: String
    
    init(name: String, description: String, month: String, year: Int, date: Int, time: String, location: String) {
        self.name = name
        self.description = description
        self.month = month
        switch month.lowercased() {
        case "feb":
            monthInt = 2
        case "mar":
            monthInt = 3
        case "apr":
            monthInt = 4
        case "may":
            monthInt = 5
        case "jun", "june":
            monthInt = 6
        case "jul", "july":
            monthInt = 7
        case "aug":
            monthInt = 8
        case "sep", "sept":
            monthInt = 9
        case "oct":
            monthInt = 10
        case "nov":
            monthInt = 11
        case "dec":
            monthInt = 12
        default:
            monthInt = 1
        }
        self.year = year
        self.date = date
        self.time = time
        self.location = location
    }
    
    func toString() -> String {
        return name + "\n\t" + month + " " + String(date) + ", " + String(year)
    }
}
