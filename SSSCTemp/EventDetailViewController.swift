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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventTitleLabel.text = event.name
        eventDescriptionTextView.text = event.description
        eventDateTimeLabel.text = event.month + " " + event.getDayString() + "\n" + event.time
        eventLocationLabel.text = event.location
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
