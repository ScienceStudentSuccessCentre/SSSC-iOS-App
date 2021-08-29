//
//  UIViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-06-11.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

extension UIViewController {
    enum AlertKind {
        case genericError
        case offlineError
        case eventsError
        case mentorsError
        case exportError
        case importError
        case importSuccess
        case calendarPermissionsRequired
        case notificationPermissionsRequired
        case notificationEnabled
        case couldNotModifyWeights
        case ssscSafariHelp
    }
    
    func presentAlert(kind: AlertKind, actions: UIAlertAction...) {
        let title: String
        let message: String
        switch kind {
        case .genericError:
            title = "Something went wrong!"
            message = "Please try again later. If the issue persists, contact the SSSC so we can fix the problem as soon as possible."
        case .offlineError:
            title = "No connection!"
            message = "It looks like you might be offline! Please try again once you have an internet connection."
        case .eventsError:
            title = "Couldn't load events!"
            // swiftlint:disable:next line_length
            message = "Something went wrong when trying to load the SSSC's events. If the issue persists, contact the SSSC so we can fix the problem as soon as possible."
        case .mentorsError:
            title = "Couldn't load mentors!"
            // swiftlint:disable:next line_length
            message = "Something went wrong when trying to load the SSSC's mentors. If the issue persists, contact the SSSC so we can fix the problem as soon as possible."
        case .exportError:
            title = "Failed to export!"
            message = "Your grade data was unable to be exported. Please try again!"
        case .importError:
            title = "Failed to import data!"
            // swiftlint:disable:next line_length
            message = "Your grades data was not imported. Please make sure the file you are trying to import is not modified in any way from what was originally exported from the app!"
        case .importSuccess:
            title = "Successfully imported data!"
            message = "Your grades data was successfully imported."
        case .calendarPermissionsRequired:
            title = "Calendar permissions required"
            message = "In order to add events to your calendar, we need you to grant calendar permissions to this app in Settings."
        case .notificationPermissionsRequired:
            title = "Notification permissions required"
            message = "In order to be notified of events, we need you to grant notification permissions to this app in Settings."
        case .notificationEnabled:
            title = "Notification enabled!"
            message = "You'll be sent a notification an hour before this event starts."
        case .couldNotModifyWeights:
            title = "Can't modify weights!"
            message = "Please modify or delete all assignments that are marked with the weights you are trying to delete. All other course modifications were saved."
        case .ssscSafariHelp:
            title = "Booking Appointments, Workshops, and Events"
            message = """

            1. Log onto Carleton Central using your myCarleton One credentials.

            2. Scroll down to the mySuccess header and tap the last link, "Science Student Success Centre SSSC\", then tap \"Continue\".

            3. Find and tap on \"Science Student Success Centre\".

            4. Choose an option, and follow on-screen instructions from there!

            If you want to book with a specific mentor, make sure to choose "Book by Appointment Provider" when given the option.
            """
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.count == 0 {
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        } else {
            for action in actions {
                alert.addAction(action)
            }
        }
        present(alert, animated: true)
    }
    
    func prepareNavigationBarAppearance(barTintColour: UIColor = UIColor(.steelblue)) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = barTintColour
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = barTintColour
        }
        navigationController?.view.backgroundColor = UIColor(.lightgrey)
    }
}
