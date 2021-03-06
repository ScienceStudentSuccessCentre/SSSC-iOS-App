//
//  Event.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-01-31.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

class Event {
    
    // This sets each event's notification datetime to be be 15 seconds after the time of viewing an event
    private let DEBUG_NOTIFICATION_TRIGGER = false
    
    private var id: String
    private var name: String
    private var description: String
    private var dateTime: Date?
    private var rawTime: String
    private var location: String
    private var url: URL?
    private var imageUrl: URL?
    private var actionUrl: String?
    
    private let calendar = Calendar.current
    
    init() {
        self.id = ""
        self.name = ""
        self.description = ""
        self.dateTime = Date()
        self.rawTime = ""
        self.location = ""
        self.url = nil
        self.imageUrl = nil
        self.actionUrl = nil
    }
    
    init(eventData: NSDictionary) {
        self.id = eventData["id"] as? String
        self.name = eventData["name"] as? String
        self.description = eventData["description"] as? String
        self.dateTime = Formatter.iso8601.date(from: eventData["dateTime"] as? String)
        self.rawTime = eventData["rawTime"] as? String
        self.location = eventData["location"] as? String
        
        if let urlString = eventData["url"] as? String {
            self.url = URL(string: urlString)
        }
        
        if let imageUrlString = eventData["imageUrl"] {
            self.imageUrl = URL(string: imageUrlString)
        }
        
        self.actionUrl = eventData["actionUrl"] as? String
    }
    
    init(id: String, name: String, description: String,
         dateTime: Date, rawTime: String, location: String,
         url: URL?, imageUrl: URL?, actionUrl: String) {
        self.id = id
        self.name = name
        self.description = description
        self.dateTime = dateTime
        self.rawTime = rawTime
        self.location = location
        self.url = url
        self.imageUrl = imageUrl
        self.actionUrl = actionUrl
    }
    
    public func getId() -> String {
        return id
    }
    
    public func getName() -> String {
        return name
    }
    
    public func getDescription() -> String {
        return description
    }
    
    public func getDateTime() -> Date? {
        return dateTime
    }
    
    public func getNotificationDateTime() -> Date? {
        if DEBUG_NOTIFICATION_TRIGGER {
            return calendar.date(byAdding: .second, value: 15, to: Date())!
        } else {
            return calendar.date(byAdding: .hour, value: -1, to: dateTime!)
        }
    }
    
    public func getYear() -> Int {
        return calendar.component(.year, from: dateTime!)
    }
    
    public func getMonthName() -> String {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        return months[getMonth() - 1]
    }
    
    public func getMonth() -> Int {
        return calendar.component(.month, from: dateTime!)
    }
    
    public func getDay() -> Int {
        return calendar.component(.day, from: dateTime!)
    }
    
    public func getDayLeadingZero() -> String {
        let day: Int = getDay()
        if day < 10 {
            return "0" + String(day)
        }
        return String(day)
    }
    
    public func getRawTime() -> String {
        return rawTime
    }
    
    public func getFormattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        formatter.dateFormat = "HH:mm"
        let formattedTime = formatter.date(from: formatter.string(from: dateTime!))
        formatter.dateFormat = "h:mma"
        return formatter.string(from: formattedTime!)
    }
    
    public func getLocation() -> String {
        return location
    }
    
    public func getImageUrl() -> URL? {
        return imageUrl
    }
}
