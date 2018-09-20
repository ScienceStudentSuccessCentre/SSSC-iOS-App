//
//  EventDetailViewController.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-02-01.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit
import UserNotifications

class EventDetailViewController: UIViewController {
    
    let DEBUG_NOTIFICATION_TRIGGER = true
    
    var event: Event!
    let notifyMeDimension = CGFloat(integerLiteral: 30)
    let notifyMeButton = UIButton(type: .custom)
    var notifyMeImage = UIImage(named: "notifyOff")
    let notificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet var eventTitleLabel: UILabel!
    @IBOutlet var eventDescriptionTextView: UITextView!
    @IBOutlet var eventDateTimeLabel: UILabel!
    @IBOutlet var eventLocationLabel: UILabel!
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var eventStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        eventTitleLabel.text = event.name
        eventDateTimeLabel.text = event.month + " " + event.getDayString() + "\n" + event.time
        eventLocationLabel.text = event.location
        
        eventDescriptionTextView.attributedText = event.description.htmlToAttributedString
        eventDescriptionTextView.font = .preferredFont(forTextStyle: .body)
        
        if (event.imageUrl == "") {
            eventImageView.isHidden = true;
        } else {
            loadImage()
        }
        
        prepareNotifyMeButton()
        
        view.sendSubviewToBack(eventStackView)
    }
    
    private func prepareNotifyMeButton() {
        notifyMeButton.addTarget(self, action: #selector(notifyMeTapped), for: .touchUpInside)
        notifyMeButton.frame = CGRect(x: 0, y: 0, width: notifyMeDimension, height: notifyMeDimension)
        notifyMeButton.widthAnchor.constraint(equalToConstant: notifyMeDimension).isActive = true
        notifyMeButton.heightAnchor.constraint(equalToConstant: notifyMeDimension).isActive = true
        notifyMeButton.translatesAutoresizingMaskIntoConstraints = false
        
        updateNotifyMeImage()
        
        navigationItem.setRightBarButton(UIBarButtonItem(customView: notifyMeButton), animated: true)
    }
    
    private func updateNotifyMeImage() {
        let notifyMe = UserDefaults.standard.bool(forKey: event.id)
        if (notifyMe) {
            notifyMeImage = UIImage(named: "notifyOnColoured")
        } else {
            notifyMeImage = UIImage(named: "notifyOff")
        }
        notifyMeButton.setImage(notifyMeImage, for: .normal)
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
            
            let notifyMe = !UserDefaults.standard.bool(forKey: self.event.id)
            UserDefaults.standard.set(notifyMe, forKey: self.event.id)
            
            DispatchQueue.main.async {
                self.updateNotifyMeImage()
            }
            
            if (notifyMe) {
                let alert = UIAlertController(title: "Notification enabled!", message: "You'll be sent a notification on the day of this event.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
            print("Toggled notify for event \"\(self.event.name)\" to \(notifyMe)")
            
            let content = UNMutableNotificationContent()
            content.title = self.event.name
            content.body = "Today at " + self.event.time
            content.sound = UNNotificationSound.default
            
            if (self.DEBUG_NOTIFICATION_TRIGGER) {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                
                let request = UNNotificationRequest(identifier: self.event.id, content: content, trigger: trigger)
                self.notificationCenter.add(request, withCompletionHandler: { (error) in
                    if let error = error {
                        print(error)
                        self.presentGenericErrorAlert()
                    }
                })
            } else {
                let date = self.event.getDate()
                if (date != nil) {
                    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second,], from: date!)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: self.event.id, content: content, trigger: trigger)
                    self.notificationCenter.add(request, withCompletionHandler: { (error) in
                        if let error = error {
                            print(error)
                            self.presentGenericErrorAlert()
                        }
                    })
                } else {
                    self.presentGenericErrorAlert()
                }
            }
        }
    }
    
    private func presentGenericErrorAlert() {
        let alert = UIAlertController(title: "Something went wrong!", message: "Please try again later. If this issue persists, please let the SSSC know!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func loadImage() {
        let url = URL(string: event.imageUrl)
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
