//
//  MentorSearchCell.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-11-07.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

class MentorSearchCell: UITableViewCell {
    @IBOutlet weak var mentorImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var degree: UILabel!
    @IBOutlet weak var team: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mentorImageView.layer.masksToBounds = true
        mentorImageView.layer.borderWidth = 3
        mentorImageView.layer.borderColor = UIColor.black.cgColor
        backgroundColor = UIColor(named: "primaryBackground")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = nil
        degree.text = nil
        team.text = nil
        changeImage(to: nil, animated: false)
        mentorImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    func configure(with mentor: Mentor) {
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mentorImageView.layer.cornerRadius = mentorImageView.frame.width / 2
    }
    
    private func changeImage(to image: UIImage?, animated: Bool = true) {
        if animated {
            UIView.transition(with: mentorImageView,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: {
                                if #available(iOS 13.0, *) {
                                    self.mentorImageView.image = image ?? UIImage(systemName: "person.crop.circle")
                                } else {
                                    self.mentorImageView.image = image
                                }
            })
        } else {
            if #available(iOS 13.0, *) {
                mentorImageView.image = image ?? UIImage(systemName: "person.crop.circle")
            } else {
                mentorImageView.image = image
            }
        }
    }
}
