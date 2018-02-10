//
//  Event.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-01-31.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

class Event {
    
    private var name: String
    private var description: String
    private var month: String
    private var day: Int
    private var time: String
    private var location: String
    private var url: String
    
    init() {
        self.name = ""
        self.description = ""
        self.month = ""
        self.day = 1
        self.time = ""
        self.location = ""
        self.url = ""
    }
    
    init(name: String, description: String, month: String, day: Int, time: String, location: String, url: String) {
        self.name = name
        self.description = description
        self.month = month
        self.day = day
        self.time = time
        self.location = location
        self.url = url
    }
    
    public func getName() -> String {
        return name
    }
    
    public func getDescription() -> String {
        return description
    }
    
    public func getMonth() -> String {
        return month
    }
    
    public func getDayString() -> String {
        if (day < 10) {
            return "0" + String(day)
        }
        return String(day)
    }
    
    public func getTime() -> String {
        return time
    }
    
    public func getLocation() -> String {
        return location
    }
}
