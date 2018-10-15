//
//  EventDetailViewController.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-02-01.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import SafariServices
import UserNotifications

class EventDetailViewController: UIViewController, UITextViewDelegate {
    
    var event: Event!
    let notifyMeDimension = CGFloat(integerLiteral: 30)
    let notifyMeButton = UIButton(type: .custom)
    var notifyMeImage = UIImage(named: "notifyOff")
    let notificationCenter = UNUserNotificationCenter.current()
    var actionUrlButton: UIBarButtonItem!
    
    @IBOutlet var eventTitleLabel: UILabel!
    @IBOutlet var eventDescriptionTextView: UITextView!
    @IBOutlet var eventDateTimeLabel: UILabel!
    @IBOutlet var eventLocationLabel: UILabel!
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var eventStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventDescriptionTextView.delegate = self

        eventTitleLabel.text = event.getName()
        eventDateTimeLabel.text = event.getMonthName() + " " + event.getDayLeadingZero() + "\n" + event.getRawTime()
        eventLocationLabel.text = event.getLocation()
        
        eventDescriptionTextView.attributedText = event.getDescription().htmlToAttributedString
        eventDescriptionTextView.font = .preferredFont(forTextStyle: .body)
        
        if (event.getImageUrl() == nil) {
            eventImageView.isHidden = true;
        } else {
            loadImage()
        }
        
        prepareNotifyMeButton()
        
        actionUrlButton =  UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.reply, target: self, action: #selector(actionUrlTapped))
        
        var barButtonItems: [UIBarButtonItem] = []
        if event.getNotificationDateTime()!.compare(Date()) != ComparisonResult.orderedAscending {
            barButtonItems.append(UIBarButtonItem(customView: notifyMeButton))
        }
        if event.getActionUrl() != "" {
            barButtonItems.append(actionUrlButton)
        }
    
        navigationItem.setRightBarButtonItems(barButtonItems, animated: true)
        
        view.sendSubviewToBack(eventStackView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNotifyMeImage()
    }
    
    private func prepareNotifyMeButton() {
        if event.getNotificationDateTime()!.compare(Date()) != ComparisonResult.orderedAscending {
            notifyMeButton.addTarget(self, action: #selector(notifyMeTapped), for: .touchUpInside)
            notifyMeButton.frame = CGRect(x: 0, y: 0, width: notifyMeDimension, height: notifyMeDimension)
            notifyMeButton.widthAnchor.constraint(equalToConstant: notifyMeDimension).isActive = true
            notifyMeButton.heightAnchor.constraint(equalToConstant: notifyMeDimension).isActive = true
            notifyMeButton.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func updateNotifyMeImage() {
        notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
            var notifyMe = false
            for request in requests {
                if request.identifier == self.event.getId() {
                    notifyMe = true
                    break
                }
            }
            if notifyMe {
                self.notifyMeImage = UIImage(named: "notifyOnColoured")
            } else {
                self.notifyMeImage = UIImage(named: "notifyOff")
            }
            
            DispatchQueue.main.async {
                self.notifyMeButton.setImage(self.notifyMeImage, for: .normal)
            }
        })
    }
    
    @objc private func notifyMeTapped() {
        notificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else {
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
            
            self.notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
                var notifyMeEnabled = false
                for request in requests {
                    if request.identifier == self.event.getId() {
                        notifyMeEnabled = true
                        break
                    }
                }
                if !notifyMeEnabled {
                    self.prepareDeviceNotification()
                } else {
                    self.removeDeviceNotification()
                }
            })
        }
    }
    
    @objc private func actionUrlTapped() {
        let safariVC = SFSafariViewController(url: URL(string: event.getActionUrl()!)!)
        present (safariVC, animated: true, completion:nil)
    }
    
    private func prepareDeviceNotification() {
        let request = generateUNNotificationRequest()
        if (request != nil) {
            self.notificationCenter.add(request!, withCompletionHandler: { (error) in
                if let error = error {
                    print(error)
                    self.presentGenericErrorAlert()
                } else {
                    self.updateNotifyMeImage()
                    
                    let alert = UIAlertController(title: "Notification enabled!", message: "You'll be sent a notification an hour before this event starts.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            })
        }
    }
    
    private func removeDeviceNotification() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [self.event.getId()])
        self.updateNotifyMeImage()
    }
    
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
    
    private func presentGenericErrorAlert() {
        let alert = UIAlertController(title: "Something went wrong!", message: "Please try again later. If this issue persists, please let the SSSC know!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func loadImage() {
        let url = event.getImageUrl()
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                
                if (image != nil) {
                    self.eventImageView.image = image
                    
                    let ratio = image!.size.height / image!.size.width
                    let newHeight = self.eventImageView.frame.size.width * ratio
                    
                    self.eventImageView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
                }
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let safariVC = SFSafariViewController(url: URL)
        present(safariVC, animated: true, completion: nil)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
