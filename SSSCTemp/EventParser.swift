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
    
    static var instance: EventParser! = nil
    
    public func loadEvents() {
        Alamofire.request(baseURL + eventsURL).responseData { (resData) -> Void in
            do {
                if resData.result.value == nil {
                    throw Exception.Error(type: ExceptionType.MalformedURLException, Message: "HTTP load failed for URL \(self.baseURL + self.eventsURL)")
                }
                let data: String! = String(data : resData.result.value!, encoding : String.Encoding.utf8)
                let doc: Document = try SwiftSoup.parse(data)
                let eventsList = try doc.getElementsByClass("event-listing--list-item")
                try self.processEvents(eventsList: eventsList)
            } catch Exception.Error(let type, let message) {
                print("\(type): \(message)")
                self.notify()
                self.alertUser()
            } catch {
                print("Error")
                self.notify()
                self.alertUser()
            }
        }
    }
    
    private func processEvents(eventsList: Elements) throws {
        let eventGroup = DispatchGroup()
        for event in eventsList {
            DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil).async {
                var newEvent = Event()
                eventGroup.enter()
                do {
                    newEvent.name = try event.select(".event-details--title").first()!.text()
                    newEvent.url = try event.select("a").first()!.attr("href")
                    newEvent.month = try event.select(".event-cal-ico--month").first()!.text()
                    newEvent.day = (try Int(event.select(".event-cal-ico--day").first()!.text()))!
                    let eventFullDate = try event.select(".event-details--date").first()!.text().split(separator: " ")
                    newEvent.year = Int(eventFullDate[eventFullDate.count - 1])!
                    Alamofire.request(self.baseURL + newEvent.url).responseData { (resData) -> Void  in
                        do {
                            if resData.result.value == nil {
                                throw Exception.Error(type: ExceptionType.MalformedURLException, Message: "HTTP load failed for URL \(self.baseURL + newEvent.url)")
                            }
                            let data: String! = String(data : resData.result.value!, encoding : String.Encoding.utf8)
                            let doc: Document = try SwiftSoup.parse(data)
                            newEvent.description = try doc.getElementsByClass("event--description").text()
                            
                            let eventDetails = try doc.select(".event--details").first()!
                            let eventDetailsModules = try eventDetails.select(".row")
                            for eventDetailsModule in eventDetailsModules {
                                if try eventDetailsModule.getElementsByClass("fa-clock-o").size() != 0 {
                                    newEvent.time = try eventDetailsModule.select(".event-detail--content").first()!.text()
                                }
                                else if try eventDetailsModule.getElementsByClass("fa-reply").size() != 0 {
                                    // parse reply info
                                }
                                else if try eventDetailsModule.getElementsByClass("fa-map-marker").size() != 0 {
                                    newEvent.location = try eventDetailsModule.select(".event-detail--content").first()!.text()
                                }
                                else if try eventDetailsModule.getElementsByClass("fa-calendar").size() != 0 {
                                    // already have calendar info
                                }
                            }
                            self.insertEvent(newEvent: newEvent)
                            defer {
                                eventGroup.leave()
                            }
                            
                        } catch Exception.Error(let type, let message) {
                            print("\(type): \(message)")
                            self.notify()
                            self.alertUser()
                        } catch {
                            print("Error")
                            self.notify()
                            self.alertUser()
                        }
                    }
                } catch Exception.Error(let type, let message) {
                    print("\(type): \(message)")
                } catch {
                    print("Error")
                }
            }
        }
        
        eventGroup.notify(queue: DispatchQueue.main) { // 2
            self.notify()
        }
    }
    
    private func insertEvent(newEvent: Event) {
        var appended = false
        for i in 0 ..< events.count {
            let event = events[i]
            if newEvent.year < event.year {
                events.insert(newEvent, at: i)
                appended = true
                break
            } else if newEvent.year == event.year {
                if newEvent.getMonthInt() < event.getMonthInt() {
                    events.insert(newEvent, at: i)
                    appended = true
                    break
                } else if newEvent.getMonthInt() == event.getMonthInt() {
                    if newEvent.day < event.day {
                        events.insert(newEvent, at: i)
                        appended = true
                        break
                    }
                }
            }
        }
        if !appended {
            events.append(newEvent)
        }
    }
    
    private func alertUser() {
        let alert = UIAlertController(title: "Something went wrong!", message: "Something went wrong when loading the SSSC's upcoming events! Please try again later. If the issue persists, contact the SSSC so we can fix the problem as soon as possible.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        for observer in observers {
            observer.presentAlert(alert: alert)
        }
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
