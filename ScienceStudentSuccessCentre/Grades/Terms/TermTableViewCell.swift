//
//  TermTableViewCell.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-09-27.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

class TermTableViewCell: UITableViewCell {
    
    @IBOutlet var termName: UILabel!
    @IBOutlet var termAbbr: UILabel!
    @IBOutlet var termView: UIView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = termView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if selected {
            termView.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = termView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            termView.backgroundColor = color
        }
    }
}
