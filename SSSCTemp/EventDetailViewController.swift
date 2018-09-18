//
//  EventDetailViewController.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-02-01.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    var event: Event!
    
    @IBOutlet var eventTitleLabel: UILabel!
    @IBOutlet var eventDescriptionTextView: UITextView!
    @IBOutlet var eventDateTimeLabel: UILabel!
    @IBOutlet var eventLocationLabel: UILabel!
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var eventStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        eventTitleLabel.text = event.name
        eventDateTimeLabel.text = event.month + " " + event.getDayString() + "\n" + event.time
        eventLocationLabel.text = event.location
        
        eventDescriptionTextView.attributedText = event.description.htmlToAttributedString
//        eventDescriptionTextView.font = UIFont.systemFont(ofSize: 16)
        eventDescriptionTextView.font = .preferredFont(forTextStyle: .body)
        
        view.sendSubviewToBack(eventStackView)
        
        if (event.imageUrl == "") {
            eventImageView.isHidden = true;
        } else {
            let url = URL(string: event.imageUrl)
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    
                    if (image != nil) {
                        self.eventImageView.image = image
                        
                        let ratio = image!.size.height / image!.size.width
                        let newHeight = self.eventImageView.frame.size.width * ratio
                        
                        self.eventImageView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
                    }
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
