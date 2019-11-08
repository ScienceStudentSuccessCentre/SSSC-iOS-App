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
    var loadedImage = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
        name.text = mentor.getName()
        degree.text = mentor.getDegree()
        loadImage(url: mentor.getImageUrl())
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
                                self.loadedImage = image != nil
            })
        } else {
            if #available(iOS 13.0, *) {
                imageView.image = image ?? UIImage(systemName: "person.crop.circle")
            } else {
                imageView.image = image
            }
            loadedImage = image != nil
        }
    }
}
