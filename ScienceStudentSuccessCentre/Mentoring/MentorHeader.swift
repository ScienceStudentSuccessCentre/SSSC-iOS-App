//
//  MentorHeader.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-11-07.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import SafariServices
import UIKit

protocol BookingDelegate: AnyObject {
    func bookingButtonTapped()
}

class MentorHeader: UICollectionReusableView {
    @IBOutlet weak var bookingButton: AnimatedButton!
    weak var bookingDelegate: BookingDelegate?
    private let generator = UIImpactFeedbackGenerator()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bookingButton.backgroundColor = UIColor(.red)
        bookingButton.setTitleColor(.white, for: .normal)
        bookingButton.layer.cornerRadius = 10
        bookingButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        generator.prepare()
    }
    
    var height: CGFloat {
        return bookingButton.intrinsicContentSize.height + 56
    }
    
    @IBAction private func bookingButtonPressed() {
        generator.impactOccurred()
        bookingDelegate?.bookingButtonTapped()
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
