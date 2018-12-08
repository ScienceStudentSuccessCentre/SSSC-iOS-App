//
//  EventParser.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-02-02.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import SwiftSoup
import Alamofire

/// Singleton class that retrieves SSSC events from the server and parses them into proper `Event` objects.
class EventParser {
    
    private static var instance: EventParser! = nil
    
    private let baseURL = "http://sssc.carleton.ca"
    private let serverURL = "http://sssc-carleton-app-server.herokuapp.com/events";
    private let eventsURL = "/events"
    private var events = [Event]()
    private var observers = [EventObserver]()
    
    /// Asynchronously gathers event data from the server and parses the contents into proper `Event` objects.
    ///
    /// - Remark: Events downloaded and parsed by this function can be retrieved using `getEvents()`. This class will notify all observers when event data is ready to be retrieved.
    public func loadEvents() {
        events.removeAll()
        Alamofire.request(serverURL).responseData { (resData) -> Void in
            do {
                if let responseValue = resData.result.value {
                    let dataString: String! = String(data : responseValue, encoding: String.Encoding.utf8)
                    let data: Data = dataString.data(using: String.Encoding.utf8)!
                    self.parseEvents(data: data)
                } else {
                    throw Exception.Error(type: ExceptionType.MalformedURLException, Message: "HTTP load failed for URL \(self.serverURL)")
                }
            } catch {
                print(error)
                self.notifyObservers()
                self.alertUser()
            }
        }
    }
    
    /// Converts JSON data into a chronologically sorted list of SSSC events.
    ///
    /// - Parameter data: JSON data retrieved from the server.
    private func parseEvents(data: Data) {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        print("Received data:")
        print(json as Any)
        if let jsonEvents = json as? NSArray {
            for jsonEvent in jsonEvents {
                print(jsonEvent)
                if let eventData = jsonEvent as? NSDictionary {
                    let event = Event(eventData: eventData)
                    events.append(event)
                } else {
                    print("Failed to generate event for data:")
                    print(jsonEvent)
                }
            }
            sortEvents()
            self.notifyObservers()
        } else {
            print("JSON data is invalid")
            self.notifyObservers()
            self.alertUser()
        }
    }
    
    /// Sorts the list of SSSC events into chronological order.
    ///
    /// This function sorts by year, then by month, then by day. If event $0 occurs sooner than $1, the return is `true` (indicating that event $0 should come before event $1 in the list). The return is `false` otherwise.
    private func sortEvents() {
        events = events.sorted {
            if $0.getYear() < $1.getYear() {
                return true
            } else if $0.getYear() == $1.getYear() {
                if $0.getMonth() < $1.getMonth() {
                    return true
                } else if $0.getMonth() == $1.getMonth() {
                    if $0.getDay() < $1.getDay() {
                        return true
                    }
                }
            }
            return false
        }
    }
    
    /// Generates and presents an error alert message to any observers.
    private func alertUser() {
        let alert = UIAlertController(title: "Something went wrong!", message: "Something went wrong when loading the SSSC's upcoming events! Please try again later. If the issue persists, contact the SSSC so we can fix the problem as soon as possible.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        for observer in observers {
            observer.presentAlert(alert: alert)
        }
    }
    
    /// Notifies any observers that event parsing is complete and events are ready to be retrieved.
    private func notifyObservers() {
        for observer in observers {
            observer.update()
        }
    }
    
    /// Attaches a new observer to this class.
    ///
    /// - Parameter observer: The new observer to attach.
    public func attachObserver(observer: EventObserver) {
        observers.append(observer)
    }
    
    /// Retrieves the list of parsed and sorted SSSC events.
    ///
    /// - Returns: List of SSSC events.
    public func getEvents() -> [Event] {
        return events
    }
    
    /// Gets the Singleton instance of the EventParser class.
    ///
    /// - Returns: The Singleton instance of the EventParser class.
    public static func getInstance() -> EventParser {
        if (instance == nil) {
            instance = EventParser()
        }
        return instance
    }
    
}
