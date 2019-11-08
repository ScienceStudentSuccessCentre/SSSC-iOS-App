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
    @IBOutlet weak var separatorWidthConstraint: NSLayoutConstraint!
    
    var mentor: Mentor?
    var loadedImage: UIImage?
    
    override func viewDidLoad() {
        scrollView.delegate = self
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.black.cgColor
        guard let mentor = mentor else { return }
        configure(mentor, loadedImage: loadedImage)
    }
    
    private func configure(_ mentor: Mentor, loadedImage: UIImage? = nil) {
        if let loadedImage = loadedImage {
            changeImage(to: loadedImage, animated: false)
        } else {
            loadImage(url: mentor.getImageUrl())
        }
        name.text = mentor.getName()
        degree.text = mentor.getDegree()
        team.text = mentor.getTeam()
        bio.attributedText = mentor.getBio().htmlToAttributedString
        bio.font = .preferredFont(forTextStyle: .body)
    }
    
    private func loadImage(url: URL?) {
        if let url = url {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.changeImage(to: UIImage(data: data))
                    }
                }
            }
        }
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
        separatorWidthConstraint.constant = team.intrinsicContentSize.width
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
