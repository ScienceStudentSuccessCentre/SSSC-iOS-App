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
import PromiseKit

extension UNUserNotificationCenter {
    
    /// Checks if there are any pending notifications for the provided event.
    ///
    /// - Parameter event: The event about which the user is being notified.
    /// - Returns: Whether there are any pending notifications, in the form of a promise.
    internal func checkPendingNotifications(for event: Event) -> Promise<Bool> {
        return Promise { seal in
            UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
                let exists = requests.contains(where: { $0.identifier == event.getId() })
                seal.fulfill(exists)
            })
        }
    }
    
    /// Requests authorization from the user to deliver notifications.
    ///
    /// - Returns: Whether permission was granted by the user, in the form of a promise.
    private func requestAuthorization() -> Promise<Bool> {
        return Promise { seal in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                seal.fulfill(granted)
            }
        }
    }
    
    /// Checks if the app is authorized to send notifications to the user.
    ///
    /// If permissions haven't been decided either way yet, the user will be prompted to answer.
    /// - Returns: Whether the user is authorized, in the form of a promise.
    public func checkAuthorized() -> Promise<Bool> {
        return Promise { seal in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    seal.fulfill(true)
                    break
                case .notDetermined:
                    self.requestAuthorization().done { granted in
                        seal.fulfill(granted)
                    }.cauterize()
                    break;
                default:
                    seal.fulfill(false)
                }
            }
        }
    }
    
    /// Creates a new notification request and adds it to the notification center queue.
    ///
    /// - Parameter event: The event about which the user is to be notified.
    /// - Returns: Whether the notification was successfully created, in the form of a promise.
    internal func createNotification(for event: Event) -> Promise<Bool> {
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
        
        return Promise { seal in
            if let notificationDateTime = determineNotificationDateTime(for: event) {
                if notificationDateTime.compare(Date()) != ComparisonResult.orderedAscending {
                    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second,], from: notificationDateTime)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    let request = UNNotificationRequest(identifier: event.getId(), content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                        if let error = error {
                            print("Failed to create event notification:\n\(error)")
                            seal.fulfill(false)
                            return
                        }
                    })
                }
            } else {
                seal.fulfill(false)
                return
            }
            seal.fulfill(true)
        }
    }
    
    /// Removes all pending notifications for a provided event.
    ///
    /// - Parameter event: The event about which the user is being notified.
    internal func removeNotifications(for event: Event) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [event.getId()])
    }
    
    /// Provides the date and time the user should receive a notification for this event.
    ///
    /// - Remark: For the actual date and time of this event, use `getDateTime()`.
    /// - Attention: If the build is running in DEBUG mode (i.e. anything except what's being pushed to the App Store in an archive), a notification will be sent to the user 15 seconds after toggling on the notification for this event.
    /// - Returns: The notification date and time, or `nil` if one could not be calculated.
    private func determineNotificationDateTime(for event: Event) -> Date? {
        #if DEBUG
        return Calendar.current.date(byAdding: .second, value: 15, to: Date())!
        #else
        return event.getNotificationDateTime()
        #endif
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
