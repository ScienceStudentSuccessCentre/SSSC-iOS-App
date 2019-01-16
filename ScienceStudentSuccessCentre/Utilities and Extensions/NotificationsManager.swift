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
    /// - Remark: See `getNotificationDateTime()` for usage.
    private let DEBUG_NOTIFICATION_TRIGGER = true
    
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
    
    public func createNotification(for event: Event, completion: @escaping (Bool) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = event.getName()
        content.subtitle = "Today at " + event.getFormattedTime()
        content.body = event.getLocation()
        content.sound = UNNotificationSound.default
        
        if let url = event.getImageUrl() {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data),
                            let attachment = UNNotificationAttachment.create(identifier: event.getId(), image: image, options: nil) {
                            content.attachments = [attachment]
                        }
                    }
                }
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
    static func create(identifier: String, image: UIImage, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = identifier + ".png"
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            guard let imageData = image.pngData() else {
                return nil
            }
            try imageData.write(to: fileURL)
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch {
            print("Failed to create UNNotificationAttachment: \(error)")
        }
        return nil
    }
}
