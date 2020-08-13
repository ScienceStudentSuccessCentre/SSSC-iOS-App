//
//  EventDetailViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-02-01.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import EventKit
import EventKitUI
import MessageUI
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
    
    var registrationType: EmailRegistrationType {
        guard let event = event else { fatalError("Tried to retrieve registrationType without event") }
        return .event(event: event)
    }
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private var actionUrlButton: UIBarButtonItem {
        let button: UIBarButtonItem
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(scale: .large)
            let image = UIImage(systemName: "link", withConfiguration: config)
            button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(actionUrlTapped))
        } else {
            let image = UIImage(named: "linkIcon")
            let customView = UIButton()
            let dimensions = CGSize(width: 30, height: 30)
            customView.widthAnchor.constraint(equalToConstant: dimensions.width).isActive = true
            customView.heightAnchor.constraint(equalToConstant: dimensions.height).isActive = true
            customView.translatesAutoresizingMaskIntoConstraints = false
            customView.setImage(image, for: .normal)
            customView.frame = CGRect(x: 0, y: 0, width: dimensions.width, height: dimensions.height)
            customView.addTarget(self, action: #selector(actionUrlTapped), for: .touchUpInside)
            button = UIBarButtonItem(customView: customView)
        }
        button.accessibilityLabel = "External Website: " + (event?.actionUrl ?? "")
        button.accessibilityTraits = .link
        return button
    }
    
    private var emailRegistrationButton: UIBarButtonItem {
        let button: UIBarButtonItem
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(scale: .large)
            let image = UIImage(systemName: "square.and.pencil", withConfiguration: config)
            button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(emailRegistrationTapped))
        } else {
            let image = UIImage(named: "registerIcon")
            let customView = UIButton()
            let dimensions = CGSize(width: 31, height: 31)
            customView.widthAnchor.constraint(equalToConstant: dimensions.width).isActive = true
            customView.heightAnchor.constraint(equalToConstant: dimensions.height).isActive = true
            customView.translatesAutoresizingMaskIntoConstraints = false
            customView.setImage(image, for: .normal)
            customView.frame = CGRect(x: 0, y: 0, width: dimensions.width, height: dimensions.height)
            customView.addTarget(self, action: #selector(emailRegistrationTapped), for: .touchUpInside)
            button = UIBarButtonItem(customView: customView)
        }
        button.accessibilityLabel = "Register"
        return button
    }
    
    private var shareButton: UIBarButtonItem {
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(scale: .large)
            let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: config)
            return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(shareButtonTapped))
        } else {
            return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        }
    }
    
    private func notificationButton(notificationPending: Bool) -> UIBarButtonItem {
        let button: UIBarButtonItem
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(scale: .large)
            let image = UIImage(systemName: notificationPending ? "bell.fill" : "bell", withConfiguration: config)
            button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(notifyMeTapped))
            button.tintColor = notificationPending ? UIColor(.amber) : button.tintColor
        } else {
            let image = UIImage(named: notificationPending ? "notifyOn" : "notifyOff")
            let customView = UIButton()
            let dimensions = CGSize(width: 29, height: 29)
            customView.widthAnchor.constraint(equalToConstant: dimensions.width).isActive = true
            customView.heightAnchor.constraint(equalToConstant: dimensions.height).isActive = true
            customView.translatesAutoresizingMaskIntoConstraints = false
            customView.setImage(image, for: .normal)
            customView.frame = CGRect(x: 0, y: 0, width: dimensions.width, height: dimensions.height)
            customView.addTarget(self, action: #selector(notifyMeTapped), for: .touchUpInside)
            customView.accessibilityLabel = "Notify Me"
            customView.accessibilityTraits = .button
            button = UIBarButtonItem(customView: customView)
        }
        button.accessibilityIdentifier = "ToggleNotification"
        return button
    }
    
    private var addToCalendarButton: UIBarButtonItem {
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(scale: .large)
            let image = UIImage(systemName: "calendar.badge.plus", withConfiguration: config)
            return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addToCalendarButtonTapped))
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
    /// - If there is an action associated to the event being displayed, the action button is displayed. If that action involves Carleton Central, the email registration button is displayed instead.
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
            switch event.actionUrl {
            case nil, "":
                break
            case let url where url!.contains("central.carleton.ca"):
                if Features.shared.enableEmailEventRegistration && MFMailComposeViewController.canSendMail() {
                    barButtonItems.append(emailRegistrationButton)
                } else {
                    fallthrough
                }
            default:
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
    
    /// Begins the email registration flow for this event.
    @objc private func emailRegistrationTapped() {
        guard event != nil else { return }
        register(fallback: actionUrlTapped)
    }
    
    /// Opens a share sheet that allows the user to share the link to this event.
    @objc private func shareButtonTapped() {
        guard let url = event?.eventUrl?.absoluteString else { return }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let popOver = activityVC.popoverPresentationController {
            popOver.barButtonItem = navigationItem.rightBarButtonItems?.first
        }
        self.present(activityVC, animated: true)
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
        guard let url = event?.imageUrl else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else { return }
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

extension EventDetailViewController: EmailRegistrationController, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            let title: String?
            let message: String?
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
            
            switch result {
            case .sent:
                title = "Thanks for registering!"
                message = "Check out the other buttons along the top to add this event to your calendar or request a notification an hour before the event."
            case .saved:
                title = "Almost Done!"
                message = "To finish registering, check your Drafts folder and send the email addressed to sssc@carleton.ca."
            case .failed:
                self.presentAlert(kind: .genericError, actions: dismissAction)
                return
            default:
                return
            }
            let dismissedMailAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            dismissedMailAlert.addAction(dismissAction)
            self.present(dismissedMailAlert, animated: true)
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
