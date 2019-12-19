//
//  EventDetailViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-02-01.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import EventKit
import EventKitUI
import SafariServices
import UIKit
import UserNotifications

class EventDetailViewController: UIViewController {
    @IBOutlet var eventTitleLabel: UILabel!
    @IBOutlet var eventTitleView: UIView!
    @IBOutlet var eventDescriptionTextView: UITextView!
    @IBOutlet var eventDetailsView: UIView!
    @IBOutlet var eventDateTimeLabel: UILabel!
    @IBOutlet var eventLocationLabel: UILabel!
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var eventStackView: UIStackView!
    @IBOutlet var eventScrollView: UIScrollView!
    
    var event: Event? {
        didSet {
            refreshUI()
        }
    }
    var isPreview: Bool = false {
        didSet {
            prepareNavigationBarButtons()
        }
    }
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private var actionUrlButton: UIBarButtonItem {
        let customView = UIButton()
        let width: CGFloat
        let height: CGFloat
        let image: UIImage?
        
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(scale: .large)
            image = UIImage(systemName: "link", withConfiguration: config)
            width = (image?.size.width ?? 0) + 3
            height = image?.size.height ?? 0
        } else {
            image = UIImage(named: "linkIcon")
            width = 30
            height = 30
            
            customView.widthAnchor.constraint(equalToConstant: width).isActive = true
            customView.heightAnchor.constraint(equalToConstant: height).isActive = true
            customView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        customView.setImage(image, for: .normal)
        customView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        customView.addTarget(self, action: #selector(actionUrlTapped), for: .touchUpInside)
        customView.accessibilityLabel = "External Website: " + (event?.actionUrl ?? "")
        customView.accessibilityTraits = .link
        return UIBarButtonItem(customView: customView)
    }
    
    private var shareButton: UIBarButtonItem {
        if #available(iOS 13.0, *) {
            let customView = UIButton()
            let config = UIImage.SymbolConfiguration(scale: .large)
            let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: config)
            customView.setImage(image, for: .normal)
            customView.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
            customView.frame = CGRect(x: 0, y: 0, width: (image?.size.width ?? 0) + 8, height: image?.size.height ?? 0)
            customView.accessibilityLabel = "Share"
            customView.accessibilityTraits = .button
            return UIBarButtonItem(customView: customView)
        } else {
            return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        }
    }
    
    private func notificationButton(notificationPending: Bool) -> UIBarButtonItem {
        let customView = UIButton()
        let width: CGFloat
        let height: CGFloat
        let image: UIImage?
        
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(scale: .large)
            image = UIImage(systemName: notificationPending ? "bell.fill" : "bell", withConfiguration: config)
            width = (image?.size.width ?? 0) + 8
            height = image?.size.height ?? 0
            if notificationPending {
                customView.tintColor = UIColor(.amber)
            }
        } else {
            image = UIImage(named: notificationPending ? "notifyOn" : "notifyOff")
            width = 29
            height = 29
            
            customView.widthAnchor.constraint(equalToConstant: width).isActive = true
            customView.heightAnchor.constraint(equalToConstant: height).isActive = true
            customView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        customView.setImage(image, for: .normal)
        customView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        customView.addTarget(self, action: #selector(notifyMeTapped), for: .touchUpInside)
        customView.accessibilityLabel = "Notify Me"
        customView.accessibilityTraits = .button
        let button = UIBarButtonItem(customView: customView)
        button.accessibilityIdentifier = "ToggleNotification"
        return button
    }
    
    private var addToCalendarButton: UIBarButtonItem {
        if #available(iOS 13.0, *) {
            let customView = UIButton()
            let config = UIImage.SymbolConfiguration(scale: .large)
            let image = UIImage(systemName: "calendar.badge.plus", withConfiguration: config)
            customView.setImage(image, for: .normal)
            customView.addTarget(self, action: #selector(addToCalendarButtonTapped), for: .touchUpInside)
            customView.frame = CGRect(x: 0, y: 0, width: (image?.size.width ?? 0) + 8, height: image?.size.height ?? 0)
            customView.accessibilityLabel = "Add to Calendar"
            customView.accessibilityTraits = .button
            return UIBarButtonItem(customView: customView)
        } else {
            return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToCalendarButtonTapped))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        eventDetailsView.isHidden = true
        eventImageView.isHidden = true
        eventTitleView.addBorders(edges: [.bottom], color: UIColor(.bluegrey), width: 1)
        eventDetailsView.addBorders(edges: [.top], color: UIColor(.bluegrey), width: 0.4)
        
        view.sendSubviewToBack(eventStackView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareNavigationBarAppearance()
        
        if let event = event {
            notificationCenter.checkPendingNotifications(for: event).done { notificationPending in
                self.prepareNavigationBarButtons(notificationPending: notificationPending)
            }.cauterize()
        }
    }
    
    func refreshUI() {
        loadViewIfNeeded()
        prepareEventDetails()
        prepareNavigationBarButtons()
    }
    
    /// Determines which buttons (action, notification, share) should be added to the navigation bar, if any.
    ///
    /// - If there is an action associated to the event being displayed, the action button is displayed.
    /// - If the notification date/time for this event has not passed, the notification button is displayed.
    /// - If arriving from peek and pop (i.e. `isPreview == true`), no buttons are shown
    private func prepareNavigationBarButtons(notificationPending: Bool = false) {
        var barButtonItems: [UIBarButtonItem] = []
        if let event = event, !isPreview {
            if event.eventUrl != nil {
                barButtonItems.append(shareButton)
            }
            if event.notificationDateTime!.compare(Date()) != ComparisonResult.orderedAscending {
                barButtonItems.append(notificationButton(notificationPending: notificationPending))
            }
            if !(event.actionUrl ?? "").isEmpty {
                barButtonItems.append(actionUrlButton)
            }
            barButtonItems.append(addToCalendarButton)
            navigationItem.setRightBarButtonItems(barButtonItems, animated: false)
        } else {
            navigationItem.setRightBarButtonItems([], animated: false)
        }
    }
    
    /// Prepares the details of this event to be displayed, including loading in all of the text, the associated image (if any), and adding small borders to various event-related views.
    private func prepareEventDetails() {
        if let event = event {
            eventDetailsView.isHidden = false
            eventDescriptionTextView.delegate = self
            
            eventTitleLabel.text = event.name
            eventDateTimeLabel.text = event.formattedDateAndTime
            eventLocationLabel.text = event.location
            
            eventDescriptionTextView.attributedText = event.description.htmlToAttributedString
            eventDescriptionTextView.font = .preferredFont(forTextStyle: .body)
            
            if event.imageUrl != nil {
                loadImage()
            } else {
                self.eventImageView.isHidden = true
            }
        } else {
            eventDetailsView.isHidden = true
        }
    }
    
    @objc private func notifyMeTapped() {
        notificationCenter.checkAuthorized().done { isAuthorized in
            if isAuthorized {
                self.toggleNotificationEnabled()
            } else {
                // Prompt the user to allow notifications in settings
                let closeAction = UIAlertAction(title: "Close", style: .cancel)
                let openSettingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) else { return }
                    UIApplication.shared.open(settingsUrl) { success in
                        print("Settings opened: \(success)")
                    }
                }
                self.presentAlert(kind: .notificationPermissionsRequired, actions: closeAction, openSettingsAction)
            }
        }.cauterize()
    }
    
    private func toggleNotificationEnabled() {
        notificationCenter.checkPendingNotifications(for: self.event!).done { notificationPending in
            let shouldEnableNotification = !notificationPending
            self.prepareNavigationBarButtons(notificationPending: shouldEnableNotification)
            if shouldEnableNotification {
                self.createEventNotification()
            } else {
                self.notificationCenter.removeNotifications(for: self.event!)
            }
        }.cauterize()
    }
    
    /// Delegates opening the actionUrl to the in-app browser when the action button is tapped.
    @objc private func actionUrlTapped() {
        openUrlInAppBrowser(url: URL(string: event?.actionUrl ?? ""))
    }
    
    /// Opens a share sheet that allows the user to share the link to this event.
    @objc private func shareButtonTapped() {
        if let url = event?.eventUrl?.absoluteString {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if let popOver = activityVC.popoverPresentationController {
                popOver.barButtonItem = navigationItem.rightBarButtonItems?.first
            }
            self.present(activityVC, animated: true)
        }
    }
    
    /// Creates a new calendar event for this event.
    @objc private func addToCalendarButtonTapped() {
        guard let event = event else { return }
        
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed to save event: \(error!)")
                    self.presentAlert(kind: .genericError)
                    return
                }
                guard granted else {
                    // Prompt the user to allow calendar access in settings
                    let closeAction = UIAlertAction(title: "Close", style: .cancel)
                    let openSettingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) else { return }
                        UIApplication.shared.open(settingsUrl) { success in
                            print("Settings opened: \(success)")
                        }
                    }
                    self.presentAlert(kind: .calendarPermissionsRequired, actions: closeAction, openSettingsAction)
                    return
                }
                
                let calendarEvent = EKEvent(eventStore: eventStore)
                calendarEvent.title = event.name
                calendarEvent.startDate = event.dateTime
                calendarEvent.endDate = event.endDateTime
                calendarEvent.location = event.location
                calendarEvent.url = event.eventUrl
                calendarEvent.notes = event.description
                
                let controller = EKEventEditViewController()
                controller.event = calendarEvent
                controller.eventStore = eventStore
                controller.editViewDelegate = self
                self.present(controller, animated: true)
            }
        }
    }
    
    private func createEventNotification() {
        notificationCenter.createNotification(for: event!).done { success in
            DispatchQueue.main.async {
                self.presentAlert(kind: success ? .notificationEnabled : .genericError)
            }
            if !success {
                self.prepareNavigationBarButtons(notificationPending: false)
            }
        }.cauterize()
    }
    
    private func loadImage() {
        if let url = event?.imageUrl {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.eventImageView.image = image
                            let ratio = image.size.height / image.size.width
                            let newHeight = self.eventImageView.frame.size.width * ratio
                            self.eventImageView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
                            self.eventImageView.isHidden = false
                        }
                    }
                }
            }
        }
    }
}

extension EventDetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        openUrlInAppBrowser(url: URL)
        return false
    }
    
    private func openUrlInAppBrowser(url: URL?) {
        guard let url = url else { return }
        let safariVC = SSSCSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

extension EventDetailViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true)
    }
}
