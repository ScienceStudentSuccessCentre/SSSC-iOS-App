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
            message: "\nStudent Name: \(studentInfo.name)\nStudent Number: \(studentInfo.number)\nDegree: \(studentInfo.degree)",
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
        let namePrompt = UIAlertController(title: "What is your full name?", message: nil, preferredStyle: .alert)
        let numberPrompt = UIAlertController(title: "What is your student number?", message: nil, preferredStyle: .alert)
        let degreePrompt = UIAlertController(title: "What is your degree?", message: nil, preferredStyle: .alert)
        
        presentPrompt(namePrompt, capitalization: .words) { _ in
            guard let studentName = namePrompt.textFields?.first?.text else { return }
            self.presentPrompt(numberPrompt, keyboardType: .numberPad) { _ in
                guard let studentNumberString = numberPrompt.textFields?.first?.text, let studentNumber = Int(studentNumberString) else { return }
                self.presentPrompt(degreePrompt, capitalization: .words) { _ in
                    guard let degree = degreePrompt.textFields?.first?.text else { return }
                    let studentInfo = StudentInfo(name: studentName, number: studentNumber, degree: degree)
                    self.openEmailRegistration(studentInfo: studentInfo)
                }
            }
        }
    }
    
    /// A "prompt" in this case is a `UIAlertController` with two actions of type `UIAlertAction`; one for continuing, and one for cancelling.
    private func presentPrompt(_ prompt: UIAlertController,
                               keyboardType: UIKeyboardType = .default,
                               capitalization: UITextAutocapitalizationType = .sentences,
                               continueAction: ((UIAlertAction) -> Void)?) {
        prompt.addAction(UIAlertAction(title: "Continue", style: .default, handler: continueAction))
        prompt.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        prompt.addTextField(configurationHandler: { textField in
            textField.keyboardType = keyboardType
            textField.autocapitalizationType = capitalization
        })
        present(prompt, animated: true)
    }
    
    private func openEmailRegistration(studentInfo: StudentInfo) {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["sssc@carleton.ca"])
        
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
        <li>Name: \(studentInfo.name)</li>
        <li>Student Number: \(studentInfo.number)</li>
        <li>Degree: \(studentInfo.degree)</li>
        </ul>
        <p>Thank you!</p>
        """
        
        mail.setSubject(subject)
        mail.setMessageBody(combinedBody, isHTML: true)
        if #available(iOS 13.0, *) {
            mail.isModalInPresentation = true
        }
        present(mail, animated: true)
    }
}
