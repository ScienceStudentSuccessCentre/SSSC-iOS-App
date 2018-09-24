//
//  Event.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-01-31.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

class Event {
    
    private var id: String
    private var name: String
    private var description: String
    private var dateAndTime: Date?
    private var rawTime: String
    private var location: String
    private var url: String
    private var imageUrl: String
    private var actionUrl: String
    
    init() {
        self.id = ""
        self.name = ""
        self.description = ""
        self.dateAndTime = Date()
        self.rawTime = ""
        self.location = ""
        self.url = ""
        self.imageUrl = "";
        self.actionUrl = "";
    }
    
    init(eventData: NSDictionary) {
        self.id = eventData["id"] as! String
        self.name = eventData["name"] as! String
        self.description = eventData["description"] as! String
        let tempDate = Formatter.iso8601.date(from: eventData["dateAndTime"] as! String)
        if (tempDate != nil) {
            self.dateAndTime = tempDate
        }
        self.rawTime = eventData["rawTime"] as! String
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
    
    init(id: String, name: String, description: String, dateAndTime: Date, rawTime: String, location: String, url: String, imageUrl: String, actionUrl: String) {
        self.id = id
        self.name = name
        self.description = description
        self.dateAndTime = dateAndTime
        self.rawTime = rawTime
        self.location = location
        self.url = url
        self.imageUrl = imageUrl
        self.actionUrl = actionUrl
    }
    
    
    
    public func getMonth() -> String {
        
    }
    
    public func getMonth() -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: dateAndTime!)

//        let months = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"]
//        return (months.firstIndex(of: month.lowercased()) ?? 0) + 1
    }
    
    public func getDay() -> String {
        
    }
    
    public func getDayString() -> String {
        if (day < 10) {
            return "0" + String(day)
        }
        return String(day)
    }
}
