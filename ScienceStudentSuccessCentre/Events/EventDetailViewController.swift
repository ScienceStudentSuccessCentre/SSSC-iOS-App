//
//  EventDetailViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-02-01.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import SafariServices
import UserNotifications

class EventDetailViewController: UIViewController, UITextViewDelegate {
    
    var event: Event!
    private let customButtonDimension = CGFloat(integerLiteral: 30)
    private let notificationsManager = NotificationsManager.shared
    private var actionUrlButton = UIButton()
    private var notifyMeButton = UIButton()
    
    @IBOutlet var eventTitleLabel: UILabel!
    @IBOutlet var eventTitleView: UIView!
    @IBOutlet var eventDescriptionTextView: UITextView!
    @IBOutlet var eventDetailsView: UIView!
    @IBOutlet var eventDateTimeLabel: UILabel!
    @IBOutlet var eventLocationLabel: UILabel!
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var eventStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        prepareEventDetails()
        prepareNavigationBarButtons()
        
        view.sendSubviewToBack(eventStackView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notificationsManager.checkPendingNotifications(for: event, completion: { notificationPending in
            self.updateNotifyMeButtonImage(notificationPending: notificationPending)
        })
    }
    
    /// Determines which buttons (action, notification) should be added to the navigation bar, if any.
    ///
    /// - Remark:
    ///     - If there is an action associated to the event being displayed, the action button is displayed.
    ///     - If the notification date/time for this event has not passed, the notification button is displayed.
    private func prepareNavigationBarButtons() {
        var barButtonItems: [UIBarButtonItem] = []
        
        if event.getNotificationDateTime()!.compare(Date()) != ComparisonResult.orderedAscending {
            prepareNotifyMeButton()
            barButtonItems.append(UIBarButtonItem(customView: notifyMeButton))
        }
        
        if event.getActionUrl() != "" {
            prepareActionUrlButton()
            barButtonItems.append(UIBarButtonItem(customView: actionUrlButton))
        }
        
        navigationItem.setRightBarButtonItems(barButtonItems, animated: true)
    }
    
