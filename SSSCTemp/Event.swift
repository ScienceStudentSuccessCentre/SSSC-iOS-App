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
    var year: Int
    var month: String
    var day: Int
    var time: String
    var location: String
    var url: String
    
    init() {
        self.name = ""
        self.description = ""
        self.year = 2018
        self.month = "Jan"
        self.day = 1
        self.time = ""
        self.location = ""
        self.url = ""
    }
    
    init(name: String, description: String, year: Int, month: String, day: Int, time: String, location: String, url: String) {
        self.name = name
        self.description = description
        self.year = year
        self.month = month
        self.day = day
        self.time = time
        self.location = location
        self.url = url
    }
    
    public func getMonthInt() -> Int {
        var monthInt = 1
        switch month.lowercased() {
        case "jan":
            monthInt = 1
        case "feb":
            monthInt = 2
        case "mar":
            monthInt = 3
        case "apr":
            monthInt = 4
        case "may":
            monthInt = 5
        case "jun":
            monthInt = 6
        case "jul":
            monthInt = 7
        case "aug":
            monthInt = 8
        case "sep":
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
        return monthInt
    }
    
    public func getDayString() -> String {
        if (day < 10) {
            return "0" + String(day)
        }
        return String(day)
    }
}
