//
//  MentorDetailViewController.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-11-07.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

class MentorDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var degree: UILabel!
    @IBOutlet weak var team: UILabel!
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var bookingButton: UIButton!
    @IBOutlet weak var separatorWidthConstraint: NSLayoutConstraint!
    
    var mentor: Mentor?
    
    override func viewDidLoad() {
        scrollView.delegate = self
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.black.cgColor
        bookingButton.backgroundColor = UIColor(.red)
        bookingButton.setTitleColor(.white, for: .normal)
        bookingButton.layer.cornerRadius = 10
        bookingButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let mentor = mentor else { return }
        configure(mentor)
    }
    
    private func configure(_ mentor: Mentor) {
        DispatchQueue.global().async {
            mentor.getImage().done { image in
                DispatchQueue.main.async {
                    self.changeImage(to: image)
                }
            }
        }
        name.text = mentor.name
        degree.text = mentor.degree
        team.text = mentor.team
        bio.attributedText = mentor.bio.htmlToAttributedString
        bio.font = .preferredFont(forTextStyle: .body)
    }
    
    private func changeImage(to image: UIImage?, animated: Bool = true) {
        if animated {
            UIView.transition(with: imageView,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: {
                                if #available(iOS 13.0, *) {
                                    self.imageView.image = image ?? UIImage(systemName: "person.crop.circle")
                                } else {
                                    self.imageView.image = image
                                }
            })
        } else {
            if #available(iOS 13.0, *) {
                imageView.image = image ?? UIImage(systemName: "person.crop.circle")
            } else {
                imageView.image = image
            }
        }
    }
    
    @IBAction private func bookingButtonTapped() {
        guard let url = URL(string: "https://central.carleton.ca/") else { return }
        let webpage = SSSCSafariViewController(url: url)
        present(webpage, animated: true)
    }
    
    @IBAction private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let alignment: NSTextAlignment = traitCollection.horizontalSizeClass == .regular ? .left : .center
        name.textAlignment = alignment
        degree.textAlignment = alignment
        team.textAlignment = alignment
        imageView.layer.cornerRadius = imageView.frame.height / 2
        separatorWidthConstraint.constant = max(degree.intrinsicContentSize.width, team.intrinsicContentSize.width)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        view.setNeedsLayout()
    }
}

extension MentorDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (traitCollection.horizontalSizeClass == .compact ? 200 : 20) {
            UIView.animate(withDuration: 0.25) {
                self.closeButton.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.closeButton.alpha = 1
            }
        }
    }
}
