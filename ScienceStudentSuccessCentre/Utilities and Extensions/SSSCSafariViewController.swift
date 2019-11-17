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
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor(named: "primaryBackground")
        }
        
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
        helpButton.tintColor = UIColor(.lightblue)
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
            let toolbarHeight: CGFloat = 46.0 + view.safeAreaInsets.bottom
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
        let dismissAction = UIAlertAction(title: "Got it!", style: .default)
        presentAlert(kind: .ssscSafariHelp, actions: dismissAction)
    }
}
