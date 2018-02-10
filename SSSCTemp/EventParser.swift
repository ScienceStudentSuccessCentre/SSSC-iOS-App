//
//  EventParser.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-02-02.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import SwiftSoup
import Alamofire

class EventParser {
    
    private let baseURL = "http://sssc.carleton.ca"
    private let eventsURL = "/events"
    private var events = [Event]()
    private var observers = [Observer]()
    private var eventQueue = [Element]()
    
    private var newEvent: Event! = nil
    private var eventName: String = "Unknown"
    private var eventDescription: String = "Unknown"
    private var eventDay: Int = 1
    private var eventMonth: String = "JAN"
    private var eventTime: String = "Unknown"
    private var eventLocation: String = "Unknown"
    private var eventUrl: String = "Unknown"
    
    static var instance: EventParser! = nil
    
    public func loadEvents() {
        print("Loading events from: \(baseURL)\(eventsURL)")
        Alamofire.request(baseURL + eventsURL).responseData { (resData) -> Void in
            let data: String! = String(data : resData.result.value!, encoding : String.Encoding.utf8)
            do {
                let doc: Document = try SwiftSoup.parse(data)
                let eventsList = try doc.getElementsByClass("event-listing--list-item")
                for event in eventsList {
                    self.eventQueue.append(event)
                }
                try self.popEventFromQueue()
            } catch Exception.Error(let type, let message) {
                print("\(type), \(message)")
            } catch {
                print("Error")
            }
        }
    }
    
    private func popEventFromQueue() throws {
        if eventQueue.count > 0 {
            let event = eventQueue[0]
            eventQueue.remove(at: 0)
            
            eventName = try event.select(".event-details--title").first()!.text()
            eventUrl = try event.select("a").first()!.attr("href")
            eventMonth = try event.select(".event-cal-ico--month").first()!.text()
            eventDay = (try Int(event.select(".event-cal-ico--day").first()!.text()))!
            
            Alamofire.request(baseURL + eventUrl).responseData { (resData) -> Void  in
                let data: String! = String(data : resData.result.value!, encoding : String.Encoding.utf8)
                do {
                    let doc: Document = try SwiftSoup.parse(data)
                    self.eventDescription = try doc.getElementsByClass("event--description").text()
                    
                    try self.parseEventDetailBlocks(doc: doc)
                    
                    self.events.append(Event(name: self.eventName, description: self.eventDescription, month: self.eventMonth, day: self.eventDay, time: self.eventTime, location: self.eventLocation, url: self.eventUrl))
                    
                    try self.popEventFromQueue()
                    
                } catch Exception.Error(let type, let message) {
                    print("\(type), \(message)")
                } catch {
                    print("Error")
                }
            }
        } else {
            notify()
        }
    }
    
    private func parseEventDetailBlocks(doc: Document) throws {
        let eventDetails = try doc.select(".event--details").first()!
        let eventDetailsModules = try eventDetails.select(".row")
        for eventDetailsModule in eventDetailsModules {
            if try eventDetailsModule.getElementsByClass("fa-clock-o").size() != 0 {
                eventTime = try eventDetailsModule.select(".event-detail--content").first()!.text()
            }
            else if try eventDetailsModule.getElementsByClass("fa-reply").size() != 0 {
                // get reply
            }
            else if try eventDetailsModule.getElementsByClass("fa-map-marker").size() != 0 {
                eventLocation = try eventDetailsModule.select(".event-detail--content").first()!.text()
            }
            else {
                print("Module type not found")
            }
        }
        print(eventTime)
        print(eventLocation)
    }
    
    private func notify() {
        for observer in observers {
            observer.update()
        }
    }
    
    public func attachObserver(observer: Observer) {
        observers.append(observer)
    }
    
    public func getEvents() -> [Event] {
        return events
    }
    
    public static func getInstance() -> EventParser {
        if (instance == nil) {
            instance = EventParser()
        }
        return instance
    }
    
}
