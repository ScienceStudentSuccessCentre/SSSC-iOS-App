//
//  EventParser.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-02-02.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import PromiseKit

/// Utility class that retrieves SSSC events from the server and parses them into proper `Event` objects.
class EventLoader {
    private static let serverUrl = URL(string: "http://sssc-carleton-app-server.herokuapp.com/events")
    
    /// Gathers event data from the server and passes it on to be deserialized.
    ///
    /// - Returns: The newly parsed events in the form of a promise.
    static func loadEvents() -> Promise<[Event]> {
        return Promise { seal in
            if let url = serverUrl {
                URLSession.shared.dataTask(with: url) { result in
                    switch result {
                    case .success((_, let data)):
                        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                            seal.reject(URLError(.badServerResponse))
                            return
                        }
                        let events = deserializeEvents(json: json)
                        let sortedEvents = sortEvents(events)
                        seal.fulfill(sortedEvents)
                    case .failure(let error):
                        seal.reject(error)
                    }
                }.resume()
            } else {
                seal.reject(URLError(.badURL))
            }
        }
    }
    
    /// Converts JSON data into a list of SSSC events.
    ///
    /// - Parameter json: JSON data retrieved from the server.
    /// - Returns: The list of events, parsed and sorted.
    private static func deserializeEvents(json: Any) -> [Event] {
        var events = [Event]()
        if let jsonEvents = json as? NSArray {
            for jsonEvent in jsonEvents {
                print(jsonEvent)
                if let eventData = jsonEvent as? NSDictionary,
                    let event = Event(eventData: eventData) {
                    events.append(event)
                } else {
                    print("Failed to generate event...")
                }
            }
        } else {
            print("JSON data is invalid")
        }

        #if DEBUG
        if UserDefaults.standard.bool(forKey: "showTestEvents") {
            events.append(Event.generateTestEvent())
            events.append(Event.generateTestEvent2())
        }
        #endif
        return events
    }
    
    /// Sorts the list of SSSC events into chronological order.
    ///
    /// This function sorts by year, then by month, then by day. If event $0 occurs sooner than $1, the return is `true` (indicating that event $0 should come before event $1 in the list). The return is `false` otherwise.
    /// - Parameter events: The list of events to sort.
    /// - Returns: The list of events in chronological order.
    private static func sortEvents(_ events: [Event]) -> [Event] {
        return events.sorted {
            if $0.year < $1.year {
                return true
            } else if $0.year == $1.year {
                if $0.month < $1.month {
                    return true
                } else if $0.month == $1.month {
                    if $0.day < $1.day {
                        return true
                    }
                }
            }
            return false
        }
    }
}
