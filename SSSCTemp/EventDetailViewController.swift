//
//  EventDetailViewController.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-02-01.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    //MARK: Properties
    
    var event: Event!
    
    @IBOutlet var eventTitleLabel: UILabel!
    @IBOutlet var eventDescriptionTextView: UITextView!
    @IBOutlet var eventDateTimeLabel: UILabel!
    @IBOutlet var eventLocationLabel: UILabel!
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var eventStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventTitleLabel.text = event.name
        eventDescriptionTextView.text = event.description
        eventDateTimeLabel.text = event.month + " " + event.getDayString() + "\n" + event.time
        eventLocationLabel.text = event.location
        
        var frame = self.eventDescriptionTextView.frame
        frame.size.height = self.eventDescriptionTextView.contentSize.height
        print(frame.size.height)
        self.eventDescriptionTextView.frame = frame
        
        eventDescriptionTextView.translatesAutoresizingMaskIntoConstraints = true
        
        view.sendSubview(toBack: eventStackView)
        
        if (event.imageUrl == "") {
            eventImageView.isHidden = true;
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
