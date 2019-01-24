//
//  NotificationsManager.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 1/15/19.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class NotificationsManager {
    
    /// The shared instance (Singleton) of NotificationsManager.
    static let shared = NotificationsManager()
    
    /// This sets each event's notification datetime to be be 15 seconds after the time of viewing an event.
    ///
    /// - Remark: See `determineNotificationDateTime()` for usage.
    private let DEBUG_NOTIFICATION_TRIGGER = false
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {
         // This is required to ensure that this remains a Singleton
    }
    
    /// Check if there are any pending notifications for the provided event.
    ///
    /// - Parameters:
    ///   - event: The event about which the user is being notified.
    ///   - completion: The block of code run upon completion of the check.
    public func checkPendingNotifications(for event: Event, completion: @escaping (Bool) -> Void) {
        notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
            let exists = requests.contains(where: { $0.identifier == event.getId() })
            completion(exists)
        })
    }
    
    /// Requests authorization from the user to deliver notifications.
    ///
    /// - Parameter completion: The block fo code run upon completion of the request.
    public func requestAuthorization(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            completion(granted)
        }
    }
    
    /// Check if the app is authorized to send notifications to the user.
    ///
    /// - Parameter completion: The block of code run upon completino of the check.
    public func checkAuthorized(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { (settings) in
            let isAuthorized = settings.authorizationStatus == .authorized
            completion(isAuthorized)
        }
    }
    
    /// Creates a new notification request and adds it to the notification center queue.
    ///
    /// If there is an image attached to this event, it will be included in the notification as an attachment.
    /// - Parameters:
    ///   - event: The event about which the user is being notified.
    ///   - completion: The block of code run upon completion of the notification creation.
    public func createNotification(for event: Event, completion: @escaping (Bool) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = event.getName()
        content.subtitle = "Today at " + event.getFormattedTime()
        content.body = event.getLocation()
        content.sound = UNNotificationSound.default
        
        if let url = event.getImageUrl(),
            let data = try? Data(contentsOf: url) {
            let imageName = url.absoluteString.components(separatedBy: "/").last ?? "image.jpg"
            if let attachment = UNNotificationAttachment.create(identifier: imageName, data: data, options: nil) {
                content.attachments = [attachment]
            }
        }
        
        var failed = false
        if let notificationDateTime = determineNotificationDateTime(for: event) {
            if notificationDateTime.compare(Date()) != ComparisonResult.orderedAscending {
                let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second,], from: notificationDateTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                let request = UNNotificationRequest(identifier: event.getId(), content: content, trigger: trigger)
                
                notificationCenter.add(request, withCompletionHandler: { (error) in
                    if let error = error {
                        print(error)
                        failed = true
                    }
                })
            }
        } else {
            failed = true
        }
        completion(failed)
    }
    
    /// Removes all pending notifications for a provided event.
    ///
    /// - Parameter event: The event about which the user is being notified.
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

extension UNNotificationAttachment {
    /// Creates a UNNotificationAttachment by first saving the contents of a remote URL onto the disk.
    ///
    /// - Parameters:
    ///   - identifier: The unique identifier of the attachment (used in part to determine media type).
    ///   - data: The actual data of the attachment.
    ///   - options: Any configuration options for attachment creation.
    /// - Returns: The generated `UNNotificationAttachment`, or `nil` if something went wrong.
    static func create(identifier: String, data: Data, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tempFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tempFolderUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tempFolderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: tempFolderUrl, withIntermediateDirectories: true, attributes: nil)
            let fileURL = tempFolderUrl.appendingPathComponent(identifier)
            try data.write(to: fileURL, options: [])
            let attachment = try UNNotificationAttachment(identifier: identifier, url: fileURL, options: options)
            return attachment
        } catch {
            print("Failed to generate UNNotificationAttachment: \(error)")
        }
        
        return nil
    }
}