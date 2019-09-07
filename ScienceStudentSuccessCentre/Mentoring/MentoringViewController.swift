//
//  MentoringViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-09-04.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit
import SafariServices

class MentoringViewController: UIViewController {
    @IBOutlet var bookingButton: AnimatedButton!
    private let generator = UIImpactFeedbackGenerator()
    
    override func viewDidLoad() {
        prepareNavigationBarAppearance()
        bookingButton.backgroundColor = UIColor(.red)
        bookingButton.layer.cornerRadius = 10
        generator.prepare()
    }
    
    @IBAction func bookingButtonPressed() {
        generator.impactOccurred()
        guard let url = URL(string: "https://central.carleton.ca") else { return }
        let webpage = SSSCSafariViewController(url: url)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.present(webpage, animated: true)
        }
    }
}

class AnimatedButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            let transform: CGAffineTransform = isHighlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
            animate(transform)
        }
    }
    
    private func animate(_ transform: CGAffineTransform) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 3,
            options: [.curveEaseInOut],
            animations: {
                self.transform = transform
            }
        )
    }
}
