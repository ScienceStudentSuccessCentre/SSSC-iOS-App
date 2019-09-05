//
//  BookingViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-09-04.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import SafariServices
import UIKit

class SSSCSafariViewController: SFSafariViewController {
    private var helpButton: UIButton?
    private var backgroundView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = UIView()
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 5.0
        backgroundView.layer.borderWidth = 1.0 / UIScreen.main.nativeScale
        backgroundView.layer.borderColor = UIColor.lightGray.cgColor
        backgroundView.backgroundColor = .white
        view.insertSubview(backgroundView, at: 0)
        self.backgroundView = backgroundView
        
        let helpButton = UIButton(type: .system)
        helpButton.addTarget(self, action: #selector(helpButtonTapped), for: .touchUpInside)
        helpButton.setImage(UIImage(named: "questionMark"), for: .normal)
        view.insertSubview(helpButton, at: 0)
        self.helpButton = helpButton
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Always keep above other subviews. SFVC can be weird.
        if let backgroundView = backgroundView, let helpButton = helpButton {
            view.bringSubviewToFront(backgroundView)
            view.bringSubviewToFront(helpButton)
        }
        
        sizeAndPositionHelpButton()
    }
    
    private func sizeAndPositionHelpButton() {
        guard let backgroundView = backgroundView, let helpButton = helpButton else { return }
        
        let backgroundViewSize: CGFloat = 42.0
        let inset: CGFloat = 8.0
        
        // On iPhone 5 screens and smaller, even in landscape Safari View Controller keeps controls on bottom, but on 6 and higher everything moves to the top if in landscape
        if view.bounds.width <= 568.0 {
            let toolbarHeight: CGFloat = {
                if #available(iOS 11.0, *) {
                    return 46.0 + view.safeAreaInsets.bottom
                } else {
                    return 46.0
                }
            }()
            
            backgroundView.frame = CGRect(x: view.bounds.width - inset - backgroundViewSize,
                                            y: view.bounds.height - toolbarHeight - inset - backgroundViewSize,
                                            width: backgroundViewSize,
                                            height: backgroundViewSize)
        } else {
            backgroundView.frame = CGRect(x: view.bounds.width - inset - backgroundViewSize,
                                            y: view.bounds.height - inset - backgroundViewSize,
                                            width: backgroundViewSize,
                                            height: backgroundViewSize)
        }
        
        let helpButtonSize = backgroundViewSize + 20
        helpButton.frame = CGRect(x: 0.0, y: 0.0, width: helpButtonSize, height: helpButtonSize)
        helpButton.center = backgroundView.center
    }

    @objc private func helpButtonTapped() {
        let title = "Booking Appointments, Workshops, and Events"
        let message = """

1. Log onto Carleton Central using your myCarleton One credentials.

2. Scroll down to the mySuccess header and tap the last link, "Science Student Success Centre SSSC\", then tap \"Continue\".

3. Find and tap on \"Science Student Success Centre\".

4. Choose an option, and follow on-screen instructions from there!
"""
        
        let helpDialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        helpDialog.addAction(UIAlertAction(title: "Got it!", style: .default))
        present(helpDialog, animated: true)
    }
}
