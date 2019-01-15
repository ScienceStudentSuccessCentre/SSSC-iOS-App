//
//  NotificationsManager.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 1/15/19.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationsManager {
    
    /// The shared instance (Singleton) of NotificationsManager.
    static let shared = NotificationsManager()
    
    /// This sets each event's notification datetime to be be 15 seconds after the time of viewing an event.
    ///
    /// - Remark: See `getNotificationDateTime()` for usage.
    private let DEBUG_NOTIFICATION_TRIGGER = false
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {
        
    }
    
    public func checkPendingNotifications(for event: Event, completion: @escaping (Bool) -> Void) {
        notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
            let exists = requests.contains(where: { $0.identifier == event.getId() })
            completion(exists)
        })
    }
    
    public func checkAuthorized(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { (settings) in
            let isAuthorized = settings.authorizationStatus == .authorized
            completion(isAuthorized)
        }
    }
    
    public func createNotification(for event: Event, completion: @escaping (String) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = event.getName()
        content.subtitle = "Today at " + event.getFormattedTime()
        content.body = event.getLocation()
        content.sound = UNNotificationSound.default
        
        if let notificationDateTime = determineNotificationDateTime(for: event) {
            if notificationDateTime.compare(Date()) != ComparisonResult.orderedAscending {
                let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second,], from: notificationDateTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                let request = UNNotificationRequest(identifier: event.getId(), content: content, trigger: trigger)
                
                notificationCenter.add(request, withCompletionHandler: { (error) in
                    if let error = error {
                        print(error)
                        completion("failure")
                    } else {
                        completion("success")
                    }
                })
            } else {
                completion("noop")
            }
        } else {
            completion("failure")
        }
    }
    
    public func removeNotifications(for event: Event) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [event.getId()])
    }
    
    /// Provides the date and time the user should receive a notification for this event.
    ///
    /// - Remark: For the actual date and time of this event, use `getDateTime()`.
    /// - Attention: If `DEBUG_NOTIFICATION_TRIGGER` is on, a notification will be sent to the user 15 seconds after toggling on the notification for this event.
    /// - Returns: The notification date and time, or `nil` if one could not be calculated.
    private func determineNotificationDateTime(for event: Event) -> Date? {
        if DEBUG_NOTIFICATION_TRIGGER {
            return Calendar.current.date(byAdding: .second, value: 15, to: Date())!
        }
        return event.getNotificationDateTime()
    }
    
}
