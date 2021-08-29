//
//  EmailRegistrationController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2020-08-12.
//  Copyright © 2020 Avery Vine. All rights reserved.
//

import Foundation
import MessageUI
import UIKit

enum EmailRegistrationType {
    case event(event: Event)
    case mentoring(mentor: Mentor?)
}

protocol EmailRegistrationController: UIViewController, MFMailComposeViewControllerDelegate {
    var registrationType: EmailRegistrationType { get }
    
    func register(fallback: (() -> Void)?)
}

extension EmailRegistrationController {
    /// Prompt the user for personal info (or verify it if they have already provided it), then present a new email.
    ///
    /// - Warning: If you override this method, do not forget to call `MFMailComposeViewController.canSendMail()` first!
    func register(fallback: (() -> Void)? = nil) {
        guard MFMailComposeViewController.canSendMail() else {
            fallback?()
            return
        }
        
        if let studentInfo = StudentInfo() {
            verifyPersonalInfo(studentInfo)
        } else {
            promptForPersonalInfo()
        }
    }
    
    private func verifyPersonalInfo(_ studentInfo: StudentInfo) {
        let confirmPersonalInfoAlert = UIAlertController(
            title: "Is this information correct?",
            message: "\nFull Name: \(studentInfo.name)\nStudent Number: \(studentInfo.number)\nCarleton Email: \(studentInfo.email)",
            preferredStyle: .alert
        )
        confirmPersonalInfoAlert.addAction(UIAlertAction(title: "Yes, Register!", style: .default, handler: { _ in
            self.openEmailRegistration(studentInfo: studentInfo)
        }))
        confirmPersonalInfoAlert.addAction(UIAlertAction(title: "No, Change It", style: .default, handler: { _ in
            self.promptForPersonalInfo()
        }))
        confirmPersonalInfoAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(confirmPersonalInfoAlert, animated: true)
    }
    
    private func promptForPersonalInfo() {
        let prompt = UIAlertController(title: "Before Registering…", message: "Tell us a bit about yourself.", preferredStyle: .alert)
        prompt.addAction(UIAlertAction(title: "Cancel", style: .default))
        prompt.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            guard prompt.textFields?.count == 3,
                let studentName = prompt.textFields?[0].text,
                let studentNumberString = prompt.textFields?[1].text,
                let studentNumber = Int(studentNumberString),
                let studentEmail = prompt.textFields?[2].text else {
                    return
            }
            let studentInfo = StudentInfo(name: studentName, number: studentNumber, email: studentEmail)
            self.openEmailRegistration(studentInfo: studentInfo)
        }))
        prompt.addTextField(placeholder: "Full Name", capitalization: .words)
        prompt.addTextField(placeholder: "Student Number", keyboardType: .numberPad)
        prompt.addTextField(placeholder: "Carleton Email", keyboardType: .emailAddress)
        
        // This applies a styling fix to the text fields. Without this, the middle text field is missing left and right borders (???)
        prompt.textFields?.forEach { $0.superview?.superview?.subviews[0].removeFromSuperview() }
        
        present(prompt, animated: true)
    }
    
    private func openEmailRegistration(studentInfo: StudentInfo) {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["sssc@carleton.ca"])
        
        let subject: String
        let message: String
        switch registrationType {
        case .event(event: let event):
            subject = "Registration for \(event.name)"
            message = "<p>I would like to register for <i>\(event.name)</i> on \(event.monthName) \(event.dayLeadingZero).</p>"
        case .mentoring(mentor: let mentor):
            if let mentor = mentor {
                subject = "Registration for Mentoring Session with \(mentor.name)"
                message = "<p>I would like to register for a mentoring session with \(mentor.name) What is their availability?</p>"
            } else {
                subject = "Registration for Mentoring Session"
                message = "<p>I would like to register for a mentoring session. Which mentors are available?</p>"
            }
        }
        
        let combinedBody = """
        <p>Hello,</p>
        \(message)
        <ul>
        <li>Full Name: \(studentInfo.name)</li>
        <li>Student Number: \(studentInfo.number)</li>
        <li>Carleton Email: \(studentInfo.email)</li>
        </ul>
        <p>Thank you!</p>
        """
        
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(combinedBody, isHTML: true)
        if #available(iOS 13.0, *) {
            mailComposer.isModalInPresentation = true
        }
        present(mailComposer, animated: true)
    }
}

fileprivate extension UIAlertController {
    func addTextField(placeholder: String? = nil,
                      keyboardType: UIKeyboardType = .default,
                      capitalization: UITextAutocapitalizationType = .sentences) {
        addTextField(configurationHandler: { textField in
            textField.placeholder = placeholder
            textField.keyboardType = keyboardType
            textField.autocapitalizationType = capitalization
        })
    }
}
