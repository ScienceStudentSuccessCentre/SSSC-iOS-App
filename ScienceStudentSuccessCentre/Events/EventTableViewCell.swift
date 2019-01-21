//
//  EventTableViewCell.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-01-31.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = dateView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if selected {
            dateView.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = dateView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            dateView.backgroundColor = color
        }
    }
    
}

