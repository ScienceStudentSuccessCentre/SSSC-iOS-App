//
//  MentorCell.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-11-07.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

class MentorCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var degree: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func prepareForReuse() {
        name.text = nil
        degree.text = nil
        changeImage(to: nil, animated: false)
        imageView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = frame.width / 2
    }
    
    func configure(_ mentor: Mentor) {
        name.text = mentor.name
        degree.text = mentor.degree
        let initialTag = tag
        DispatchQueue.global().async {
            mentor.getImage().done { image in
                DispatchQueue.main.async {
                    if self.tag == initialTag {
                        self.changeImage(to: image)
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
}
