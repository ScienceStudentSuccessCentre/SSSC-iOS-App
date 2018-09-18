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
    var imageUrl: String
    var actionUrl: String
    
    init() {
        self.name = ""
        self.description = ""
        self.year = 2018
        self.month = "Jan"
        self.day = 1
        self.time = ""
        self.location = ""
        self.url = ""
        self.imageUrl = "";
        self.actionUrl = "";
    }
    
    init(eventData: NSDictionary) {
        self.name = eventData["name"] as! String
        self.description = eventData["description"] as! String
        self.year = (eventData["year"]) as! Int
        self.month = eventData["month"] as! String
        self.day = (eventData["day"]) as! Int
        self.time = eventData["time"] as! String
        self.location = eventData["location"] as! String
        self.url = eventData["url"] as! String
        if ((eventData["imageUrl"]) != nil) {
            self.imageUrl = eventData["imageUrl"] as! String
        } else {
            self.imageUrl = ""
        }
        if ((eventData["actionUrl"]) != nil) {
            self.actionUrl = eventData["actionUrl"] as! String
        } else {
            self.actionUrl = ""
        }
    }
    
    init(name: String, description: String, year: Int, month: String, day: Int, time: String, location: String, url: String, imageUrl: String, actionUrl: String) {
        self.name = name
        self.description = description
        self.year = year
        self.month = month
        self.day = day
        self.time = time
        self.location = location
        self.url = url
        self.imageUrl = imageUrl
        self.actionUrl = actionUrl
    }
    
    public func getMonthInt() -> Int {
        let months = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"]
        return (months.firstIndex(of: month.lowercased()) ?? 0) + 1
    }
    
    public func getDayString() -> String {
        if (day < 10) {
            return "0" + String(day)
        }
        return String(day)
    }
}
