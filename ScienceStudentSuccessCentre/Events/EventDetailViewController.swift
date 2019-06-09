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
    @IBOutlet var eventScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        eventDetailsView.isHidden = true
        eventImageView.isHidden = true;
        eventTitleView.addBorders(edges: [.bottom], color: UIColor(.bluegrey), width: 1)
        eventDetailsView.addBorders(edges: [.top], color: UIColor(.bluegrey), width: 0.4)
        
        view.sendSubviewToBack(eventStackView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let event = event {
            notificationCenter.checkPendingNotifications(for: event).done { notificationPending in
                self.updateNotifyMeButtonImage(notificationPending: notificationPending)
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
    private func prepareNavigationBarButtons() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        var barButtonItems: [UIBarButtonItem] = []
        
        if let event = event, !isPreview {
            if event.getUrl() != nil {
                barButtonItems.append(shareButton)
            }
            
            if event.getNotificationDateTime()!.compare(Date()) != ComparisonResult.orderedAscending {
                prepareNotifyMeButton()
                let notificationButton = UIBarButtonItem(customView: notifyMeButton)
                notificationButton.accessibilityIdentifier = "ToggleNotification"
                barButtonItems.append(notificationButton)
            }
            
            if !(event.getActionUrl() ?? "").isEmpty {
                prepareActionUrlButton()
                barButtonItems.append(UIBarButtonItem(customView: actionUrlButton))
            }
            
            navigationItem.setRightBarButtonItems(barButtonItems, animated: false)
        } else {
            navigationItem.setRightBarButtonItems([], animated: false)
        }
    }
    
    private func prepareNotifyMeButton() {
        let dimension = CGFloat(integerLiteral: 29)
        notifyMeButton.setImage(UIImage(named: "notifyOff"), for: .normal)
        notifyMeButton.addTarget(self, action: #selector(notifyMeTapped), for: .touchUpInside)
        notifyMeButton.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        notifyMeButton.widthAnchor.constraint(equalToConstant: dimension).isActive = true
        notifyMeButton.heightAnchor.constraint(equalToConstant: dimension).isActive = true
        notifyMeButton.translatesAutoresizingMaskIntoConstraints = false
        notifyMeButton.accessibilityLabel = "Notify Me"
        notifyMeButton.accessibilityTraits = .button
    }
    
    private func prepareActionUrlButton() {
        let dimension = CGFloat(integerLiteral: 30)
        actionUrlButton.setImage(UIImage(named: "linkIcon"), for: .normal)
        actionUrlButton.addTarget(self, action: #selector(actionUrlTapped), for: .touchUpInside)
        actionUrlButton.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        actionUrlButton.widthAnchor.constraint(equalToConstant: dimension).isActive = true
        actionUrlButton.heightAnchor.constraint(equalToConstant: dimension).isActive = true
        actionUrlButton.translatesAutoresizingMaskIntoConstraints = false
        actionUrlButton.accessibilityLabel = "External Website: " + (event?.getActionUrl() ?? "")
        actionUrlButton.accessibilityTraits = .link
    }
    
    /// Prepares the details of this event to be displayed, including loading in all of the text, the associated image (if any), and adding small borders to various event-related views.
    private func prepareEventDetails() {
        if let event = event {
            eventDetailsView.isHidden = false
            eventDescriptionTextView.delegate = self
            
            eventTitleLabel.text = event.getName()
            eventDateTimeLabel.text = event.getFormattedDateAndTime()
            eventLocationLabel.text = event.getLocation()
            
            eventDescriptionTextView.attributedText = event.getDescription().htmlToAttributedString
            eventDescriptionTextView.font = .preferredFont(forTextStyle: .body)
            
            if (event.getImageUrl() != nil) {
                loadImage()
            } else {
                self.eventImageView.isHidden = true
            }
        } else {
            eventDetailsView.isHidden = true
        }
    }
    
    private func updateNotifyMeButtonImage(notificationPending: Bool) {
        let notifyMeImage = UIImage(named: notificationPending ? "notifyOnColoured" : "notifyOff")
        DispatchQueue.main.async {
            self.notifyMeButton.setImage(notifyMeImage, for: .normal)
        }
    }
    
    @objc private func notifyMeTapped() {
        notificationCenter.checkAuthorized().done { isAuthorized in
            if isAuthorized {
                self.toggleNotificationEnabled()
            } else {
                // Prompt the user to allow notifications in settings
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
            }
        }.cauterize()
    }
    
    private func toggleNotificationEnabled() {
        notificationCenter.checkPendingNotifications(for: self.event!).done { notificationPending in
            let shouldEnableNotification = !notificationPending
            self.updateNotifyMeButtonImage(notificationPending: shouldEnableNotification)
            if shouldEnableNotification {
                self.createEventNotification()
            } else {
                self.notificationCenter.removeNotifications(for: self.event!)
            }
        }.cauterize()
    }
    
    /// Delegates opening the actionUrl to the in-app browser when the action button is tapped.
    @objc private func actionUrlTapped() {
        openUrlInAppBrowser(url: URL(string: event?.getActionUrl() ?? ""))
    }
    
    /// Opens a share sheet that allows the user to share the link to this event.
    @objc private func shareButtonTapped() {
        if let url = event?.getUrl()?.absoluteString {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if let popOver = activityVC.popoverPresentationController {
                popOver.barButtonItem = navigationItem.rightBarButtonItems?.first
            }
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    private func createEventNotification() {
        notificationCenter.createNotification(for: event!).done { success in
            DispatchQueue.main.async {
                let alert = success
                    ? UIAlertController(title: "Notification enabled!", message: "You'll be sent a notification an hour before this event starts.", preferredStyle: .alert)
                    : UIAlertController(title: "Something went wrong!", message: "Please try again later. If this issue persists, please let the SSSC know!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            if !success {
                self.updateNotifyMeButtonImage(notificationPending: false)
            }
        }.cauterize()
    }
    
    private func loadImage() {
        if let url = event?.getImageUrl() {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
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