    /// Prepares the custom notifications button to be displayed.
    private func prepareNotifyMeButton() {
        notifyMeButton.setImage(UIImage(named: "notifyOff"), for: .normal)
        notifyMeButton.addTarget(self, action: #selector(notifyMeTapped), for: .touchUpInside)
        notifyMeButton.frame = CGRect(x: 0, y: 0, width: customButtonDimension, height: customButtonDimension)
        notifyMeButton.widthAnchor.constraint(equalToConstant: customButtonDimension).isActive = true
        notifyMeButton.heightAnchor.constraint(equalToConstant: customButtonDimension).isActive = true
        notifyMeButton.translatesAutoresizingMaskIntoConstraints = false
        notifyMeButton.accessibilityLabel = "Notify Me"
        notifyMeButton.accessibilityTraits = .button
    }
    
    /// Prepares the custom action URL button to be displayed.
    private func prepareActionUrlButton() {
        actionUrlButton.setImage(UIImage(named: "linkIcon"), for: .normal)
        actionUrlButton.addTarget(self, action: #selector(actionUrlTapped), for: .touchUpInside)
        actionUrlButton.frame = CGRect(x: 0, y: 0, width: customButtonDimension, height: customButtonDimension)
        actionUrlButton.widthAnchor.constraint(equalToConstant: customButtonDimension).isActive = true
        actionUrlButton.heightAnchor.constraint(equalToConstant: customButtonDimension).isActive = true
        actionUrlButton.translatesAutoresizingMaskIntoConstraints = false
        actionUrlButton.accessibilityLabel = "External Website: " + (event.getActionUrl() ?? "")
        actionUrlButton.accessibilityTraits = .link
    }
    
    /// Prepares the details of this event to be displayed, including loading in all of the text, the associated image (if any), and adding small borders to various event-related views.
    private func prepareEventDetails() {
        eventDescriptionTextView.delegate = self
        
        eventTitleLabel.text = event.getName()
        eventDateTimeLabel.text = event.getFormattedDateAndTime()
        eventLocationLabel.text = event.getLocation()
        
        eventDescriptionTextView.attributedText = event.getDescription().htmlToAttributedString
        eventDescriptionTextView.font = .preferredFont(forTextStyle: .body)
        
        eventImageView.isHidden = true;
        if (event.getImageUrl() != nil) {
            loadImage()
        }
        
        eventTitleView.addBorders(edges: [.bottom], color: UIColor(.bluegrey), width: 1)
        eventDetailsView.addBorders(edges: [.top], color: UIColor(.bluegrey), width: 0.4)
    }
    
    /// Ensures the notification button displays the correct image (on/off).
    ///
    /// This function asks the SSSC notifications manager if there are any pending notifications for this particular event, and updates the notification button image to "On" if one is found associated to this event, and "Off" otherwise.
    private func updateNotifyMeButtonImage(notificationPending: Bool) {
        let notifyMeImage = UIImage(named: notificationPending ? "notifyOnColoured" : "notifyOff")
        DispatchQueue.main.async {
            self.notifyMeButton.setImage(notifyMeImage, for: .normal)
        }
    }
    
    /// Creates (or removes) a notification for this event when the notification button is tapped.
    ///
    /// This function first checks if the user has notification permissions enabled (and if not, prompts the user to enable them in the Settings app). It then removes any existing notifications for this event, or adds a new one if none are found.
    @objc private func notifyMeTapped() {
        notificationsManager.checkAuthorized { isAuthorized in
            guard isAuthorized else {
                let alert = UIAlertController(title: "Notification permissions required", message: "In order to be notified of events, we need you to grant notification permissions to this app in Settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                })
                self.present(alert, animated: true)
                return
            }
            
            self.notificationsManager.checkPendingNotifications(for: self.event, completion: { notificationPending in
                self.updateNotifyMeButtonImage(notificationPending: !notificationPending)
                if !notificationPending {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Notification enabled!", message: "You'll be sent a notification an hour before this event starts.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    self.createEventNotification()
                } else {
                    self.notificationsManager.removeNotifications(for: self.event)
                }
            })
        }
    }
    
    /// Delegates opening the actionUrl to the in-app browser when the action button is tapped.
    @objc private func actionUrlTapped() {
        openUrlInAppBrowser(url: URL(string: event.getActionUrl() ?? ""))
    }
    
    /// Creates a new event notification, updates the notification button image, and lets the user know that a notification has been prepared for this event.
    private func createEventNotification() {
        notificationsManager.createNotification(for: event, completion: { error in
            DispatchQueue.main.async {
                if error {
                    self.presentGenericErrorAlert()
                }
            }
        })
    }
    
    /// Generates a new notification request for this event.
    ///
    /// - Returns: The generated notification request.
    private func generateUNNotificationRequest() -> UNNotificationRequest? {
        var request: UNNotificationRequest? = nil
        let content = UNMutableNotificationContent()
        content.title = self.event.getName()
        content.subtitle = "Today at " + self.event.getFormattedTime()
        content.body = self.event.getLocation()
        content.sound = UNNotificationSound.default
        
        let notificationDateTime = self.event.getNotificationDateTime()
        if (notificationDateTime != nil) {
            if notificationDateTime!.compare(Date()) != ComparisonResult.orderedAscending {
                let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second,], from: notificationDateTime!)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                request = UNNotificationRequest(identifier: self.event.getId(), content: content, trigger: trigger)
            } else {
                print("Not setting notification due to time")
            }
        }
        return request
    }
    
    /// Generates and presents a generic error alert.
    private func presentGenericErrorAlert() {
        let alert = UIAlertController(title: "Something went wrong!", message: "Please try again later. If this issue persists, please let the SSSC know!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    /// Loads and displays any image associated with this event.
    ///
    /// This function loads an image by downloading it into a byte buffer and creating a UIImage object from there.
    private func loadImage() {
        if let url = event.getImageUrl() {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            self.eventImageView.image = image
                            let ratio = image.size.height / image.size.width
                            let newHeight = self.eventImageView.frame.size.width * ratio
                            self.eventImageView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
                            self.eventImageView.isHidden = false;
                        }
                    }
                }
            }
        }
    }
    
    /// Opens a provided URL in the in-app browser.
    ///
    /// - Parameter url: The URL to be opened.
    private func openUrlInAppBrowser(url: URL?) {
        if url != nil {
            let safariVC = SFSafariViewController(url: url!)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        openUrlInAppBrowser(url: URL)
        return false
    }

}
